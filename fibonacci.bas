1 OPEN "out.txt" FOR OUTPUT AS #1
5 COLOR GREEN
10 PRINT "Iteration count:";: INPUT A
20 IF A < 1 THEN CLOSE #1: END

30 ' Zvetseni baze na 8 cifer -> staci pole jen na 120 prvku
40 DIM INTEGER B(120), C(120), D(120)
50 B(0) = 0: C(0) = 1
60 LB = 1: LC = 1

70 PRINT #1, "1: 0"
80 IF A = 1 THEN GOTO 380
90 PRINT #1, "---"
100 PRINT #1, "2: 1"
110 IF A = 2 THEN GOTO 380

120 PRINT "Pocitam... Prosim cekej."

130 FOR I = 3 TO A
140   PRINT #1, "---"
150   CARRY% = 0
160   ML = LC
170   IF LB > ML THEN ML = LB

180   FOR J = 0 TO ML
190     SUM% = B(J) + C(J) + CARRY%
200     D(J) = SUM% MOD 100000000
210     CARRY% = SUM% \ 100000000
220   NEXT J

230   IF D(ML) > 0 THEN LD = ML + 1 ELSE LD = ML

240   ' Zapis cisla primo do souboru out.txt
250   PRINT #1, STR$(I) + ": "; STR$(D(LD - 1));
260   FOR J = LD - 2 TO 0 STEP -1
270     K$ = RIGHT$("0000000" + STR$(D(J)), 8)
280     PRINT #1, K$;
290   NEXT J
300   PRINT #1, ""

310   ' Ukazatel pokroku v terminalu kazdych 100 iteraci
320   IF I MOD 100 = 0 OR I = A THEN
330     PRINT "Hotovo iteraci: "; I; " / "; A
340     FLUSH #1
350   ENDIF

360   ' Posun poli
370   FOR J = 0 TO LC - 1: B(J) = C(J): NEXT J
380   LB = LC
390   FOR J = 0 TO LD - 1: C(J) = D(J): NEXT J
400   LC = LD
410 NEXT I

420 CLOSE #1
430 COLOR WHITE
440 PRINT "Hotovo! Vsechna cela cisla jsou ulozena v out.txt"