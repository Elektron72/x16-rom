.macro branch_16 target, opcode8, opcode16
.if     .def(target) .and ((*+2)-(target) <= 127)
.byte opcode8
.byte (target - * - 2) & $ff
.else
.byte opcode16
.word (target - * - 2) & $ffff
.endif
.endmacro

.macro bpl_16 target
branch_16 target, $10, $13
.endmacro
.macro bmi_16 target
branch_16 target, $30, $33
.endmacro
.macro bvc_16 target
branch_16 target, $50, $53
.endmacro
.macro bvs_16 target
branch_16 target, $70, $73
.endmacro
.macro bra_16 target
branch_16 target, $80, $83
.endmacro
.macro bcc_16 target
branch_16 target, $90, $93
.endmacro
.macro bcs_16 target
branch_16 target, $b0, $b3
.endmacro
.macro bne_16 target
branch_16 target, $d0, $d3
.endmacro
.macro beq_16 target
branch_16 target, $f0, $f3
.endmacro

.macro phx_trash_a
	txa
	pla
.endmacro

.macro plx_trash_a
	pla
	tax
.endmacro

.macro phy_trash_a
	tya
	pla
.endmacro

.macro ply_trash_a
	pla
	tay
.endmacro

.macro skip_2_bytes_trash_nvz
	.byte $2c
.endmacro

chkin_iec:
chrin_iec:
chrout_iec:
ckout_iec:
close_iec:
clrchn_iec:
load_iec:
open_iec:
save_iec:
ACPTR:
LISTEN:
SECOND:
TKSA:
UNLSN:
UNTLK:
	brk

iec_check_devnum_lvs:
iec_check_devnum_oc:
	brk

chkin_rs232:
chrin_rs232:
chrout_rs232:
ckout_rs232:
close_rs232:
getin_rs232:
open_rs232:
	brk

chrout_screen_TXT:
	brk

wait_x_bars:
	brk

.export lkupla, lkupsa

lkupla:
lkupsa:
	brk

IBASIC_COLD_START = $a000
IBASIC_WARM_START = $a002

IBASIN:
IBSOUT:
ICHKIN:
ICKOUT:
ICLALL:
ICLOSE:
ICLRCH:
IGETIN:
ILOAD:
IOPEN:
ISAVE:
ISTOP:
	brk

JCHROUT:
JCINT:
JCLOSE:
JIOINIT:
JRAMTAS:
JRESTOR:
JSCNKEY:
JSTOP:
JUDTIM:
	brk

.export scnsiz
scnsiz:
	brk

RAMTAS = ramtas

.import cbinv, cinv, ciout, ioinit, ldtbl, memsiz, memstr, nminv, ramtas, kbd_scan, shflag, stkey, talk, time, timout, verckk, xmax

.importzp user, pnt, lxsp

; zp/var
BLNCT = blnct
BLNON = blnon
BLNSW = blnsw
CBINV = cbinv
CINV = cinv
CIOUT = ciout
CMP0 = cmp0
COLOR = color
CRSW = crsw
DFLTN = dfltn
DFLTO = dflto
EAL = eal
FA = fa
FAT = fat
FNADDR = fnadr
FNLEN = fnlen
GDBLN = gdbln
GDCOL = gdcol
HIBASE = hibase
INDX = indx
INSRT = insrt
IOINIT = ioinit
IOSTATUS = status
LA = la
LAT = lat
LDTBL = ldtbl
LDTND = ldtnd
LNMX = lnmx
LXSP = lsxp
MEMSIZK = memsiz
MEMSTR = memstr
MEMUSS = memuss
MODE = mode
MSGFLG = msgflg
NMINV = nminv
PNT = pnt
PNTR = pntr
QTSW = qtsw
RVS = rvs
SA = sa
SAL = sal
SAT = sat
SCHAR = data
SCNKEY = kbd_scan
SHFLAG = shflag
STAL = stal
STKEY = stkey
TALK = talk
TBLX = tblx
TIME = time
TIMOUT = timout
USER = user
VERCKK = verckk
XMAX = xmax
XSAV = xsav

