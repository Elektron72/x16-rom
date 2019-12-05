; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Graphics library: rectangles

.export GRAPH_draw_rect
.export GRAPH_draw_frame

.segment "GRAPH"

;---------------------------------------------------------------
; GRAPH_draw_rect
;
; Pass:      r0   x1
;            r1   y1
;            r2   x2
;            r3   y2
;            N/C  0/x: draw (dispBufferOn)
;                 1/0: copy FG to BG (imprint)
;                 1/1: copy BG to FG (recover)
; Return:    draws the rectangle
;---------------------------------------------------------------
GRAPH_draw_rect:
	bpl @0
	bcc ImprintRectangle
	bra RecoverRectangle

@0:	PushW r1
@1:	jsr HorizontalLine_NEW
	lda r1L
	inc r1L
	cmp r3L
	bne @1
	PopW r1
	rts

;---------------------------------------------------------------
; RecoverRectangle
;
; Pass:      r0   x1
;            r1   y1
;            r2   x2
;            r3   y2
;---------------------------------------------------------------
RecoverRectangle:
	rts;XXX
	PushW r1
@1:	jsr RecoverLine_NEW
	lda r1L
	inc r1L
	cmp r3L
	bne @1
	PopW r1
	rts

;---------------------------------------------------------------
; ImprintRectangle
;
; Pass:      r0   x1
;            r1   y1
;            r2   x2
;            r3   y2
;---------------------------------------------------------------
ImprintRectangle:
	rts;XXX
	PushW r1
@1:	jsr ImprintLine_NEW
	lda r1L
	inc r1L
	cmp r3L
	bne @1
	PopW r1
	rts

;---------------------------------------------------------------
; GRAPH_draw_frame
;
; Pass:      r0   x1
;            r1   y1
;            r2   x2
;            r3   y2
;---------------------------------------------------------------
GRAPH_draw_frame:
	jsr HorizontalLine_NEW
	PushB r1L
	MoveB r3L, r1L
	jsr HorizontalLine_NEW
	PopB r1L
	PushW r0
	jsr VerticalLine
	MoveW r2, r0
	jsr VerticalLine
	PopW r0
	rts
