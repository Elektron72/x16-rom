5 F=7
6 REM 0 = 1571
7 REM 1 = CMD
8 REM 2 = C65
9 REM 4 = X16
10 GOSUB100:GOSUB200:GOSUB300:GOSUB400:GOSUB500:GOSUB600:GOSUB700:GOSUB800
11 GOSUB900:GOSUB1000:GOSUB1100:GOSUB1200:GOSUB1300:GOSUB1400:GOSUB1500
12 GOSUB1600
13 IFFAND2THENGOSUB1700         
14 REM IFFAND1THENGOSUB1800         : REM TODO: SHOULD RETURN STATUS 39
15 IFFAND1THENGOSUB1900
16 IFFAND1THEN IFFAND4THENGOSUB2000 : REM TODO: PROBLEM ON CMD
17 IFFAND1THENGOSUB2100
18 IFFAND4THENGOSUB2200             : REM M-R/M-W DISABLED ON NON-X16
19 REM IFFAND1THENGOSUB2300         : REM TODO: SHOULD RETURN STATUS 39
20 IFFAND1THENGOSUB2400:GOSUB2500

99 END

100 PRINT" 1 - CREATE/READ FILE, ',P,X': ",;
110 OPEN1,8,2,"FILE,P,W"
120 PRINT#1,"HELLO WORLD!"
130 CLOSE1
140 OPEN1,8,2,"FILE,P,R"
150 INPUT#1,A$
160 IFA$<>"HELLO WORLD!"THENSTOP
170 IFST<>64THENSTOP
180 CLOSE1
190 DOS"S:FILE"
199 DOS"U0>T":PRINT"OK":RETURN

200 PRINT" 2 - CREATE/READ FILE, CHANNELS 1/0: ",;
210 OPEN1,8,1,"FILE"
220 PRINT#1,"HELLO WORLD!"
230 CLOSE1
240 OPEN1,8,0,"FILE"
250 INPUT#1,A$
260 IFA$<>"HELLO WORLD!"THENSTOP
270 IFST<>64THENSTOP
280 CLOSE1
290 DOS"S:FILE"
299 DOS"U0>T":PRINT"OK":RETURN

300 PRINT" 3 - CREATE/READ FILE, CHANNELS 1/2: ",;
310 OPEN1,8,1,"FILE"
320 PRINT#1,"HELLO WORLD!"
330 CLOSE1
340 OPEN1,8,2,"FILE"
350 INPUT#1,A$
360 IFA$<>"HELLO WORLD!"THENSTOP
370 IFST<>64THENSTOP
380 CLOSE1
390 DOS"S:FILE"
399 DOS"U0>T":PRINT"OK":RETURN

400 PRINT" 4 - R/W MULT. LISTEN/TALK SESSIONS: ",;
410 OPEN1,8,2,"FILE,P,W":PRINT#1,"ONE":PRINT#1,"TWO":CLOSE1
420 OPEN1,8,2,"FILE"
430 INPUT#1,A$:IFA$<>"ONE"THENSTOP
440 INPUT#1,A$:IFA$<>"TWO"THENSTOP
450 IFST<>64THENSTOP
460 CLOSE1
470 DOS"S:FILE"
499 DOS"U0>T":PRINT"OK":RETURN

500 PRINT" 5 - TWO FILES OPEN FOR WRITING: ",;
510 OPEN1,8,2,"FILE1,P,W":OPEN2,8,3,"FILE2,P,W"
515 PRINT#1,"ONE":PRINT#2,"TWO":PRINT#1,"THREE":PRINT#2,"FOUR"
520 CLOSE1:CLOSE2
525 OPEN1,8,2,"FILE1"
530 INPUT#1,A$:IFA$<>"ONE"THENSTOP
535 INPUT#1,A$:IFA$<>"THREE"THENSTOP
540 IFST<>64THENSTOP
545 CLOSE1
550 OPEN1,8,2,"FILE2"
555 INPUT#1,A$:IFA$<>"TWO"THENSTOP
560 INPUT#1,A$:IFA$<>"FOUR"THENSTOP
565 IFST<>64THENSTOP
570 CLOSE1
580 DOS"S:FILE1,FILE2"
599 DOS"U0>T":PRINT"OK":RETURN

600 PRINT" 6 - TWO FILES OPEN FOR READING: ",;
610 OPEN1,8,2,"FILE1,P,W":PRINT#1,"ONE":PRINT#1,"THREE":CLOSE1
615 OPEN1,8,2,"FILE2,P,W":PRINT#1,"TWO":PRINT#1,"FOUR":CLOSE1
625 OPEN1,8,2,"FILE1":OPEN2,8,3,"FILE2"
630 INPUT#1,A$:IFA$<>"ONE"THENSTOP
635 INPUT#2,A$:IFA$<>"TWO"THENSTOP
640 INPUT#1,A$:IFA$<>"THREE"THENSTOP
645 INPUT#2,A$:IFA$<>"FOUR"THENSTOP
650 IFST<>64THENSTOP
655 IFST<>64THENSTOP
660 CLOSE1:CLOSE2
665 DOS"S:FILE1,FILE2"
699 DOS"U0>T":PRINT"OK":RETURN

