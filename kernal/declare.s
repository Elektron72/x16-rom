	.segment "ZPKERNAL" : zeropage
status	.res 1           ;i/o operation status byte
; crfac .res 2 ;correction factor (unused)
stkey	.res 1           ;stop key flag
	.res 1           ;unused (tape)
verck	.res 1           ;load or verify flag
c3p0	.res 1           ;ieee buffered char flag
bsour	.res 1           ;char buffer for ieee
	.res 1           ;unused (tape)
xsav	.res 1           ;temp for basin
ldtnd	.res 1           ;index to logical file
dfltn	.res 1           ;default input device #
dflto	.res 1           ;default output device #
	.res 2           ;unused (tape)
msgflg	.res 1           ;os message flag
t1	.res 1           ;temporary 1
	.res 1           ;unused (tape)
time	.res 3           ;24 hour clock in 1/60th seconds
r2d2	.res 1           ;serial bus usage
; ptch .res 1  (unused)
bsour1	;temp used by serial routine
	.res 1           ;unused (tape)
count	.res 1           ;temp used by serial routine
	.res 1           ;unused (tape)
inbit	.res 1           ;rs-232 rcvr input bit storage
bitci	.res 1           ;rs-232 rcvr bit count in
rinone	.res 1           ;rs-232 rcvr flag for start bit check
ridata	.res 1           ;rs-232 rcvr byte buffer
riprty	.res 1           ;rs-232 rcvr parity storage
sal	.res 1
sah	.res 1
eal	.res 1
eah	.res 1
	.res 4           ;unused (tape)
bitts	.res 1           ;rs-232 trns bit count
nxtbit	.res 1           ;rs-232 trns next bit to be sent
rodata	.res 1           ;rs-232 trns byte buffer
fnlen	.res 1           ;length current file n str
la	.res 1           ;current file logical addr
sa	.res 1           ;current file 2nd addr
fa	.res 1           ;current file primary addr
fnadr	.res 2           ;addr current file name str
roprty	.res 1           ;rs-232 trns parity buffer
	.res 3          ;unused (tape)
tmp0
stal	.res 1
stah	.res 1
memuss	;cassette load temps (2 bytes)
tmp2	.res 2
;
;variables for screen editor
;
lstx	.res 1           ;key scan index
; sfst .res 1 ;keyboard shift flag (unused)
ndx	.res 1           ;index to keyboard q
rvs	.res 1           ;rvs field on flag
indx	.res 1
lsxp	.res 1           ;x pos at start
lstp	.res 1
sfdx	.res 1           ;shift mode on print
blnsw	.res 1           ;cursor blink enab
blnct	.res 1           ;count to toggle cur
gdbln	.res 1           ;char before cursor
blnon	.res 1           ;on/off blink flag
crsw	.res 1           ;input vs get flag
pnt	.res 2           ;pointer to row
; point .res 1   (unused)
pntr	.res 1           ;pointer to column
qtsw	.res 1           ;quote switch
lnmx	.res 1           ;40/80 max positon
tblx	.res 1
data	.res 1
insrt	.res 1           ;insert mode flag
ldtb1	.res 26          ;line flags+endspace
user	.res 2           ;screen editor color ip
keytab	.res 2           ;keyscan table indirect
;rs-232 z-page
ribuf	.res 2           ;rs-232 input buffer pointer
robuf	.res 2           ;rs-232 output buffer pointer
frekzp	.res 4           ;free kernal zero page 9/24/80
baszpt	.res 1           ;location ($00ff) used by basic

	.segment "STACK"
bad	.res 1
	.segment "KVAR"
buf	.res 89          ;basic/monitor buffer

; tables for open files
;
lat	.res 10          ;logical file numbers
fat	.res 10          ;primary device numbers
sat	.res 10          ;secondary addresses

; system storage
;
keyd	.res 10          ;irq keyboard buffer
memstr	.res 2           ;start of memory
memsiz	.res 2           ;top of memory
timout	.res 1           ;ieee timeout flag

; screen editor storage
;
color	.res 1           ;activ color nybble
gdcol	.res 1           ;original color before cursor
hibase	.res 1           ;base location of screen (top)
xmax	.res 1
rptflg	.res 1           ;key repeat flag
kount	.res 1
delay	.res 1
shflag	.res 1           ;shift flag byte
lstshf	.res 1           ;last shift pattern
keylog	.res 2           ;indirect for keyboard table setup
mode	.res 1           ;0-pet mode, 1-cattacanna
autodn	.res 1           ;auto scroll down flag(=0 on,<>0 off)

