.global monitor

.import mouse_config, mouse_get_x, mouse_get_y; [mouse]
.import joystick_scan; [joystick]
.import mouse_config; [mouse]
.import joystick_scan, joystick_get; [joystick]
.import clock_update, clock_get_timer, clock_set_timer, clock_get_time_date, clock_set_time_date; [time]

.import GRAPH_set_window, GRAPH_put_char, GRAPH_get_char_size, GRAPH_set_font, GRAPH_draw_rect, GRAPH_draw_frame, GRAPH_draw_line

.export GRAPH_LL_init
.export GRAPH_LL_get_info
.export GRAPH_LL_start_direct
.export GRAPH_LL_get_pixel
.export GRAPH_LL_get_pixels
.export GRAPH_LL_set_pixel
.export GRAPH_LL_set_pixels
.export GRAPH_LL_set_8_pixels
.export GRAPH_LL_set_8_pixels_opaque
.export GRAPH_LL_fill_pixels
.export GRAPH_LL_filter_pixels
.export GRAPH_LL_move_pixels

	.segment "JMPTBL3"
I_GRAPH_LL_BASE = $9000; XXX

I_GRAPH_LL_init = I_GRAPH_LL_BASE
I_GRAPH_LL_get_info = I_GRAPH_LL_BASE+2
I_GRAPH_LL_start_direct = I_GRAPH_LL_BASE+4
I_GRAPH_LL_get_pixel = I_GRAPH_LL_BASE+6
I_GRAPH_LL_get_pixels = I_GRAPH_LL_BASE+8
I_GRAPH_LL_set_pixel = I_GRAPH_LL_BASE+10
I_GRAPH_LL_set_pixels = I_GRAPH_LL_BASE+12
I_GRAPH_LL_set_8_pixels = I_GRAPH_LL_BASE+14
I_GRAPH_LL_set_8_pixels_opaque = I_GRAPH_LL_BASE+16
I_GRAPH_LL_fill_pixels = I_GRAPH_LL_BASE+18
I_GRAPH_LL_filter_pixels = I_GRAPH_LL_BASE+20
I_GRAPH_LL_move_pixels = I_GRAPH_LL_BASE+22

	
; $FE00
GRAPH_LL_init:
	jmp (I_GRAPH_LL_init)
; $FE03
GRAPH_LL_get_info:
	jmp (I_GRAPH_LL_get_info)
 ; $FE06
 GRAPH_LL_start_direct:
	jmp (I_GRAPH_LL_start_direct)
; $FE09
GRAPH_LL_get_pixel:
	jmp (I_GRAPH_LL_get_pixel)
; $FE0C
GRAPH_LL_get_pixels:
	jmp (I_GRAPH_LL_get_pixels)
; $FE0F
GRAPH_LL_set_pixel:
	jmp (I_GRAPH_LL_set_pixel)
; $FE12
GRAPH_LL_set_pixels:
	jmp (I_GRAPH_LL_set_pixels)
; $FE15
GRAPH_LL_set_8_pixels:
	jmp (I_GRAPH_LL_set_8_pixels)
; $FE18
GRAPH_LL_set_8_pixels_opaque:
	jmp (I_GRAPH_LL_set_8_pixels_opaque)
; $FE1B
GRAPH_LL_fill_pixels:
	jmp (I_GRAPH_LL_fill_pixels)
; $FE1E
GRAPH_LL_filter_pixels:
	jmp (I_GRAPH_LL_filter_pixels)
; $FE21
GRAPH_LL_move_pixels:
	jmp (I_GRAPH_LL_move_pixels)

	.segment "JMPTBL2"
; *** this is space for new X16 KERNAL vectors ***
; for now, these are private API, they have not been
; finalized

; $FF00: MONITOR
	jmp monitor
; $FF03 restore_basic
	jmp restore_basic
; $FF06: joystick_scan
	jmp joystick_scan
