
.import sdcard_init

.import fat32_init

.import fat32_dirent

.importzp filenameptr, krn_ptr1, krn_ptr3, dirptr, read_blkptr, buffer, bank_save

; cmdch.s
.import ciout_cmdch, execute_command, set_status, acptr_status

; dir.s
.import open_dir, acptr_dir, read_dir
.export channel, fd_for_channel, ieee_status
.export MAGIC_FD_DIR_LOAD, MAGIC_FD_EOF

; geos.s
.import cbmdos_GetNxtDirEntry, cbmdos_Get1stDirEntry, cbmdos_CalcBlksFree, cbmdos_GetDirHead, cbmdos_ReadBlock, cbmdos_ReadBuff, cbmdos_OpenDisk

.include "banks.inc"

;.include "common.inc"
IMPORTED_FROM_MAIN=1

.feature labels_without_colons

.include "fat32.inc"
.include "fcntl.inc"
;.include "65c02.inc"

.include "regs.inc"


ieee_status = status

via1        = $9f60
via1porta   = via1+1 ; RAM bank

.macro BANKING_START
	pha
	lda via1porta
	sta bank_save
	stz via1porta
	pla
.endmacro

.macro BANKING_END
	pha
	lda bank_save
	sta via1porta
	pla
.endmacro

.segment "cbdos_data"

fnbuffer:
	.res 256, 0

; Commodore DOS variables
initialized:
	.byte 0
MAGIC_INITIALIZED  = $7A
listen_cmd:
	.byte 0
channel:
	.byte 0
is_receiving_filename:
	.byte 0
fnbuffer_w:
	.byte 0

fd_for_channel:
	.res 16, 0
MAGIC_FD_NONE     = $ff
MAGIC_FD_STATUS   = $fe
MAGIC_FD_DIR_LOAD = $fd
MAGIC_FD_EOF      = $fc


.segment "cbdos"
; $C000

	jmp cbdos_secnd
	jmp cbdos_tksa
	jmp cbdos_acptr
	jmp cbdos_ciout
	jmp cbdos_untlk
	jmp cbdos_unlsn
	jmp cbdos_listn
	jmp cbdos_talk
; GEOS
	jmp cbmdos_OpenDisk
	jmp cbmdos_ReadBuff
	jmp cbmdos_ReadBlock
	jmp cbmdos_GetDirHead
	jmp cbmdos_CalcBlksFree
	jmp cbmdos_Get1stDirEntry
	jmp cbmdos_GetNxtDirEntry

; detection
	jmp cbdos_sdcard_detect

;---------------------------------------------------------------
; Initialize CBDOS data structures
;
; This has to be done once and is triggered by
; cbdos_sdcard_detect.
;---------------------------------------------------------------
cbdos_init:
	lda #MAGIC_INITIALIZED
	cmp initialized
	bne :+
	rts

:	sta initialized
	phx
	phy

	ldx #14
	lda #MAGIC_FD_NONE
:	sta fd_for_channel,x
	dex
	bpl :-

	lda #MAGIC_FD_STATUS
	sta fd_for_channel + 15

	lda #$73
	jsr set_status

	ply
	plx
	rts

;---------------------------------------------------------------
; Detect SD card
;
; Returns Z=1 if SD card is present
;---------------------------------------------------------------
cbdos_sdcard_detect:
	BANKING_START
	jsr cbdos_init
	jsr sdcard_init ; C=0: error
	lda #0
	rol
	eor #1          ; Z=0: error
	BANKING_END
	rts

;---------------------------------------------------------------
; LISTEN
;
; Nothing to do.
;---------------------------------------------------------------
cbdos_listn:
	rts

;---------------------------------------------------------------
; SECOND (after LISTEN)
;
;   In:   a    secondary address
;---------------------------------------------------------------
cbdos_secnd:
	BANKING_START
	phx
	phy

	; The upper nybble is the command:
	; $Fx OPEN
	;     The bytes sent by the host until UNLISTEN will be
	;     a filename to be associated with the given channel.
	; $6x LISTEN
	;     The bytes sent by the host until UNLISTEN will be
	;     received into the given channel. (The channel has
	;     to be open.)
	; $Ex CLOSE
	;     Close the given channel, no more bytes will be sent
	;     to it.

; separate into cmd and channel
	tax
	and #$f0
	sta listen_cmd ; we need it for UNLISTEN
	txa
	and #$0f
	sta channel

; special-case command channel:
; ignore OPEN/CLOSE
	cmp #15
	beq @secnd_rts

	stz is_receiving_filename

	lda listen_cmd
	cmp #$f0
	beq @secnd_open
	cmp #$e0
	bne @secnd_rts

;---------------------------------------------------------------
; CLOSE
@secnd_close:
	; XXX fill this when closing files that have been written to
	bra @secnd_rts

