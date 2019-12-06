; Commander X16 KERNAL
; (Bresenham code from GEOS by Berkeley Softworks)
;
; Graphics library: GRAPH_draw_line syscall

.export GRAPH_draw_line

.segment "GRAPH"

;---------------------------------------------------------------
; GRAPH_draw_line
;
; Pass:      r0       x1
;            r1       y2
;            r2       x1
;            r3       y2
;            N/C      0/x: draw (dispBufferOn)
;                     1/0: copy FG to BG (imprint)
;                     1/1: copy BG to FG (recover)
;---------------------------------------------------------------
GRAPH_draw_line:
	php
	CmpB r1L, r3L      ; horizontal?
	bne @0a            ; no
	bmi @0b            ; imprint/recover?
	plp
	jmp HorizontalLine
@0b:	plp
	bcc @c             ; imprint
	jmp RecoverLine
@c:
	jmp ImprintLine

@0a:	plp
	bmi @0             ; imprint/recover? slow path
	php
	CmpW r0, r2        ; vertical?
	bne @0             ; no
	plp
	jmp VerticalLine

; Bresenham
@0:	plp
	php
	LoadB r7H, 0
	lda r3L
	sub r1L
	sta r7L
	bcs @1
	lda #0
	sub r7L
	sta r7L
@1:	lda r2L
	sub r0L
	sta r12L
	lda r2H
	sbc r0H
	sta r12H
	ldx #r12
	jsr abs
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
	CmpW r0, r2
	bcc @4
	CmpB r1L, r3L
	bcc @3
	LoadB r13L, 1
@3:	ldy r0H
	ldx r0L
	MoveW r2, r0
	sty r2H
	stx r2L
	MoveB r3L, r1L
	bra @5
@4:	ldy r3L
	cpy r1L
	bcc @5
	LoadB r13L, 1
@5:	lda col1
	plp
	php
	jsr draw_point
	CmpW r0, r2
	bcs @8
	inc r0L
	bne @6
	inc r0H
@6:	bbrf 7, r8H, @7
	AddW r9, r8
	bra @5
@7:	AddB_ r13L, r1L
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
	CmpB r1L, r3L
	bcc @B
	CmpW r0, r2
	bcc @A
	LoadW r13, 1
@A:	MoveW r2, r0
	ldx r1L
	lda r3L
	sta r1L
	stx r3L
	bra @C
@B:	CmpW r0, r2
	bcs @C
	LoadW r13, 1
@C:	lda col1
	plp
	php
	jsr draw_point
	CmpB r1L, r3L
	bcs @E
	inc r1L
	bbrf 7, r8H, @D
	AddW r9, r8
	bra @C
@D:	AddW r13, r0
	AddW r10, r8
	bra @C
@E:	plp
	rts

; calc abs of word in zp at location .x
abs:
	lda 1,x
	bmi @0
	rts
@0:	lda 1,x
	eor #$FF
	sta 1,x
	lda 0,x
	eor #$FF
	sta 0,x
	inc 0,x
	bne @1
	inc 1,x
@1:	rts

;---------------------------------------------------------------
; draw_point
;
; Pass:      N/C      0/x: draw (dispBufferOn)
;                     1/0: copy FG to BG (imprint)
;                     1/1: copy BG to FG (recover)
;            r0       x pos of point
;            r1L      y pos of point
; Return:    -
; Destroyed: a, x, y, r5
;---------------------------------------------------------------
draw_point:
	bmi @3
	bbrf 7, k_dispBufferOn, @1 ; ST_WR_FORE

	jsr SetVRAMPtrFG
	lda col1
	sta veradat

@1:	bbrf 6, k_dispBufferOn, @2 ; ST_WR_BACK
	jsr SetVRAMPtrBG
	lda col1
	sta (ptr_bg)
@2:	rts
; imprint/recover
@3:	php
	jsr SetVRAMPtrFG
	jsr SetVRAMPtrBG
	plp
	bcc @4
; recover
	lda (ptr_bg)
	sta veradat
	rts
; imprint
@4:	lda veradat
	sta (ptr_bg)
	rts
