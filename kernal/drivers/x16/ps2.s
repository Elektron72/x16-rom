;----------------------------------------------------------------------
; Generic PS/2 Port Driver
;----------------------------------------------------------------------
; (C)2019 Michael Steil, License: 2-clause BSD
; (based on "AT-Keyboard" by İlker Fıçıcılar)

.include "io.inc"

; data
.importzp mhz ; [declare]

.export ps2_init, ps2_receive_byte
.export ps2ena, ps2dis

port_ddr  =d2ddrb
port_data =d2prb
bit_data=1              ; 6522 IO port data bit mask  (PA0/PB0)
bit_clk =2              ; 6522 IO port clock bit mask (PA1/PB1)

ps2bits  = $9000
ps2byte  = $9001
ps2parity= $9002
ps2c     = $90ff
ps2q     = $9100
ps2err   = $9180

.segment "KVARSB0"

_ps2byte:
	.res 1           ;    bit input

.segment "PS2"

; inhibit PS/2 communication on both ports
ps2_init:
	ldx #0
:	lda ramcode,x
	sta $9200,x
	inx
	cpx #ramcode_end - ramcode
	bne :-

	lda #$ff
	sta ps2bits
	lda #0
	sta ps2parity

	; VIA#2 CA1/CB1 IRQ: trigger on negative edge
	lda d2pcr
	and #%11101110
	sta d2pcr
	; VIA#2 CA1/CB1 IRQ: enable
	lda #%10010010
	sta d2ier

	ldx #1 ; keyboard
	jsr ps2ena
	ldx #0 ; mouse
	jmp ps2dis

;****************************************
ps2ena_all:
	ldx #1 ; PA: keyboard
	jsr ps2ena
	dex    ; PB: mouse
ps2ena:	lda port_ddr,x ; set CLK and DATA as input
	and #$ff-bit_clk-bit_data
	sta port_ddr,x ; -> bus is idle, device can start sending
	rts

;****************************************
ps2dis_all:
	ldx #1 ; PA: keyboard
	jsr ps2dis
	dex    ; PB: mouse
ps2dis:	lda port_ddr,x
	ora #bit_clk+bit_data
	sta port_ddr,x ; set CLK and DATA as output
	lda port_data,x
	and #$ff - bit_clk ; CLK=0
	ora #bit_data ; DATA=1
	sta port_data,x
	rts

ramcode:
; NMI
	pha
.if 0
	lda d2ifr
	bit #$02
	beq @n_kbd

; Port 0: keyboard
	lda port_data
	; XXX TODO
	pla
	rti

@n_kbd:
	bit #$10
	beq @n_mouse
.endif
; Port 1: mouse
	lda port_data
	and #bit_data
	phx
	ldx ps2bits
	cpx #8
	bcs @n_data_bit

; *********************
; 0-7: data bit
; *********************
	cmp #1
	bcc :+
	inc ps2parity
:	ror ps2byte
@inc_rti:
	inc ps2bits
	plx
	pla
	rti

@n_data_bit:
	bne @n_parity_bit

; *********************
; 8: parity bit
; *********************
	ldx ps2parity
	cmp #1
	bcc :+
	inx
:	txa
	ror
	bcs @inc_rti
	bra @error

@n_parity_bit:
	bpl @n_start ; not -1

; *********************
; -1: start bit
; *********************
	cmp #1
	bcc @inc_rti ; clear = OK
	bra @error

@n_start:
; *********************
; 9: stop bit
; *********************
	cmp #1
	bcc @error ; set = OK
	; If the stop bit is incorrect, inhibiting communication
	; at this late point won't cause a re-send from the
	; device, so effectively, we will only ignore the
	; byte and clear the queue.

	; byte complete
	lda ps2byte
	sta debug_port
	ldx ps2c
	sta ps2q,x
	lda #0
	sta ps2err,x
	inc ps2c

@next_byte:
	lda #0
	sta ps2parity
	ldx #$ff
	stx ps2bits
@pull_rti:
	plx
	pla
	rti

@error:
	; inhibit for 100 µs
	lda port_ddr
	ora #bit_clk+bit_data
	sta port_ddr ; set CLK and DATA as output
	lda port_data
	and #$ff - bit_clk ; CLK=0
	ora #bit_data ; DATA=1
	sta port_data

	; put error into queue
	ldx ps2c
	lda #1
	sta ps2err,x
	inc ps2c

	; start with new byte
	ldx #0
	stx ps2parity
	dex
	stx ps2bits

	php
	cli

	ldx #100/5*mhz
:	dex
	bne :- ; 5 clocks

	plp

	lda port_ddr,x ; set CLK and DATA as input
	and #$ff-bit_clk-bit_data
	sta port_ddr,x ; -> bus is idle, device can start sending
	bra @pull_rti

@n_mouse:
	; NMI button
	pla
	rti

ramcode_end:

;****************************************
; RECEIVE BYTE
; out: A: byte
;      Z: byte available
;           0: yes
;           1: no
;      C:   0: byte OK
;           1: byte error
;****************************************
ps2_receive_byte:
	lda ps2c
	bne @1
	clc
	rts ; Z=1, C=0 -> no data, no error

@1:	; TODO: mask NMI
	lda ps2err
	pha
	ldy ps2q
	ldx #0
:	lda ps2q+1,x
	sta ps2q,x
	lda ps2err+1,x
	sta ps2err,x
	inx
	cpx ps2c
	bne :-
	dec ps2c
	; TODO: unmask NMI
	pla
	ror    ; C=error flag
	tya    ; A=byte
	ldx #1 ; Z=0
	rts