;---------------------------------------------------------------
; Initiate OPEN
@secnd_open:
	inc is_receiving_filename
	stz fnbuffer_w

@secnd_rts:
	ply
	plx
	BANKING_END
	rts

;---------------------------------------------------------------
; CIOUT (send)
;---------------------------------------------------------------
cbdos_ciout:
	BANKING_START
	phx
	phy

	ldx channel
	cpx #15
	beq @ciout_cmdch

	ldx is_receiving_filename
	bne @ciout_filename

	brk ; XXX TODO receiving data

@ciout_filename:
	ldy fnbuffer_w
	sta fnbuffer,y
	inc fnbuffer_w
	; if len(filename) > 256, it will be garbled, but that's ok
	bra @ciout_end

@ciout_cmdch:
	jsr ciout_cmdch

@ciout_end:
	ply
	plx
	BANKING_END
	rts

;---------------------------------------------------------------
; UNLISTEN
;---------------------------------------------------------------
cbdos_unlsn:
	BANKING_START
	phx
	phy

; special-case command channel
	lda channel
	cmp #$0f
	beq @unlisten_cmdch

	lda listen_cmd
	cmp #$f0
	bne @unlsn_end; != OPEN? -> UNLISTEN does nothing

;---------------------------------------------------------------
; Execute OPEN with filename
	; XXX necessary?
	jsr sdcard_init

	lda fnbuffer
	cmp #'$'
	bne @unlsn_open_file

;---------------------------------------------------------------
; OPEN directory
	jsr open_dir
	bcc :+
	lda #$02 ; timeout/file not found
	sta ieee_status
	lda #$62
	jsr set_status
	bra @unlsn_end

:	lda #MAGIC_FD_DIR_LOAD
	ldx channel
	sta fd_for_channel,x ; remember fd
	bra @unlsn_end

;---------------------------------------------------------------
; OPEN file
@unlsn_open_file:
	jsr open_file
	bra @unlsn_end

;---------------------------------------------------------------
; Execute Command
;
; UNLISTEN on command channel will ignore whether it was
; and OPEN command; it will always trigger command execution
@unlisten_cmdch:
	jsr execute_command

@unlsn_end:
	ply
	plx
	BANKING_END
	rts


;---------------------------------------------------------------
; TALK
;
; Nothing to do.
;---------------------------------------------------------------
cbdos_talk:
	rts

;---------------------------------------------------------------
; SECOND (after TALK)
;---------------------------------------------------------------
cbdos_tksa: ; after talk
	BANKING_START
	phx
	phy

	and #$0f
	sta channel

; special-case command channel
	cmp #$0f
	beq @tksa_cmdch

@tksa_switch:

@tksa_end:
	ply
	plx
	BANKING_END
	rts

@empty_channel:
	brk; TODO

@tksa_cmdch:
	bra @tksa_end

;---------------------------------------------------------------
; RECEIVE
;---------------------------------------------------------------
cbdos_acptr:
	BANKING_START
	phx
	phy
	ldx channel
	lda fd_for_channel,x
	bpl @acptrX ; actual file

	cmp #MAGIC_FD_DIR_LOAD
	bne @not_dir
	jsr acptr_dir
	bcc :+
	; clear fd from channel
	ldx channel
	pha
	lda #MAGIC_FD_EOF ; next time, send EOF
	sta fd_for_channel,x
	pla
:	jmp @acptr_end

@not_dir:
 	cmp #MAGIC_FD_STATUS
	bne :+
	jsr acptr_status
	jmp @acptr_end
	cmp #MAGIC_FD_NONE
	beq @acptr_nofd
; else #MAGIC_FD_EOF


; EOF
@eof:
	lda #$40
	bra :+
@acptr_nofd
; no fd
	lda #$02 ; timeout/file not found
:	sta ieee_status
	lda #0
	ply
	plx
	BANKING_END
	sec
	rts

@acptrX:
	jsr fat32_read_byte
	bcc @eof

@acptr_end:
	ply
	plx
	BANKING_END
	clc
	rts


;---------------------------------------------------------------
; UNTALK
;---------------------------------------------------------------
cbdos_untlk:
	rts

;---------------------------------------------------------------
open_file:
	jsr fat32_init

	lda #0 ; zero-terminate filename
	ldy fnbuffer_w
	sta fnbuffer,y
	lda #<fnbuffer
	sta fat32_ptr + 0
	lda #>fnbuffer
	sta fat32_ptr + 1
	jsr fat32_open
	lda #0 ; >= 0 FD
	bcs :+
	lda #MAGIC_FD_NONE
:	ldx channel
	sta fd_for_channel,x ; remember fd
	rts

.segment "IRQB"
	.word banked_irq
