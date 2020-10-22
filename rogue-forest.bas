5 REM
10 REM "ÕÃÃÕÀÉÕÀÉÂ ÂÕÀÀ  ÕÃÃÕÀÉÕÃÃÕÀÀÕÀÃÀ²À "
15 REM "Â  ÊÀËÊÀÛÊÀË«À   «À ÊÀËÂ  «À ÊÀÉ Â  "
20 REM "       ÀË   ÊÀÀ  Â        ÊÀÀÃÀË    "
25 REM
30 REM  INITIALIZE PLAYER
35 GOSUB 865  :REM INIT GAME
40 GOSUB 1630  :REM INIT SOUND
45 GOSUB 1235 :REM INIT PANELS
50 REM  LINE-CLEANER
55 LI$ = "                                                           "
60 GOSUB 1700 :REM SPLASH SCREEN
65 GOSUB 510  :REM BUILD FOREST
70 R1=INT(RND(1)*50+10)
75 R2=INT(RND(1)*30+10)
80 R3  = 0
85 R4 = 0
90 R5   = 1
95 R6 = 1
100 R7  = 0
105 R6$ = "RUSTY SPORK"
110 R7$ = "TUXEDO"
115 C1    = INT(RND(1)*6)+INT(RND(1)*6)+2 :REM STR
120 C2  = C1
125 C3    = INT(RND(1)*6)+INT(RND(1)*6)+2 :REM DEX
130 C4    = INT(RND(1)*6)+INT(RND(1)*6)+2 :REM END
135 C5    = INT(RND(1)*6)+INT(RND(1)*6)+2 :REM INT
140 C0(1) = C1
145 C0(2) = C3
150 C0(3) = C4
155 C0(4) = C5
160 R8$ = "NOT YET"
165 DIM IW%(10), IA%(10) :REM WEAPONS, ARMOR
170 REM                       DRAW THE SCREEN
175 REM HIDE BACKGROUND
180 COLOR 1,6 :CLS :REM WHITE ON BLUE
185 GOSUB 1870 :REM TITLE
190 GOSUB 435
195 REM  PRINT PLAYER AND POSITION CURSOR
200 ? VP$(R2-4);
205 COLOR 1,0 :REM TRANSPARENT (CLEARS FOG)
210 ? TAB(R1-4) C9$;
215 COLOR 1,6 :REM BLUE UNDER WHITE
220 ? L5$ TAB(R1) "@"
225 ? VP$(4) LI$ : ? "\X91   STR" C1 "SCORE:" R3 "HUNGER:" R4
230 IF RND(1)>0.95 THEN R4 = R4 + 1
235 T0 = T0 - 1
240 IF T0 = 0 THEN ? VP$(5) LI$
245 GET A$ :IF A$="" GOTO 245
250 XX=0 :YY=0
255 IF A$="\X11" THEN YY=+1 :REM DOWN
260 IF A$="\X91" THEN YY=-1 :REM UP
265 IF A$="\X1D" THEN XX=+1 :REM RIGHT
270 IF A$="\X9D" THEN XX=-1 :REM LEFT
275 IF A$="E" THEN GOSUB 465
280 IF A$="." AND C1 < C2 THEN C1 = C1 + 1
285 LO = VPEEK(1,(R2+YY)*$100 + (R1+XX)*2)
290 IF LO < $20 THEN NN=LO :GOSUB 1165 :GOTO 305
295 IF LO > $22 AND LO < $2E THEN :GOSUB 1895 :GOSUB 435
300 IF LO < $41 THEN R1=R1+XX :R2=R2+YY :HU=HU+1: LO = VPEEK(1,R2*$100 + R1*2)
305 FOR NN=0 TO 31
310    AA=MA(NN)
315    XX=XM(NN)-R1
320    YY=YM(NN)-R2
325    IF ABS(XX)+ABS(YY) <= 1 THEN GOSUB 1125 :GOTO 340
330    IF RND(1)>0.5 THEN 340
335    IF ABS(XX) < 9 AND ABS(YY) < 9 THEN GOSUB 1045
340 NEXT
345 IF C1 < 1 GOTO 360
350 IF (R1<76) AND (R1>3) AND (R2<42) AND (R2>5) GOTO 200
355 REM                      GAME OVER - PRINT SCORE
360 COLOR 1,$06 :REM WHITE ON BLUE
365 ? CHR$(147) :REM CLR
370 ? VP$(3)
375 ? SPC(6) "*** GAME OVER ***" 
380 ?
385 ?:?SPC(6) "YOUR ACCOMPLISHMENTS"
390 ?:?:? SPC(6) "ESCAPED THE FOREST: ";
395 IF C1 < 1 THEN ? "NO"
400 IF C1 > 0 THEN ? "YES"
405 ?:? SPC(6) "FOUND THE AMULET:   ";
410 IF R8 = 0 THEN ? "NO"
415 IF R8 = 1 THEN ? "YES"
420 ?:?:? SPC(6) "SCORE:             " R3
425 ?:?:? SPC(6) "THANK YOU FOR PLAYING ROGUE FOREST!"
430 END
435 ? VP$(45);
440 ? SPC(20) LI$: ? "\X91" SPC(30) "WEAPON: " R6$ " (" R6 ")"
445 ? SPC(20) LI$: ? "\X91" SPC(30) "ARMOR : " R7$ " (" R7 ")"
450 ? SPC(20) LI$: ? "\X91" SPC(30) "FOOD  : " R5
455 ? SPC(20) LI$: ? "\X91" SPC(30) "AMULET: " R8$ 
460 RETURN
465 IF R5 < 1 THEN RETURN
470 IF R4 < 1 THEN RETURN
475 R5 = R5 - 1
480 R4 = R4 - 1
485 T0 = 5
490 ? VP$(5) LI$ :?"\X91   YOU FEEL BETTER."
495 GOSUB 435
500 RETURN
505 REM                         BUILD THE FOREST
510 REM  SET UP VIDEO REGISTERS
515 POKE $9F2D, %01100000 :REM MAP HEIGHT=1, WIDTH=2 = 64X128 TILES
520 POKE $9F2E, %10000000 :REM MAP BASE ADDR = 128 X512 = $10000.
525 POKE $9F2F, %01111100 :REM TILE BASE ADDR = 31 X2K  = $F800.
530 REM ALSO, TILE HT=0, WD=0, SO 8 PIXELS X 8 PIXELS
535 REM  NO SCROLLING, PLEASE ($9F30-$9F33)
540 POKE $9F30, 0
545 POKE $9F31, 0
550 POKE $9F32, 0
555 POKE $9F33, 0
560 COLOR 1,0 :CLS  :REM 0=TRANSPARENT
565 POKE $9F29, %00110001 :REM $31=LAYERS 1,0. OUTPUT MODE=1 (VGA)
570 CC=0:CD=59 
575 IF VPEEK(1,0) = 32 THEN CC=8 :CD=40
580 REM  UNROLLING THIS LOOP SHAVES 5 SECS
585 CL=$05  :REM BG/FG COLOR NYBBLES ($15=WHITE UNDER GREEN)
590 REM MONSTER DATA
595 MN=0
600 DIM MA(31)
605 DIM XM(31),YM(31)
610 DIM SO(31) :REM TERRAIN THE MONSTER IS .S.TANDING .O.N
615 FOR Y=CC TO CD
620    Y0=Y*$100
625    FOR X=0 TO 158 STEP 8
630       P=Y0+X
635       IF Y<8 OR Y>40 GOTO 740
640       IF X<6 OR X>148 GOTO 740
645          FF=3
650          IF Y>8 AND Y<40 THEN FF=INT(RND(1)*3)
655          VPOKE 1,P,FO(FF) :REM CHARACTER INDEX
660          VPOKE 1,P+1,CL   :REM BG/FG COLOR NYBBLES
665          IF Y>8 AND Y<40 THEN FF=INT(RND(1)*3)
670          VPOKE 1,P+2,FO(FF)
675          VPOKE 1,P+3,CL
680          IF Y>8 AND Y<40 THEN FF=INT(RND(1)*3)
685          VPOKE 1,P+4,FO(FF)
690          VPOKE 1,P+5,CL
695          IF Y>8 AND Y<40 THEN FF=INT(RND(1)*3)
700          VPOKE 1,P+6,FO(FF)
705          VPOKE 1,P+7,CL
710          IF Y<9 OR Y>39 GOTO 780
715          REM TREASURE
720          IF RND(1) > 0.08 GOTO 780
725             XX = INT(RND(4))
730             VPOKE 1,P+2*XX,FO(5+INT(RND(1)*4))
735             GOTO 780
740             VPOKE 1,P,$20
745             VPOKE 1,P+1,CL
750             VPOKE 1,P+2,$20
755             VPOKE 1,P+3,CL
760             VPOKE 1,P+4,$20
765             VPOKE 1,P+5,CL
770             VPOKE 1,P+6,$20
775             VPOKE 1,P+7,CL
780    NEXT
785 NEXT
790 REM  PLACE MONSTERS
795 FOR M = 0 TO 31
800    X = 10 + INT(RND(1)*60)
805    Y = 10 + INT(RND(1)*30)
810    MA = Y * $100 + X * 2
815    MA(M) = MA
820    XM(M)=X
825    YM(M)=Y
830    SO(M) = VPEEK(1,MA)
835    VPOKE 1,MA,M
840 NEXT
845 REM AMULET OF YENDOR
850 VPOKE 1, INT(RND(1)*30+10) * $100 + INT(RND(1)*60+10) * 2, FO(10)
855 RETURN
860 REM  INITIALIZE 
865 GOSUB 2155 :REM INIT VP$()
870 L5$ = "\X91\X91\X91\X91\X91" :REM LEFT 5
875 C9$ = "         \X11\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
880 C9$ = C9$+C9$+C9$+C9$+C9$+C9$+C9$+C9$+C9$
885 DIM M$(31)
890 FOR X=0 TO 31 :READ M$(X) :NEXT
895 DATA  DOPPLEGANGER,  ABALONE,  BASILISK,    CENTAUR,    DRAGON
900 DATA  ETTIN,         FUZZY,    GHOUL,       HELLHOUND,  IMP
905 DATA  JINN,          KOBOLD,   LEPRECHAUN,  MINOTAUR,   NYMPH
910 DATA  ORC,           PYTHON,   QUAGGA,      RATTLER,    SKELETON
915 DATA  TROLL,         UR-VILE,  VAMPIRE,     WRAITH,     XEROC
920 DATA  YETI,          ZOMBIE,   WYVERN,      MANTICORE,  VELOCIRAPTOR
925 DATA  SPHINX,        SPIDER
930 FOR X=0 TO 7 :READ N$(X) :NEXT
935 DATA CHENEY, DURIN, FARGOL, KHAALO, REJNALDI, SARA, SHARIK, ZOG
940 FOR X=0 TO 7 :READ C$(X) :NEXT
945 DATA "","RED ","GREEN ","BLUE ","TIN ","WHITE ","PALE ","GOLD "
950 FOR X=0 TO 7 :READ D$(X) :NEXT
955 DATA ""," OF WAR"," OF AGILITY"," OF PAIN"," OF CUNNING"
960 DATA " OF SKILL",""," OF MAGIC"
965 FOR X=0 TO 7 :READ W$(X) :NEXT
970 DATA DAGGER, STAFF, HAMMER, MACHETE, AXE, SWORD, LABRYS, HALBERD
975 FOR X=0 TO 7 :READ A$(X) :NEXT
980 DATA LEATHER, HAUBERK, RINGMAIL, MESH, MAIL, SPLINT, PLATE, MITHRIL
985 REM FOREST ELEMENTS
990 FO(0) = $41 :REM TREE
995 FO(1) = $2E :REM DOT
1000 FO(2) = $2E :REM DOT
1005 FO(3) = $43 :REM HORIZ LINE
1010 FO(4) = $42 :REM VERT LINE
1015 FO(5) = $23 :REM ARMOR (#)
1020 FO(6) = $24 :REM FOOD ($)
1025 FO(7) = $27 :REM WEAPON (')
1030 FO(10) = $2A :REM AMULET OF YENDOR
1035 RETURN
1040 REM        MOVE MONSTER:NN ADDRESS:AA RELATIVE_POS:XX,YY
1045 VPOKE 1,AA,SO(NN)  :REM REDRAW TILE
1050 DX=0 :DY=0
1055 IF RND(1)>0.5 GOTO 1070
1060 IF XX<0 THEN AA=AA+2 :DX=1 :GOTO 1080
1065 IF XX>0 THEN AA=AA-2 :DX=-1 :GOTO 1080
1070 IF YY<0 THEN AA=AA+$100 :DY=1 :GOTO 1080
1075 IF YY>0 THEN AA=AA-$100 :DY=-1 :GOTO 1080
1080 V=VPEEK(1,AA)
1085 IF V < $20 OR V = $2A GOTO 1115
1090 SO(NN)=VPEEK(1,AA)
1095 MA(NN)=AA
1100 XM(NN)=XM(NN)+DX
1105 YM(NN)=YM(NN)+DY
1110 VPOKE 1,AA,NN
1115 RETURN
1120 REM                  MONSTER NN ATTACKS
1125 ? VP$(51) LI$ : ? "\X91";
1130 W = INT(RND(1)*4)
1135 IF INT(RND(1)*40) < R7 THEN W=0
1140 IF W=0 THEN ? "THE " M$(NN) " MISSES."
1145 IF W>0 THEN ? "THE " M$(NN) " HITS YOU FOR" W "POINTS." :GOSUB 1655
1150 C1 = C1 - W
1155 RETURN
1160 REM                  ATTACK MONSTER NN
1165 ? VP$(52) LI$ : ? "\X91";
1170 T1 = R6 AND 7
1175 T2 = (R6/8) AND 7
1180 T3 = (R6/64) AND 7
1185 T4 = (R6/256) AND 7
1190 T5 = T1+T2+T3+T4+1 - R4
1195 IF T5 < 2 THEN T5 = 2
1200 W = INT(RND(1)*T5)
1205 HU=HU+1
1210 N=RND(1) * NN
1215 ? "YOU HIT THE " M$(NN) " FOR" W "POINTS"; :GOSUB 1655
1220 IF W > N THEN ? ", KILLING IT";: VPOKE 1,MA(NN),$2E :YM(NN)=-1000 :R3=R3+W
1225 ? "."
1230 RETURN
1235 REM SET UP PANEL ARRAYS BASED ON MAX
1240 REM NUMBER OF PANELS (N=6)
1245 N = 6
1250 P7 = 0
1255 DIM P0$(N)
1260 DIM P1(N), P2(N), P3(N), P4(N)
1265 DIM P5$(N,30), P6(N)
1270 GOSUB 2155 :REM INIT VP$()
1275 REM HORIZONTAL BAR ARRAY
1280 DIM HB$(80)
1285 HB$(0) = "\XC3"
1290 FOR V=1 TO 80
1295    HB$(V) = HB$(V-1) + "\XC3"
1300 NEXT
1305 REM VERTICAL BAR ARRAY
1310 DIM VB$(30)
1315 VB$(0) = "\XC2\X11\X9D"
1320 FOR V=1 TO 30
1325    VB$(V) = VB$(V-1) + "\XC2\X11\X9D"
1330 NEXT
1335 REM  PANEL EDGES
1340 BA$ = "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1345 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1350 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1355 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1360 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1365 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1370 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1375 BA$ = BA$ + "\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D\X9D"
1380 SP$ = "                    "
1385 SP$ = SP$ + "                    "
1390 SP$ = SP$ + "                    "
1395 SP$ = SP$ + "                    "
1400 RETURN
1405 REM DRAW PANELS FROM VARIABLE DATA
1410 ? CHR$(147); :REM CLR
1415 FOR N = 0 TO P7 - 1
1420    ? VP$(P1(N)) SPC(P2(N))
1425    ? "\XD5\XC3" P0$(N) "\XC3";
1430    ? HB$(P3(N) - 3 - LEN(P0$(N)));
1435    ? "\XC9\X11";
1440    B2$ = LEFT$(BA$, P3(N)+2)
1445    S2$ = LEFT$(SP$, P3(N))
1450    FOR RR=3 TO P4(N)
1455    REM DON'T FORGET THE LINES !!
1460    ? B2$ "\XC2" S2$ "\XC2\X11";
1465    NEXT
1470    ? B2$ "\XCA";
1475    ? HB$(P3(N)-1);
1480    ? "\XCB";
1485 NEXT
1490 RETURN
1495 REM SHOW THE PANEL TEXTS
1500 FOR N = 0 TO P7 - 1
1505    ? VP$(P1(N));
1510    ?
1515    FOR X = 0 TO P4(N)-3
1520       ? SPC(P2(N)+2) P5$(N,X)
1525    NEXT
1530 NEXT
1535 RETURN
1540 REM ADD A PANEL TO THE LIST!
1545 REM T: TOP, L: LEFT, W: WIDTH, H:HEIGHT
1550 REM L$: LABEL
1555 N = P7
1560 P0$(N) = L$
1565 P1(N) = T
1570 P2(N) = L
1575 P3(N) = W
1580 P4(N) = H
1585 P6(N) = -1
1590 P7 = N + 1
1595 RETURN
1600 REM SET CONTENTS OF A PANEL
1605 REM N:PANEL NUM, BU$(): LINES, LC: LINE COUNT
1610 FOR X = 0 TO LC-1
1615    P5$(N,X) = BU$(X)
1620 NEXT
1625 RETURN
1630 IF PEEK($400)=0 THEN LOAD "RF-EFFECTS.PRG",8,1,$0400
1635 RETURN
1640 SYS $0400
1645 FOR T=1 TO 1000 :X=SQR(9999) :NEXT
1650 RETURN
1655 SYS $0403
1660 FOR T=1 TO 1000 :X=SQR(9999) :NEXT
1665 RETURN
1670 SYS $0406
1675 RETURN
1680 SYS $0409
1685 FOR T=1 TO 1000 :X=SQR(9999) :NEXT
1690 RETURN
1695 REM                       SPLASH SCREEN!
1700 ? CHR$(147)
1705 L= 1  :T= 5  :W= 76  :H= 13  :L$= "WELCOME"     :GOSUB 1555
1710 L= 1  :T= 19 :W= 76  :H= 15  :L$= "MAP KEY"     :GOSUB 1555
1715 L= 1  :T= 35 :W= 76  :H= 12  :L$= "COMMAND KEY" :GOSUB 1555
1720 GOSUB 1410 :REM DRAW PANELS
1725 ? VP$(0); :GOSUB 1870 :REM TITLE
1730 ? VP$(8)
1735 ? SPC(6) "FIND THE AMULET OF YENDOR AND EXIT THE FOREST ALIVE!"
1740 ?
1745 ? SPC(6) "POINTS ARE AWARDED FOR ITEMS COLLECTED AND MONSTERS KILLED."
1750 ? VP$(20)
1755 ? SPC(6) "@ ... YOU"
1760 ? SPC(6) CHR$(FO(0)) " ... TREE (IMPASSABLE BY YOU)"
1765 ? SPC(6) CHR$(FO(1)) " ... CLEARING"
1770 ? SPC(6) CHR$(FO(5)) " ... ARMOR"
1775 ? SPC(6) CHR$(FO(6)) " ... FOOD"
1780 ? SPC(6) CHR$(FO(7)) " ... WEAPON"
1785 ? SPC(6) CHR$(FO(10))" ... AMULET OF YENDOR"
1790 ?:?
1795 ? SPC(6) "-- ANYTHING THAT MOVES IS A MONSTER --"
1800 ? VP$(36)
1805 ? SPC(6) "? ............ HELP"
1810 ? SPC(6) "CURSOR KEYS .. MOVE / ATTACK"
1815 ? SPC(6) ". ............ REST"
1820 ? SPC(6) "E ............ EAT FOOD"
1825 ? SPC(6) "X ............ EXIT"
1830 ?
1835 ? VP$(50)
1840 ? "   GOOD LUCK!"
1845 ?
1850 INPUT "   PLEASE TYPE YOUR NAME"; R0$
1855 X=RND(-TI)
1860 RETURN
1865 REM PRINT TITLE
1870 ? "  ÕÃÃÕÀÉÕÀÉÂ ÂÕÀÀ  ÕÃÃÕÀÉÕÃÃÕÀÀÕÀÃÀ²À "
1875 ? "  Â  ÊÀËÊÀÛÊÀË«À   «À ÊÀËÂ  «À ÊÀÉ Â  "
1880 ? "         ÀË   ÊÀÀ  Â        ÊÀÀÃÀË1.0 "
1885 RETURN
1890 REM                   TREASURE FINDS (TYPE IN 'LO')
1895 COLOR 1,6
1900 REM CLEAR THE SQUARE THE PLAYER IS *LOOKING AT*
1905 VPOKE 1,(R2+YY)*$100 + (R1+XX)*2, $2E
1910 GOSUB 1640
1915 REM PRE-CALC SOME VALUES
1920 T1=INT(RND(1)*8)
1925 T2=INT(RND(1)*8)
1930 T3=INT(RND(1)*8)
1935 T4=INT(RND(1)*8)
1940 REM FIGURE OUT WHAT WE GOT
1945 IF LO=FO(10) GOTO 1970
1950 IF LO=FO(5)  GOTO 1995
1955 IF LO=FO(6)  GOTO 2050
1960 IF LO=FO(7)  GOTO 2075
1965 RETURN
1970 ? VP$(5) LI$ :? "\X91   YOU FOUND THE AMULET OF YENDOR! "
1975 R8$ = "FOUND IT!"
1980 R8=1  :REM PLAYER-YENDOR
1985 T0 = 5
1990 RETURN
1995 R3 = R3 + T1+T2+T3+T4
2000 AD$ = N$(T1) + "'S " + C$(T2) + A$(T3) + D$(T4)
2005 GOSUB 2130
2010 ? "YOU FOUND " AD$
2015 ? "REPLACE YOUR CURRENT ARMOR WITH IT? [YN] "; 
2020 GET YN$ :IF YN$<> "Y" AND YN$ <> "N" GOTO 2020
2025 GOSUB 2140
2030 IF YN$ = "N" THEN RETURN
2035 R7 = T1 + T2 +T3 + T4 
2040 R7$ = AD$
2045 RETURN
2050 T1 = INT(RND(1)*8+1)
2055 ? VP$(5) LI$ :?"\X91   YOU FOUND" T1 "FOOD."
2060 R5=R5 + T1
2065 T0 = 5
2070 RETURN
2075 R3 = R3 + T1+T2+T3+T4
2080 WD$ = N$(T1) + "'S " + C$(T2) + W$(T3) + D$(T4)
2085 GOSUB 2130
2090 ? "YOU FOUND " WD$
2095 ? "REPLACE YOUR CURRENT WEAPON WITH IT? [YN] "; 
2100 GET YN$ :IF YN$<> "Y" AND YN$ <> "N" GOTO 2100
2105 GOSUB 2140
2110 IF YN$ = "N" THEN RETURN
2115 R6 = T1 + T2 * 8 + T3 * 64 + T4 * 256
2120 R6$ = WD$
2125 RETURN
2130 ? VP$(51) LI$ :?"\X91";
2135 RETURN
2140 ? "\X91\X91\X91" LI$ :?LI$ :?LI$
2145 RETURN
2150 REM INITIALIZE VERTICAL POSITION ARRAY
2155 IF VP=1 THEN RETURN
2160 DIM VP$(60)
2165 VP$(0)="\X13"
2170 FOR V=1 TO 60
2175    VP$(V) = VP$(V-1) + "\X11"
2180 NEXT
2185 VP=1
2190 RETURN
