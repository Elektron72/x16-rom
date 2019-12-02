; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Console I/O: PutString syscall

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"
.include "../../banks.inc"

.import _PutChar
.global _PutString

.segment "conio3a"

_PutString:
	ldy #0
	lda (r0),y
	beq @2
	jsr _PutChar
	inc r0L
	bne @1
	inc r0H
@1:	bra _PutString
@2:	rts

;-------

.macro jsrfar addr
	php
	pha
	MoveW g_curIndexTable, curIndexTable
	MoveB g_baselineOffset, baselineOffset
	MoveW g_curSetWidth, curSetWidth
	MoveB g_curHeight, curHeight
	MoveW g_cardDataPntr, cardDataPntr
	MoveB g_currentMode, currentMode
	MoveB g_windowTop, windowTop
	MoveB g_windowBottom, windowBottom
	MoveW g_leftMargin, leftMargin
	MoveW g_rightMargin, rightMargin
	pla
	plp
	jsr gjsrfar
	.word addr
	.byte BANK_KERNAL
	pha
	MoveW curIndexTable, g_curIndexTable
	MoveB baselineOffset, g_baselineOffset
	MoveW curSetWidth, g_curSetWidth
	MoveB curHeight, g_curHeight
	MoveW cardDataPntr, g_cardDataPntr
	MoveB currentMode, g_currentMode
	MoveB windowTop, g_windowTop
	MoveB windowBottom, g_windowBottom
	MoveW leftMargin, g_leftMargin
	MoveW rightMargin, g_rightMargin
	pla
.endmacro


; FONT VARS
.importzp curIndexTable
.import baselineOffset, curSetWidth, curHeight, cardDataPntr, currentMode, windowTop, windowBottom, leftMargin, rightMargin

.import gjsrfar

.import k_FontPutChar, k_GetCharWidth, k_GetRealSize, k_LoadCharSet, k_SmallPutChar, k_UseSystemFont, k_PutChar

.export FontPutChar, _GetCharWidth, _GetRealSize, _LoadCharSet, _SmallPutChar, _UseSystemFont, _PutCharK

FontPutChar:
	php
	sei
	jsrfar k_FontPutChar
	plp
	rts

_GetCharWidth:
	php
	sei
	jsrfar k_GetCharWidth
	plp
	rts

_GetRealSize:
	php
	sei
	jsrfar k_GetRealSize
	plp
	rts

_LoadCharSet:
	php
	sei
	jsrfar k_LoadCharSet
	plp
	rts

;---------------------------------------------------------------
; SmallPutChar                                            $C202
;
; Pass:      same as PutChar, but must be sure that
;            everything is OK, there is no checking
; Return:    same as PutChar
; Destroyed: same as PutChar
;---------------------------------------------------------------
_SmallPutChar:
	php
	sei
	jsrfar k_SmallPutChar
	plp
	rts

_UseSystemFont:
	php
	sei
	jsrfar k_UseSystemFont
	plp
	rts

_PutCharK:
	php
	sei
	jsrfar k_PutChar
	plp
	rts