; $FF09: mouse_config
	jmp mouse_config
; $FF0C: clock_set_time_date
	jmp clock_set_time_date
; $FF0F: clock_get_time_date
	jmp clock_get_time_date
; $FF12: mouse_get_x
	jmp mouse_get_x
; $FF15: mouse_get_y
	jmp mouse_get_y
; $FF18: joystick_get
	jmp joystick_get


; $FF1B: GRAPH_set_window [TODO]
	jmp GRAPH_set_window
; $FF1E: GRAPH_set_options [TODO]
	jmp $ffff;GRAPH_set_options
; $FF21: GRAPH_set_colors
	jmp GRAPH_set_colors
; $FF24: void GRAPH_LL_start_direct(word x, word y);
	jmp GRAPH_LL_start_direct
; $FF27: void GRAPH_LL_set_pixel(byte color);
	jmp GRAPH_LL_set_pixel
;XX GRAPH_LL_set_pixels [TODO]
;XX	jmp $ffff;GRAPH_LL_set_pixels
; $FF2A: byte GRAPH_LL_get_pixel(word x, word y);
	jmp GRAPH_LL_get_pixel
;XX GRAPH_LL_get_pixels [TODO]
;XX	jmp $ffff;GRAPH_LL_get_pixels
; $FF2D: void GRAPH_LL_filter_pixels(word num, word ptr);
	jmp GRAPH_LL_filter_pixels

; $FF30: void GRAPH_draw_line(word x1, word y1, word x2, word y2, byte flags);
	jmp GRAPH_draw_line
; $FF33: void GRAPH_draw_frame(word x1, word y1, word x2, word y2);
	jmp GRAPH_draw_frame
; $FF36: void GRAPH_draw_rect(word x1, word y1, word x2, word y2, byte flags);
	jmp GRAPH_draw_rect
; $FF39: GRAPH_move_rect [TODO]
	jmp $ffff;GRAPH_move_rect

; $FF3C: void GRAPH_set_font(void ptr);
	jmp GRAPH_set_font
; $FF3F: (byte baseline, byte width, byte height) GRAPH_get_char_size(byte c, byte mode);
	jmp GRAPH_get_char_size
; $FF42: void GRAPH_put_char(inout word x, inout word y, byte c);
	jmp GRAPH_put_char

	.segment "JMPTB128"
; C128 KERNAL API
;
; We are trying to support as many C128 calls as possible.
; Some make no sense on the X16 though, usually because
; their functionality is C128-specific.

; $FF47: SPIN_SPOUT – setup fast serial ports for I/O
	; UNSUPPORTED
	; no fast serial support
	.byte 0,0,0
; $FF4A: CLOSE_ALL – close all files on a device
	; COMPATIBLE
	jmp close_all
; $FF4D: C64MODE – reconfigure system as a C64
	; UNSUPPORTED
	; no C64 compatibility support
	.byte 0,0,0
; $FF50: DMA_CALL – send command to DMA device
	; UNSUPPORTED
	; no support for Commodore REU devices
	.byte 0,0,0
; $FF53: BOOT_CALL – boot load program from disk
	; TODO
	; We need better disk support first.
	.byte 0,0,0
; $FF56: PHOENIX – init function cartridges
	; UNSUPPORTED
	; no external ROM support
	.byte 0,0,0
; $FF59: LKUPLA
	; COMPATIBLE
	jmp lkupla
; $FF5C: LKUPSA
	; COMPATIBLE
	jmp lkupsa
; $FF5F: SCRMOD – get/set screen mode
	; NOT COMPATIBLE
	; On the C128, this is "SWAPPER", which takes no arguments
	; and switches between 40/80 column text modes.
	jmp scrmod
; $FF62: DLCHR – init 80-col character RAM
	; UNSUPPORTED
	; VDC8563-specific
	; XXX use this call to  upload the charset
	.byte 0,0,0
