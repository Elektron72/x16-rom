.include "../geos/inc/geossym.inc"
.include "../geos/inc/jumptab.inc"

; from KERNAL
.import swpp1, jsrfar, color

; from GEOS
.import _ResetHandle, geos_init_vera

;***************
geos	jsr jsrfar
	.word _ResetHandle
	.byte BANK_GEOS

;***************
cscreen	lda #$0e ; light gray
	sta color
	jsr jsrfar
	.word swpp1 ; switch to 40 columns
	.byte BANK_KERNAL

	sei

	jsr jsrfar
	.word geos_init_vera
	.byte BANK_GEOS

	lda #$80
	sta dispBufferOn ; draw to foreground
	lda #1
	jsr jsrfar
	.word SetPattern ; black
	.byte BANK_GEOS

	ldx #32
	ldy #0
	sty 2
	lda #$a0
	sta 3
	tya
:	sta (2),y
	iny
	bne :-
	inc 3
	dex
	bne :-

	rts

linfc	jmp fcerr

;***************
line	jsr frmadr
	lda poker
	sta r3L
	sec
	sbc #<320
	lda poker+1
	sta r3H
	sbc #>320
	bcs linfc
	jsr chkcom
	jsr frmadr
	lda poker
	sta r11L
	sec
	sbc #<200
	lda poker+1
	sbc #>200
	bcs linfc
	jsr chkcom
	jsr frmadr
	lda poker
	sta r4L
	sec
	sbc #<320
	lda poker+1
	sta r4H
	sbc #>320
	bcs linfc
	jsr chkcom
	jsr frmadr
	lda poker
	sta r11H
	sec
	sbc #<200
	lda poker+1
	sbc #>200
	bcs linfc
	lda #0
	sec
	sei
	jsr jsrfar
	.word DrawLine
	.byte BANK_GEOS
	cli
	rts


.if 0
.import _Rectangle
	lda #0
	sta r3L
	sta r3H
	sta r2L
	lda #100
	sta r4L
	lda #0
	sta r4H
	lda #100
	sta r2H
	jsr jsrfar
	.word _Rectangle
	.byte BANK_GEOS
.endif


