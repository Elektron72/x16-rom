.include "../../mac.inc"
.include "../../regs.inc"
.include "../../io.inc"

.export k_GetScanLine
.export GetScanLineFG, GetScanLineBG
.export k_SetVRAMPtr, k_StoreVRAM

.segment "GRAPH"

;---------------------------------------------------------------
; SetVRAMPtr
;
; Function:  Returns the VRAM address of a pixel
; Pass:      r3  x pos
;            x   y pos
; Return:    r5  add of 1st byte of foreground scr
;                (this is also set up in VERA)
;            r6  add of 1st byte of background scr
; Destroyed: a
;---------------------------------------------------------------
k_SetVRAMPtr:
	jsr k_GetScanLine
; fg
	AddW r3, r5
	lda r5L
	sta veralo
	lda r5H
	sta veramid
	lda #$11
	sta verahi
; bg
	AddW r3, r5
	rts

;---------------------------------------------------------------
; StoreVRAM
;
; Function:  Stores a color in VRAM and advances the VRAM pointer
; Pass:      a   color
;            x   y pos
; Destroyed: preserves all registers
;---------------------------------------------------------------
k_StoreVRAM:
	sta veradat
	rts

;---------------------------------------------------------------
; GetScanLine                                             $C13C
;
; Function:  Returns the address of the beginning of a scanline
; Pass:      x   scanline nbr
; Return:    r5  add of 1st byte of foreground scr
;            r6  add of 1st byte of background scr
; Destroyed: a
;---------------------------------------------------------------
k_GetScanLine:
	jsr GetScanLineFG
	jmp GetScanLineBG

GetScanLineFG:
	; r5 = x * 320
	stz r5H
	txa
	asl
	rol r5H
	asl
	rol r5H
	asl
	rol r5H
	asl
	rol r5H
	asl
	rol r5H
	asl
	rol r5H
	sta r5L
	sta veralo
	txa
	clc
	adc r5H
	sta r5H
	sta veramid
	lda #$11
	sta verahi
	rts

GetScanLineBG:
; For BG storage, we have to work with 8 KB banks.
; Lines are 320 bytes, and 8 KB is not divisible by 320,
; so the base address of certain lines would be so close
; to the top of a bank that lda (r6),y shoots over the
; end. Therefore, we need to add memory gaps at certain
; lines to jump over the bank boundaries.
	cpx #25
	bcc @1
	inx
	cpx #51
	bcc @1
	inx
	cpx #76
	bcc @1
	inx
	cpx #102
	bcc @1
	inx
	cpx #128
	bcc @1
	inx
	cpx #153
	bcc @1
	inx
	cpx #179
	bcc @1
	inx
	cpx #204
	bcc @1
	inx
@1:
	stz r6H
	txa
	asl
	rol r6H
	asl
	rol r6H
	asl
	rol r6H
	asl
	rol r6H
	asl
	rol r6H
	asl
	rol r6H
	sta r6L
	txa
	clc
	adc r6H
	sta r6H

	lda r6H
	pha
	and #$1f
	ora #$a0
	sta r6H
	pla
	ror ; insert the carry from addition above, since the BG
	    ; data exceeds 64 KB because of the added gaps
	lsr
	lsr
	lsr
	lsr
	inc       ; start at bank 1
	sta d1pra ; RAM bank
	rts

.global inc_bgpage

inc_bgpage:
	pha
	inc r6H
	lda r6H
	cmp #$c0
	beq @1
	pla
	rts
@1:	inc d1pra ; RAM bank
	lda #$a0
	sta r6H
	pla
	rts
