.include "../geos/inc/geosmac.inc"
.include "../geos/inc/geossym.inc"
.include "../geos/inc/const.inc"
.include "../geos/inc/jumptab.inc"

.setcpu "65c02"

; from KERNAL
; XXX TODO these should go through the jump table
.import scrmod
.import GRAPH_draw_line, GRAPH_draw_rect, GRAPH_draw_frame, GRAPH_start_direct, GRAPH_set_pixel
.import k_UseSystemFont, GRAPH_put_char


; from GEOS
.import _ResetHandle, GRAPH_set_colors

;***************
geos	jsr bjsrfar
	.word _ResetHandle
	.byte BANK_GEOS

;***************
cscreen
	jsr getbyt
	txa
	sec
	jsr bjsrfar
	.word scrmod ; switch to 320x240@256c + 40x30 text
	.byte BANK_KERNAL
	bcc :+
	jmp fcerr
:	rts

;***************
pset:	jsr get_point
	sta r11L
	jsr get_col
	pha
	sei
	MoveW r3, r0
	MoveB r11L, r1L
	jsr bjsrfar
	.word GRAPH_start_direct
	.byte BANK_KERNAL
	pla
	jsr bjsrfar
	.word GRAPH_set_pixel
	.byte BANK_KERNAL
	cli
	rts

;***************
line	jsr get_points_col
	stx r11L
	sty r11H
	lda #0 ; set
	sei
	jsr bjsrfar
	.word GRAPH_draw_line
	.byte BANK_KERNAL
	cli
	rts

;***************
frame	jsr get_points
	stx r2L
	sty r2H
	jsr normalize_rect
	jsr get_col
	jsr set_col ; needed to hint non-compat mode
	sei
	jsr bjsrfar
	.word GRAPH_draw_frame
	.byte BANK_KERNAL
	cli
	rts

;***************
rect	jsr get_points_col
	stx r2L
	sty r2H
	jsr normalize_rect
	sei
	jsr bjsrfar
	.word GRAPH_draw_rect
	.byte BANK_KERNAL
	cli
	rts

;***************
char	jsr get_point
	sta r1H
	MoveW r3, r11

	jsr chkcom
	jsr getbyt
	txa
	jsr set_col

	jsr chkcom
	jsr frmevl
	jsr chkstr

	ldy #0
	lda (facmo),y
	sta r14L ; length
	iny
	lda (facmo),y
	sta r15L ; pointer lo
	iny
	lda (facmo),y
	sta r15H ; pointer hi

	sei
	lda #$92 ; Ctrl+0: clear attributes
	jsr bjsrfar
	.word GRAPH_put_char
	.byte BANK_KERNAL
	cli

	ldy #0
:	lda (r15),y
	phy
	jsr bjsrfar
	.word GRAPH_put_char
	.byte BANK_KERNAL
	ply
	iny
	cpy r14L
	bne :-

	jmp frefac

linfc	jmp fcerr

get_point:
	jsr frmadr
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
	rts

get_col:
	ldy #0
	lda (txtptr),y
	bne @1
	lda #0
	rts
@1:	jsr chkcom
	jsr getbyt
	txa
	rts

set_col:
	ldx #15 ; secondary color:  light gray
	ldy #1  ; background color: white
	sei
	jsr bjsrfar
	.word GRAPH_set_colors
	.byte BANK_KERNAL
	cli
	rts

get_points:
	jsr get_point
	pha
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
	pha
	sec
	sbc #<200
	lda poker+1
	sbc #>200
	bcs linfc
	ply
	plx
	rts

get_points_col:
	jsr get_points
	phx
	phy
	jsr get_col
	jsr set_col
	ply
	plx
	rts

@2	jmp snerr

normalize_rect:
; make sure y2 >= y1
	lda r2H
	cmp r2L
	bcs @1
	ldx r2L
	stx r2H
	sta r2L
; make sure x2 >= x1
@1:	lda r4L
	sec
	sbc r3L
	lda r4H
	sbc r3H
	bcs @2
	lda r3L
	ldx r4L
	stx r3L
	sta r4L
	lda r3H
	ldx r4H
	stx r3H
	sta r4H
@2:	rts