;.segment "EDITOR"


K_ERR_ROUTINE_TERMINATED     = $00
K_ERR_TOO_MANY_OPEN_FILES    = $01
K_ERR_FILE_ALREADY_OPEN      = $02
K_ERR_FILE_NOT_OPEN          = $03
K_ERR_FILE_NOT_FOUND         = $04
K_ERR_DEVICE_NOT_FOUND       = $05
K_ERR_FILE_NOT_INPUT         = $06
K_ERR_FILE_NOT_OUTPUT        = $07
K_ERR_FILE_NAME_MISSING      = $08
K_ERR_ILLEGAL_DEVICE_NUMBER  = $09
K_ERR_TOP_MEM_RS232          = $F0

K_STS_TIMEOUT_WRITE          = $01
K_STS_TIMEOUT_READ           = $02
K_STS_EOI                    = $40
K_STS_DEVICE_NOT_FOUND       = $80

B_ERR_VERIFY                 = $1C
B_ERR_LOAD                   = $1D

KEY_NA           = $00  ; to indicate that no key is presed
KEY_TAB_FW       = $8F  ; CTRL+>, TAB       - Open ROMs unofficial, original TAB conflicts with C64 PETSCII
KEY_TAB_BW       = $80  ; CTRL+<, SHIFT+TAB - Open ROMs unofficial, original TAB conflicts with C64 PETSCII
KEY_BELL         = $07  ; no key, originally CTRL+G ; XXX implement BELL
KEY_ESC          = $1B
KEY_STOP         = $03
KEY_RUN          = $83
KEY_F1           = $85
KEY_F2           = $89
KEY_F3           = $86
KEY_F4           = $8A
KEY_F5           = $87
KEY_F6           = $8B
KEY_F7           = $88
KEY_F8           = $8C
KEY_F9           = $10
KEY_F10          = $15
KEY_F11          = $16
KEY_F12          = $17
KEY_F13          = $19
KEY_F14          = $1A
KEY_HELP         = $84  ; normally C65 only, also used for our C128 support
KEY_CRSR_UP      = $91
KEY_CRSR_DOWN    = $11
KEY_CRSR_LEFT    = $9D
KEY_CRSR_RIGHT   = $1D
KEY_RVS_ON       = $12  ; CTRL+9
KEY_RVS_OFF      = $92  ; CTRL+0
KEY_BLACK        = $90  ; CTRL+1
KEY_WHITE        = $05  ; CTRL+2
KEY_RED          = $1C  ; CTRL+3
KEY_CYAN         = $9F  ; CTRL+4
KEY_PURPLE       = $9C  ; CTRL+5
KEY_GREEN        = $1E  ; CTRL+6
KEY_BLUE         = $1F  ; CTRL+7
KEY_YELLOW       = $9E  ; CTRL+8
KEY_ORANGE       = $81  ; VENDOR+1
KEY_BROWN        = $95  ; VENDOR+2
KEY_LT_RED       = $96  ; VENDOR+3
KEY_GREY_1       = $97  ; VENDOR+4
KEY_GREY_2       = $98  ; VENDOR+5
KEY_LT_GREEN     = $99  ; VENDOR+6
KEY_LT_BLUE      = $9A  ; VENDOR+7
KEY_GREY_3       = $9B  ; VENDOR+8
KEY_SHIFT_ON     = $09  ; no key
KEY_SHIFT_OFF    = $08  ; no key
KEY_TXT          = $0E  ; no key
KEY_GFX          = $8E  ; no key
KEY_RETURN       = $0D
KEY_CLR          = $93
KEY_HOME         = $13
KEY_INS          = $94
KEY_DEL          = $14
KEY_SPACE        = $20
KEY_EXCLAMATION  = $21
KEY_QUOTE        = $22
KEY_HASH         = $23
KEY_DOLLAR       = $24
KEY_PERCENT      = $25
KEY_AMPERSAND    = $26
KEY_APOSTROPHE   = $27
KEY_R_BRACKET_L  = $28
KEY_R_BRACKET_R  = $29
KEY_ASTERISK     = $2A
KEY_PLUS         = $2B
KEY_COMA         = $2C
KEY_MINUS        = $2D
KEY_FULLSTOP     = $2E
KEY_SLASH        = $2F
KEY_0            = $30
KEY_1            = $31
KEY_2            = $32
KEY_3            = $33
KEY_4            = $34
KEY_5            = $35
KEY_6            = $36
KEY_7            = $37
KEY_8            = $38
KEY_9            = $39
KEY_COLON        = $3A
KEY_SEMICOLON    = $3B
KEY_LT           = $3C
KEY_EQ           = $3D
KEY_GT           = $3E
KEY_QUESTION     = $3F