700 PRINT" 7 - C: COPY FILE: ",,,;
710 OPEN1,8,2,"FILE1,P,W":PRINT#1,"HELLO WORLD!":CLOSE1
720 DOS"C:FILE2=FILE1
730 OPEN1,8,2,"FILE2"
740 INPUT#1,A$:IFA$<>"HELLO WORLD!"THENSTOP
750 IFST<>64THENSTOP
760 CLOSE1
770 DOS"S:FILE1,FILE2"
799 DOS"U0>T":PRINT"OK":RETURN

800 PRINT" 8 - C: CONCATENATE FILES: ",,;
805 OPEN1,8,2,"FILE1,P,W":PRINT#1,"ONE":PRINT#1,"TWO":CLOSE1
810 OPEN1,8,2,"FILE2,P,W":PRINT#1,"THREE":PRINT#1,"FOUR":CLOSE1
815 OPEN1,8,2,"FILE3,P,W":PRINT#1,"FIVE":PRINT#1,"SIX":CLOSE1
820 DOS"C:FILE4=FILE1,FILE2,FILE3
825 OPEN1,8,2,"FILE4"
830 INPUT#1,A$:IFA$<>"ONE"THENSTOP
835 INPUT#1,A$:IFA$<>"TWO"THENSTOP
840 INPUT#1,A$:IFA$<>"THREE"THENSTOP
845 INPUT#1,A$:IFA$<>"FOUR"THENSTOP
850 INPUT#1,A$:IFA$<>"FIVE"THENSTOP
855 INPUT#1,A$:IFA$<>"SIX"THENSTOP
860 IFST<>64THENSTOP
865 CLOSE1
870 DOS"S:FILE1,FILE2,FILE3,FILE4"
899 DOS"U0>T":PRINT"OK":RETURN

900 PRINT" 9 - LOAD NON-EXISTENT FILE: ",,;
910 OPEN1,8,2,"NONEXIST"
920 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>62THENSTOP
930 CLOSE1
999 DOS"U0>T":PRINT"OK":RETURN

1000 PRINT"10 - RENAME FILE: ",,,;
1005 OPEN1,8,2,"FILE1,P,W":PRINT#1,"HELLO":CLOSE1
1010 DOS"R:FILE2=FILE1"
1015 OPEN1,8,2,"FILE2"
1020 INPUT#1,A$:IFA$<>"HELLO"THENSTOP
1025 IFST<>64THENSTOP
1030 CLOSE1
1035 OPEN1,8,2,"FILE1"
1040 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>62THENSTOP
1045 CLOSE1
1050 DOS"S:FILE2"
1099 DOS"U0>T":PRINT"OK":RETURN

1100 PRINT"11 - RENAME TO FILE THAT EXISTS: ",;
1105 OPEN1,8,2,"FILE1,P,W":PRINT#1,"HELLO":CLOSE1
1110 OPEN1,8,2,"FILE2,P,W":PRINT#1,"HELLO":CLOSE1
1120 DOS"R:FILE2=FILE1"
1130 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>63THENSTOP
1140 DOS"S:FILE1,FILE2"
1199 DOS"U0>T":PRINT"OK":RETURN

1200 PRINT"12 - COPY TO FILE THAT EXISTS: ",;
1205 OPEN1,8,2,"FILE1,P,W":PRINT#1,"HELLO":CLOSE1
1210 OPEN1,8,2,"FILE2,P,W":PRINT#1,"HELLO":CLOSE1
1220 DOS"C:FILE2=FILE1"
1230 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>63THENSTOP
1240 DOS"S:FILE1"
1299 DOS"U0>T":PRINT"OK":RETURN

1300 PRINT"13 - UI: ",,,,;
1310 DOS"UI"
1320 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>73THENSTOP
1399 DOS"U0>T":PRINT"OK":RETURN

1400 PRINT"14 - SCRATCH NON-EXISTENT FILE: ",;
1410 DOS"S:NONEXIST"
1420 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1425 IFX<>0THENSTOP
1499 DOS"U0>T":PRINT"OK":RETURN

1500 PRINT"15 - SCRATCH TWO FILES: ",,;
1505 OPEN1,8,2,"FILE1,P,W":PRINT#1,"HELLO":CLOSE1
1510 OPEN1,8,2,"FILE2,P,W":PRINT#1,"HELLO":CLOSE1
1515 DOS"S:FILE1,FILE2"
1520 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1525 IFX<>2THENSTOP
1599 DOS"U0>T":PRINT"OK":RETURN

