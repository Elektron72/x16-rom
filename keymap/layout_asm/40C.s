// Name:   French
// Locale: fr-FR
// KLID:   40c
//
// PETSCII characters reachable on a C64 keyboard that are not reachable with this layout:
// codes: LIGHT_RED MIDDLE_GRAY LIGHT_BLUE 
// graph: '\xa4\xa6\xa8\xa9\xba\xc0\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe'
// ASCII characters reachable with this layout on Windows but not covered by PETSCII:
// '\x1b\x1c\x1d\_{|}~¤§¨°²µàçèéù€'

.segment "KBDMETA"

	.word kbtab_40c_0
	.word kbtab_40c_1
	.word kbtab_40c_2
	.word kbtab_40c_4

.segment "KBDTABLES"

kbtab_40c_0: // Unshifted
	.byte $09,'_',$00
	.byte $00,$00,$00,$00,$00,'A','&',$00
	.byte $00,$00,'W','S','Q','Z',$00,$00
	.byte $00,'C','X','D','E',''','"',$00
	.byte $00,' ','V','F','T','R','(',$00
	.byte $00,'N','B','H','G','Y','-',$00
	.byte $00,$00,',','J','U',$00,$00,$00
	.byte $00,';','K','I','O',$00,$00,$00
	.byte $00,':','!','L','M','P',')',$00
	.byte $00,$00,$00,$00,'^','=',$00,$00
	.byte $00,$00,$0d,'$',$00,'*',$00,$00
	.byte $00,'<',$00,$00,$00,$00,$14,$00
kbtab_40c_1: // Shft 
	.byte $18,$de,$00
	.byte $00,$00,$00,$00,$00,$c1,'1',$00
	.byte $00,$00,$d7,$d3,$d1,$da,'2',$00
	.byte $00,$c3,$d8,$c4,$c5,'4','3',$00
	.byte $00,$a0,$d6,$c6,$d4,$d2,'5',$00
	.byte $00,$ce,$c2,$c8,$c7,$d9,'6',$00
	.byte $00,$00,'?',$ca,$d5,'7','8',$00
	.byte $00,'.',$cb,$c9,$cf,'0','9',$00
	.byte $00,'/','\',$cc,$cd,$d0,$00,$00
	.byte $00,$00,'%',$00,$00,'+',$00,$00
	.byte $00,$00,$8d,'\',$00,$00,$00,$00
	.byte $00,'>',$00,$00,$00,$00,$94,$00
kbtab_40c_2: // Ctrl 
	.byte $18,$00,$00
	.byte $00,$00,$00,$00,$00,$01,$90,$00
	.byte $00,$00,$17,$13,$11,$1a,$05,$00
	.byte $00,$03,$18,$04,$05,$9f,$1c,$00
	.byte $00,$a0,$16,$06,$14,$12,$9c,$00
	.byte $00,$0e,$02,$08,$07,$19,$1e,$00
	.byte $00,$00,$00,$0a,$15,$1f,$9e,$00
	.byte $00,$00,$0b,$09,$0f,$92,$12,$00
	.byte $00,$00,$00,$0c,$0d,$10,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$8d,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$94,$00
kbtab_40c_4: // Alt 
	.byte $18,$00,$00
	.byte $00,$00,$00,$00,$00,$ab,$81,$00
	.byte $00,$00,$ad,$ae,$b0,$b3,$95,$00
	.byte $00,$bc,$bd,$ac,$b1,$97,'#',$00
	.byte $00,$a0,$be,$bb,$a3,$b2,'[',$00
	.byte $00,$aa,$bf,$b4,$a5,$b7,$99,$00
	.byte $00,$00,$a7,$b5,$b8,'`',$9b,$00
	.byte $00,$00,$a1,$a2,$b9,'@','^',$00
	.byte $00,$00,$00,$b6,$00,$af,']',$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$8d,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$94,$00