KEY_FLAG_CTRL    = %00000100

.include ",stubs/e6b6.advance_cursor.s"
.include ",stubs/e96c.insert_line_at_top.s"
.include ",stubs/f3f6.unknown.s"
.include ",stubs/f646.iec_close.s"
.include ",stubs/e701.previous_line.s"
.include ",stubs/e716.chrout_screen.s"
.include ",stubs/fd90.unknown.s"
.include "init/fffc.vector_reset.s"
.include "init/cint_screen_keyboard.s"
.include "init/ff5b.cint.s"
.include "init/e518.cint_legacy.s"
.include "init/fce2.hw_entry_reset.s"
.include "memory/vector_real.s"
.include "memory/fe25.memtop.s"
.include "memory/membot.s"
.include "memory/fd15.restor.s"
.include "rom_revision/ff80.kernal_revision.s"
.include "errors.s"
.include "print/print_kernal_message.s"
.include "print/print_hex_byte.s"
.include "print/print_space.s"
.include "print/print_return.s"
.include "time/settim.s"
.include "time/rdtim.s"
.include "time/udtim.s"
.include "iostack/f4a5.load.s"
.include "iostack/f291.close.s"
.include "iostack/setnam.s"
.include "iostack/getin_real.s"
.include "iostack/f13e.getin.s"
.include "iostack/setmsg.s"
.include "iostack/f157.chrin.s"
.include "iostack/f5ed.save.s"
.include "iostack/clall_real.s"
.include "iostack/f5dd.save_prep.s"
.include "iostack/load_save_common.s"
.include "iostack/chkinout.s"
.include "iostack/f333.clrchn.s"
.include "iostack/findfls.s"
.include "iostack/f49e.load_prep.s"
.include "iostack/f250.ckout.s"
.include "iostack/f1ca.chrout.s"
.include "iostack/f32f.clall.jmp.s"
.include "iostack/settmo.s"
.include "iostack/readst.s"
.include "iostack/f20e.chkin.s"
.include "iostack/setfls.s"
.include "iostack/f34a.open.s"
.include "interrupts/hw_entry_nmi.s"
.include "interrupts/fe47.default_nmi_handler.s"
.include "interrupts/ea7e.ack_cia1_return_from_interrupt.s"
.include "interrupts/ea31.default_irq_handler.s"
.include "interrupts/ea81.return_from_interrupt.s"
.include "interrupts/fffa.vector_nmi.s"
.include "interrupts/fe66.default_brk_handler.s"
.include "interrupts/fffe.vector_irq.s"
.include "interrupts/hw_entry_irq.s"
.include "screen/chrout_screen_shift_onoff.s"
.include "screen/chrout_screen_gfxtxt.s"
.include "screen/e9ff.screen_clear_line.s"
.include "screen/screen_get_logical_line_end_ptr.s"
.include "screen/screen_calculate_pnt_user.s"
.include "screen/e544.clear_screen.s"
.include "screen/screen_calculate_pntr_lnmx.s"
.include "screen/chrout_screen_ins.s"
.include "screen/screen_get_cliped_pntr.s"
.include "screen/chrout_screen_jumptable_codes.s"
.include "screen/cursor_enable.s"
.include "screen/cursor.s"
.include "screen/chrout_screen_return.s"
.include "screen/chrout_screen_home.s"
.include "screen/screen_check_space_ends_line.s"
.include "screen/screen_advance_to_next_line.s"
.include "screen/chrout_screen_rvs.s"
.include "screen/chrout_screen_del.s"
.include "screen/screen_preserve_sal_eal.s"
.include "screen/cursor_show.s"
.include "screen/chrout_screen_clr.s"
.include "screen/chrout_screen.s"
.include "screen/chrout_screen_tab.s"
.include "screen/screen.s"
.include "screen/e566.cursor_home.s"
.include "screen/e56c.screen_calculate_pointers.s"
.include "screen/e8ea.screen_scroll_up.s"
.include "screen/chrout_screen_control.s"
.include "screen/chrout_screen_quote.s"
.include "screen/screen_code_to_petscii.s"
.include "screen/chrout_screen_crsr.s"
.include "screen/screen_restore_sal_eal.s"
.include "screen/e50a.plot.s"
.include "screen/screen_grow_logical_line.s"
.include "screen/chrout_screen_stop.s"
.include "assets/kernal_messages.s"
.include "assets/e8da.colour_codes.s"
.include "assets/fd30.vector_defaults.s"
.include "jumptable/ffc0.jopen.s"
.include "jumptable/ffbd.jsetnam.s"
.include "jumptable/ffa5.jacptr.s"
.include "jumptable/ffc9.jckout.s"
.include "jumptable/ffe1.jstop.s"
.include "jumptable/ffea.judtim.s"
.include "jumptable/ffba.jsetfls.s"
.include "jumptable/ffd2.jchrout.s"
.include "jumptable/ff9c.jmembot.s"
.include "jumptable/ff8a.jrestor.s"
.include "jumptable/ffe7.jclall.s"
.include "jumptable/ffb1.jlisten.s"
.include "jumptable/ffb4.jtalk.s"
.include "jumptable/ffcc.jclrchn.s"
.include "jumptable/ffb7.jreadst.s"
.include "jumptable/ffa8.jciout.s"
.include "jumptable/ff8d.jvector.s"
.include "jumptable/ff99.jmemtop.s"
.include "jumptable/ffae.junlsn.s"
.include "jumptable/ffa2.jsettmo.s"
.include "jumptable/ffd8.jsave.s"
.include "jumptable/fff3.jiobase.s"
.include "jumptable/ffdb.jsettim.s"
.include "jumptable/ff90.jsetmsg.s"
.include "jumptable/ffed.jscreen.s"
.include "jumptable/ffc6.jchkin.s"
.include "jumptable/ffcf.jchrin.s"
.include "jumptable/ffd5.jload.s"
.include "jumptable/fff0.jplot.s"
.include "jumptable/ff84.jioinit.s"
.include "jumptable/ff81.jcint.s"
.include "jumptable/ffab.juntlk.s"
.include "jumptable/ffde.jrdtim.s"
.include "jumptable/ff96.jtksa.s"
.include "jumptable/ffe4.jgetin.s"
.include "jumptable/ff87.jramtas.s"
.include "jumptable/ffc3.jclose.s"
.include "jumptable/ff9f.jscnkey.s"
.include "jumptable/ff93.jsecond.s"
.include "keyboard/f6ed.stop.s"
.include "keyboard/chrin_keyboard.s"

