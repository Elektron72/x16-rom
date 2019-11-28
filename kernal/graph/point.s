; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Graphics library: TestPoint, DrawPoint, DrawLine syscalls

.include "../../regs.inc"
.include "../../io.inc"
.include "../../mac.inc"

.setcpu "65c02"

.import k_Dabs
.import k_SetVRAMPtrFG, k_SetVRAMPtrBG
.import HorizontalLine
.import VerticalLine
.import ImprintLine
.import RecoverLine

.import k_dispBufferOn
.import k_col1

.global k_DrawLine
.global k_TestPoint
.global DrawPoint

.segment "GRAPH"

;---------------------------------------------------------------
; DrawLine
;
; Pass:      N/C      0x: draw (dispBufferOn)
;                     10: copy FG to BG (imprint)
;                     11: copy BG to FG (recover)
;            r3       x pos of 1st point (0-319)
;            r11L     y pos of 1st point (0-199)
;            r4       x pos of 2nd point (0-319)
;            r11H     y pos of 2nd point (0-199)
; Return:    -
; Destroyed: a, x, y, r4 - r8, r11
;---------------------------------------------------------------
k_DrawLine:
	php
	CmpB r11L, r11H    ; horizontal?
	bne @0a            ; no
	bmi @0b            ; imprint/recover?
	plp
	jmp HorizontalLine
@0b:	plp
	bcc @c             ; imprint
	jmp RecoverLine
@c:	jmp ImprintLine

@0a:	plp
	bmi @0             ; imprint/recover? slow path
	CmpW r3, r4        ; vertical?
	bne @0             ; no
	PushW r3
	MoveW r11, r3
	jsr VerticalLine
	PopW r3
	rts

@0:	php
	LoadB r7H, 0
	lda r11H
	sub r11L
	sta r7L
	bcs @1
	lda #0
	sub r7L
	sta r7L
@1:	lda r4L
	sub r3L
	sta r12L
	lda r4H
	sbc r3H
	sta r12H
	ldx #r12
	jsr k_Dabs
	CmpW r12, r7
	bcs @2
	jmp @9
@2:
	lda r7L
	asl
	sta r9L
	lda r7H
	rol
	sta r9H
	lda r9L
	sub r12L
	sta r8L
	lda r9H
	sbc r12H
	sta r8H
	lda r7L
	sub r12L
	sta r10L
	lda r7H
	sbc r12H
	sta r10H
	asl r10L
	rol r10H
	LoadB r13L, $ff
	CmpW r3, r4
	bcc @4
	CmpB r11L, r11H
	bcc @3
	LoadB r13L, 1
@3:	ldy r3H
	ldx r3L
	MoveW r4, r3
	sty r4H
	stx r4L
	MoveB r11H, r11L
	bra @5
@4:	ldy r11H
	cpy r11L
	bcc @5
	LoadB r13L, 1
@5:	lda k_col1
	plp
	php
	jsr DrawPoint
	CmpW r3, r4
	bcs @8
	inc r3L
	bne @6
	inc r3H
@6:	bbrf 7, r8H, @7
	AddW r9, r8
	bra @5
@7:	AddB_ r13L, r11L
	AddW r10, r8
	bra @5
@8:	plp
	rts
@9:	lda r12L
	asl
	sta r9L
	lda r12H
	rol
	sta r9H
	lda r9L
	sub r7L
	sta r8L
	lda r9H
	sbc r7H
	sta r8H
	lda r12L
	sub r7L
	sta r10L
	lda r12H
	sbc r7H
	sta r10H
	asl r10L
	rol r10H
	LoadW r13, $ffff
	CmpB r11L, r11H
	bcc @B
	CmpW r3, r4
	bcc @A
	LoadW r13, 1
@A:	MoveW r4, r3
	ldx r11L
	lda r11H
	sta r11L
	stx r11H
	bra @C
@B:	CmpW r3, r4
	bcs @C
	LoadW r13, 1
@C:	lda k_col1
	plp
	php
	jsr DrawPoint
	CmpB r11L, r11H
	bcs @E
	inc r11L
	bbrf 7, r8H, @D
	AddW r9, r8
	bra @C
@D:	AddW r13, r3
	AddW r10, r8
	bra @C
@E:	plp
	rts

;---------------------------------------------------------------
; DrawPoint                                               $C133
;
; Pass:      N/C      0x: draw (dispBufferOn)
;                     10: copy FG to BG (imprint)
;                     11: copy BG to FG (recover)
;            r3       x pos of point (0-319)
;            r11L     y pos of point (0-199)
; Return:    -
; Destroyed: a, x, y, r5 - r6
;---------------------------------------------------------------
DrawPoint:
	bmi @3
	bbrf 7, k_dispBufferOn, @1 ; ST_WR_FORE

	ldx r11L
	jsr k_SetVRAMPtrFG
	lda k_col1
	sta veradat

@1:	bbrf 6, k_dispBufferOn, @2 ; ST_WR_BACK
	ldx r11L
	jsr k_SetVRAMPtrBG
	lda k_col1
	sta (r6)
@2:	rts
; imprint/recover
@3:	php
	ldx r11L
	jsr k_SetVRAMPtrFG
	jsr k_SetVRAMPtrBG
	plp
	bcc @4
; recover
	lda (r6)
	sta veradat
	rts
; imprint
@4:	lda veradat
	sta (r6)
	rts

;---------------------------------------------------------------
; TestPoint                                               $C13F
;
; Pass:      r3   x position of pixel (0-319)
;            r11L y position of pixel (0-199)
; Return:    a    color of pixel
; Destroyed: a, x, y, r5, r6
;---------------------------------------------------------------
k_TestPoint:
	bbrf 7, k_dispBufferOn, @1 ; ST_WR_FORE
	ldx r11L
	jsr k_SetVRAMPtrFG
	lda veradat
	rts

@1:	bbrf 6, k_dispBufferOn, @2 ; ST_WR_BACK
	ldx r11L
	jsr k_SetVRAMPtrBG
	lda (r6)
	rts

@2:	lda #0
	rts
