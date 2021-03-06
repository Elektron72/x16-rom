; #LAYOUT# STD *        #TAKE
; #LAYOUT# *   KERNAL_0 #TAKE
; #LAYOUT# *   *        #IGNORE

;
; Variables used:
; - BLNSW (cursor blink switch)
; - BLNCT (cursor blink countdown)
; - GDBLN (cursor saved character)
; - BLNON (if cursor is visible)
; - GDCOL (colour under cursor)
; - USER  (current screen line colour pointer)
; - PNT   (current screen line pointer)
; - PNTR  (current screen x position)
;


cursor_blink:
	; Is the cursor enabled?
	lda BLNSW
	bne cursor_blink_end

	; Do we need to redraw things?
	dec BLNCT
	bpl cursor_blink_end

	; Check if cursor was visible or not, and toggle
	lda BLNON
	bne cursor_undraw

	; FALLTROUGH

cursor_draw:

	jsr screen_get_clipped_PNTR
	jsr screen_get_char
	sta GDBLN
	eor #$80
	jsr screen_set_char
	; Also set cursor colour
	jsr screen_get_color
	sta GDCOL
	lda COLOR
	jsr screen_set_color

	lda #1
	sta BLNON

	bne cursor_blink_timer_reset ; branches always

cursor_disable:
	lda #$80
	sta BLNSW

	; FALLTHROUGH

cursor_hide_if_visible:
	lda BLNON
	beq cursor_blink_end

cursor_undraw:

	jsr screen_get_clipped_PNTR
	lda GDBLN
	jsr screen_set_char
	lda GDCOL
	jsr screen_set_color
	
	lda #0
	sta BLNON

	; FALLTROUGH

cursor_blink_timer_reset:

	; Rest blink counter (Mapping the 64, p39-40)
	lda #20
	sta BLNCT

	; FALLTROUGH

cursor_blink_end:
	rts