cint = CINT

.segment "KVAR2" ; more KERNAL vars
; XXX TODO only one bit per byte is used, this should be compressed!
ldtb1:	.res 61 +1       ;flags+endspace
	;       ^^ XXX at label 'lps2', the code counts up to
	;              numlines+1, THEN writes the end marker,
	;              which seems like one too many. This was
	;              worked around for now by adding one more
	;              byte here, but we should have a look at
	;              whether there's an off-by-one error over
	;              at 'lps2'!

; Screen
;
.export mode; [ps2kbd]
.export data; [cpychr]
mode:	.res 1           ;    bit7=1: charset locked, bit6=1: ISO
gdcol:	.res 1           ;    original color before cursor
autodn:	.res 1           ;    auto scroll down flag(=0 on,<>0 off)
lintmp:	.res 1           ;    temporary for line index
color:	.res 1           ;    activ color nybble
rvs:	.res 1           ;$C7 rvs field on flag
indx:	.res 1           ;$C8
lsxp:	.res 1           ;$C9 x pos at start
lstp:	.res 1           ;$CA
blnsw:	.res 1           ;$CC cursor blink enab
blnct:	.res 1           ;$CD count to toggle cur
gdbln:	.res 1           ;$CE char before cursor
blnon:	.res 1           ;$CF on/off blink flag
crsw:	.res 1           ;$D0 input vs get flag
pntr:	.res 1           ;$D3 pointer to column
qtsw:	.res 1           ;$D4 quote switch
lnmx:	.res 1           ;$D5 40/80 max positon
tblx:	.res 1           ;$D6
data:	.res 1           ;$D7
insrt:	.res 1           ;$D8 insert mode flag
llen:	.res 1           ;$D9 x resolution
nlines:	.res 1           ;$DA y resolution
nlinesp1: .res 1          ;    X16: y resolution + 1
nlinesm1: .res 1          ;    X16: y resolution - 1
verbatim: .res 1