; $FF65: PFKEY – program a function key
	; TODO
	; Currently, the fkey strings are stored in ROM.
	; In order to make them editable, 256 bytes of RAM are
	; required. (C128: PKYBUF, PKYDEF)
	.byte 0,0,0
; $FF68: SETBNK – set bank for I/O operations
	; UNSUPPORTED
	; To keep things simple, the X16 KERNAL APIs do not
	; support banking. Data for use with KERNAL APIs must be
	; in non-banked RAM < $9F00.
	.byte 0,0,0
; $FF6B: GETCFG – lookup MMU data for given bank
	; UNSUPPORTED
	; no MMU
	.byte 0,0,0
; $FF6E: JSRFAR – gosub in another bank
	; NOT COMPATIBLE
	; This call takes the address (2 bytes) and bank (1 byte)
	; from the instruction stream.
	jmp jsrfar
; $FF71: JMPFAR – goto another bank
	; TODO/UNSUPPORTED
	; Not sure we want this. It is not very useful, and would
	; require a lot of new code.
	.byte 0,0,0
; $FF74: FETCH – LDA (fetvec),Y from any bank
	; COMPATIBLE
	jmp indfet
; $FF77: STASH – STA (stavec),Y to any bank
	; COMPATIBLE
	jmp stash       ; (*note* user must setup 'stavec')
; $FF7A: CMPARE – CMP (cmpvec),Y to any bank
	; COMPATIBLE
	jmp cmpare      ; (*note*  user must setup 'cmpvec')
; $FF7D: PRIMM – print string following the caller’s code
	; COMPATIBLE
	jmp primm


	.segment "JMPTBL"

	;KERNAL revision
.ifdef PRERELEASE_VERSION
	.byte <(-PRERELEASE_VERSION)
.elseif .defined(RELEASE_VERSION)
	.byte RELEASE_VERSION
.else
	.byte $ff       ;custom pre-release version
.endif

	jmp cint
	jmp ioinit
	jmp ramtas

	jmp restor      ;restore vectors to initial system
	jmp vector      ;change vectors for user

	jmp setmsg      ;control o.s. messages
	jmp secnd       ;send sa after listen
	jmp tksa        ;send sa after talk
	jmp memtop      ;set/read top of memory
	jmp membot      ;set/read bottom of memory
	jmp kbd_scan    ;scan keyboard
	jmp settmo      ;set timeout in ieee
	jmp acptr       ;handshake ieee byte in
	jmp ciout       ;handshake ieee byte out
	jmp untlk       ;send untalk out ieee
	jmp unlsn       ;send unlisten out ieee
	jmp listn       ;send listen out ieee
	jmp talk        ;send talk out ieee
	jmp readst      ;return i/o status byte
	jmp setlfs      ;set la, fa, sa
	jmp setnam      ;set length and fn adr
open	jmp (iopen)     ;open logical file
close	jmp (iclose)    ;close logical file
chkin	jmp (ichkin)    ;open channel in
ckout	jmp (ickout)    ;open channel out
clrch	jmp (iclrch)    ;close i/o channel
basin	jmp (ibasin)    ;input from channel
bsout	jmp (ibsout)    ;output to channel
	jmp loadsp      ;load from file
	jmp savesp      ;save to file
	jmp clock_set_timer ;set internal clock (SETTIM)
	jmp clock_get_timer ;read internal clock (RDTIM)
stop	jmp (istop)     ;scan stop key
getin	jmp (igetin)    ;get char from q
clall	jmp (iclall)    ;close all files
	jmp clock_update ;increment clock (UDTIM)
jscrog	jmp scrorg      ;screen org
jplot	jmp plot        ;read/set x,y coord
jiobas	jmp iobase      ;return i/o base

	;signature
	.byte "MIST"

	.segment "VECTORS"
	.word nmi        ;program defineable
	.word start      ;initialization code
	.word puls       ;interrupt handler