1600 PRINT"16 - LOCK FILE (L): ",,;
1605 OPEN1,8,2,"FILE,P,W":PRINT#1,"HELLO":CLOSE1
1610 OPEN15,8,15,"L:FILE":CLOSE15
1615 DOS"S:FILE"
1620 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1625 IFX<>0THENSTOP
1630 OPEN15,8,15,"L:FILE":CLOSE15
1635 DOS"S:FILE"
1640 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1645 IFX<>1THENSTOP
1699 DOS"U0>T":PRINT"OK":RETURN

1700 PRINT"17 - LOCK FILE (F-L/F-U): ",,;
1705 OPEN1,8,2,"FILE,P,W":PRINT#1,"HELLO":CLOSE1
1710 OPEN15,8,15,"F-L:FILE":CLOSE15
1715 DOS"S:FILE"
1720 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1725 IFX<>0THENSTOP
1730 OPEN15,8,15,"F-U:FILE":CLOSE15
1735 DOS"S:FILE"
1740 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1745 IFX<>1THENSTOP
1799 DOS"U0>T":PRINT"OK":RETURN

1800 PRINT"18 - CREATE FILE, ILL. DIRECTORY: ",,;
1810 OPEN1,8,2,"//DIR/:FILE,P,W":
1820 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1830 CLOSE1
1899 DOS"U0>T":PRINT"OK":RETURN

1900 PRINT"19 - MAKE/REMOVE DIRECTORY: ",,;
1905 DOS"MD:DIR"
1915 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>0THENSTOP
1920 DOS"RD:DIR
1925 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>1THENSTOP
1930 IFX<>1THENSTOP
1999 DOS"U0>T":PRINT"OK":RETURN

2000 PRINT"20 - CREATE/READ FILE IN SUBDIR: ",;
2005 DOS"MD:DIR"
2020 OPEN1,8,2,"//DIR/:FILE,P,W"
2025 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>0THENSTOP
2030 PRINT#1,"HELLO":CLOSE1
2035 OPEN1,8,2,"//DIR/:FILE"
2037 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>0THENSTOP
2040 INPUT#1,A$:IFA$<>"HELLO"THENSTOP
2045 IFST<>64THENSTOP
2050 CLOSE1
2060 DOS"S//DIR/:FILE"
2065 DOS"RD:DIR
2099 DOS"U0>T":PRINT"OK":RETURN

2100 PRINT"21 - CHANGE DIR, READ FILE: ",,;
2105 DOS"MD:DIR"
2110 OPEN1,8,2,"FILE1,P,W":PRINT#1,"ONE":CLOSE1
2115 OPEN1,8,2,"//DIR/:FILE2,P,W":PRINT#1,"TWO":CLOSE1
2120 DOS"CD:DIR"
2135 OPEN1,8,2,"FILE2"
2140 INPUT#1,A$:IFA$<>"TWO"THENSTOP
2145 CLOSE1
2150 OPEN1,8,2,"//:FILE1"
2155 INPUT#1,A$:IFA$<>"ONE"THENSTOP
2160 CLOSE1
2165 DOS"CD:_"
2170 DOS"S//DIR/:FILE1,FILE2"
2175 DOS"RD:DIR
2199 DOS"U0>T":PRINT"OK":RETURN

2200 PRINT"22 - MEMORY WRITE/READ: ",,;
2205 B=$0200
2210 OPEN15,8,15,"M-W"+CHR$(BAND255)+CHR$(INT(B/256))+CHR$(5)+"HELLO":CLOSE15
2215 OPEN15,8,15,"M-R"+CHR$((B+1)AND255)+CHR$(INT((B+1)/256))+CHR$(4):CLOSE15
2220 A$="":OPEN1,8,15
2225 FORI=1TO4:GET#1,C$:A$=A$+C$:NEXT:IFA$<>"ELLO"THENSTOP
2230 GET#1,A$:IFA$<>CHR$(13)THENSTOP
2235 IFST<>64THENSTOP
2240 DOS"UI"
2299 DOS"U0>T":PRINT"OK":RETURN

2300 PRINT"23 - CHANGE TO NON-EXISTENT DIR: ",;
2310 DOS"CD:NONEXIST
2320 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>39THENSTOP
2399 DOS"U0>T":PRINT"OK":RETURN

2400 PRINT"24 - CHANGE PARTITION: ",,;
2410 DOS"CP1
2420 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>2THENSTOP
2430 IFX<>1THENSTOP
2440 DOS"U0>T":PRINT"OK":RETURN

2500 PRINT"25 - CHANGE TO NON-EXISTENT PARTITION: ",;
2510 DOS"CP200
2520 OPEN15,8,15:INPUT#15,S,S$,X,Y:CLOSE15:IFS<>77THENSTOP
2530 IFX<>200THENSTOP
2540 DOS"U0>T":PRINT"OK":RETURN

RUN