.segment "ZPCHANNEL" : zeropage
;                      C64 location
;                         VVV
sal:	.res 1           ;$AC
sah:	.res 1           ;$AD
eal:	.res 1           ;$AE
eah:	.res 1           ;$AF
fnadr:	.res 2           ;$BB addr current file name str
memuss:	.res 2           ;$C3 load temps

.segment "VARCHANNEL"

; Channel I/O
;
lat:	.res 10          ;    logical file numbers
fat:	.res 10          ;    primary device numbers
sat:	.res 10          ;    secondary addresses
;.assert * = status, error, "status must be at specific address"
status:
	.res 1           ;$90 i/o operation status byte
verck:	.res 1           ;$93 load or verify flag
xsav:	.res 1           ;$97 temp for basin
ldtnd:	.res 1           ;$98 index to logical file
dfltn:	.res 1           ;$99 default input device #
dflto:	.res 1           ;$9A default output device #
msgflg:	.res 1           ;$9D os message flag
t1:	.res 1           ;$9E temporary 1
fnlen:	.res 1           ;$B7 length current file n str
la:	.res 1           ;$B8 current file logical addr
sa:	.res 1           ;$B9 current file 2nd addr
fa:	.res 1           ;$BA current file primary addr
stal:	.res 1           ;$C1
stah:	.res 1           ;$C2

.export cint, color, cursor_blink, dfltn, dflto, llen, sah, sal, status, t1

.export close_all
close_all:
	brk




; lkupla
; lkupsa
; loadsp
; nbasin
; nbsout
; nchkin
; nckout
; nclall
; nclose
; nclrch
; ngetin
; nload
; nopen
; nsave
; nstop
; savesp
; scnsiz
; scrorg
; setlfs
; udst

plot = PLOT
readst = READST
setmsg = SETMSG
setnam = SETNAM
settmo = SETTMO

.if 0
.segment "ZPCHANNEL" ; XXX other ZP
cmp0:	.res 1
.segment "KVAR2" ; XXX
hibase:	.res 2 ; XXX remove
.else
cmp0 = 0
hibase = 0
.endif

.export restor, memtop, membot, iobase, vector, readst, loadsp, savesp
restor = RESTOR
memtop = MEMTOP
membot = MEMBOT
vector = VECTOR

loadsp = LOAD
savesp = SAVE