; rs-232 storage
;
m51ctr	.res 1           ;6551 control register
m51cdr	.res 1           ;6551 command register
m51ajb	.res 2           ;non standard (bittime/2-100)
rsstat	.res 1           ; rs-232 status register
bitnum	.res 1           ;number of bits to send (fast response)
baudof	.res 2           ;baud rate full bit time (created by open)
;
; reciever storage
;
; inbit .res 1 ;input bit storage
; bitci .res 1 ;bit count in
; rinone .res 1 ;flag for start bit check
; ridata .res 1 ;byte in buffer
; riprty .res 1 ;byte in parity storage
ridbe	.res 1           ;input buffer index to end
ridbs	.res 1           ;input buffer pointer to start
;
; transmitter storage
;
; bitts .res 1 ;# of bits to be sent
; nxtbit .res 1 ;next bit to be sent
; roprty .res 1 ;parity of byte sent
; rodata .res 1 ;byte buffer out
rodbs	.res 1           ;output buffer index to start
rodbe	.res 1           ;output buffer index to end
;
	.res 2           ;unused (tape)
;
; temp space for vic-40 variables ****
;
enabl	.res 1           ;rs-232 enables (replaces ier)
	.res 3          ;unused (tape)
lintmp	.res 1           ;temporary for line index
palnts	.res 1           ;C64: pal vs ntsc flag 0=ntsc 1=pal (unused)

	.segment "KVECTORS";rem kernal/os indirects(20)
cinv	.res 2           ;irq ram vector
cbinv	.res 2           ;brk instr ram vector
nminv	.res 2           ;nmi ram vector
iopen	.res 2           ;indirects for code
iclose	.res 2           ; conforms to kernal spec 8/19/80
ichkin	.res 2
ickout	.res 2
iclrch	.res 2
ibasin	.res 2
ibsout	.res 2
istop	.res 2
igetin	.res 2
iclall	.res 2
usrcmd	.res 2
iload	.res 2
isave	.res 2           ;savesp

vicscn	=$0400

; i/o devices
;
mmtop   =$9f00

; XXX TODO: remove
viccol	=$d800           ;vic color nybbles

via1	=$9f40                  ;VIA 6522 #1
d1prb	=via1+0
d1pra	=via1+1
d1ddrb	=via1+2
d1ddra	=via1+3
d1t1l	=via1+4
d1t1h	=via1+5
d1t1ll	=via1+6
d1t1lh	=via1+7
d1t2l	=via1+8
d1t2h	=via1+9
d1sr	=via1+10
d1acr	=via1+11
d1pcr	=via1+12
d1ifr	=via1+13
d1ier	=via1+14
d1ora	=via1+15

via2	=$9f50                  ;VIA 6522 #2
d2prb	=via2+0
d2pra	=via2+1
d2ddrb	=via2+2
d2ddra	=via2+3
d2t1l	=via2+4
d2t1h	=via2+5
d2t1ll	=via2+6
d2t1lh	=via2+7
d2t2l	=via2+8
d2t2h	=via2+9
d2sr	=via2+10
d2acr	=via2+11
d2pcr	=via2+12
d2ifr	=via2+13
d2ier	=via2+14
d2ora	=via2+15

; XXX TODO:
; XXX The following symbols are CIA 6526-based and required for
; XXX serial & rs232. Both drivers need to be changed to use
; XXX the VIAs instead. At that point, these symbols must be removed.
d2cra	=0
d2crb	=0
d2icr	=0
d1crb	=0
d1icr	=0

; XXX TODO:
; XXX These symbols are currently used in the screen editor. They
; XXX need to be removed once the keyboard driver has been replaced.
colm	=d1pra                  ;keyboard matrix
rows	=d1prb                  ;keyboard matrix

; XXX TODO
timrb	=$19            ;6526 crb enable one-shot tb

;screen editor constants
;
llen	=40             ;single line 40 columns
llen2	=80             ;double line = 80 columns
nlines	=25             ;25 rows on screen
white	=$01            ;white screen color
blue	=$06            ;blue char color
cr	=$d             ;carriage return

;rsr 8/3/80 add & change z-page
;rsr 8/11/80 add memuss & plf type
;rsr 8/22/80 add rs-232 routines
;rsr 8/24/80 add open variables
;rsr 8/29/80 add baud space move rs232 to z-page
;rsr 9/2/80 add screen editor vars&con
;rsr 12/7/81 modify for vic-40