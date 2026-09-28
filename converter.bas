'---------------------------------------
' BASE CONVERTER FOR PICOMITE 6.0.x
' RPi Pico 2WH + PuTTY
' No graphics or CLS
' Lines max 40 chars
'---------------------------------------

MAIN:
PRINT
PRINT "=============================="
PRINT "      BASE CONVERTER"
PRINT "=============================="
PRINT
PRINT "1 BIN"
PRINT "2 HEX"
PRINT "3 DEC"
PRINT "4 ASCII"
PRINT
INPUT "INPUT TYPE: ",IM%
GOSUB CLEARKEYS

IF IM% < 1 OR IM% > 4 THEN
  PRINT "INVALID CHOICE"
  PAUSE 800
  GOTO MAIN
ENDIF

PRINT
PRINT "ENTER INPUT"
PRINT "TAB OR ENTER = DONE"
PRINT "BACKSPACE = DELETE"
PRINT
PRINT "> ";

S$ = ""
GOSUB GETINPUT

IF LEN(S$) = 0 THEN GOTO MAIN

OUTMENU:
PRINT
PRINT "INPUT: ";S$
PRINT
PRINT "OUTPUT TYPE:"
PRINT "1 BIN"
PRINT "2 HEX"
PRINT "3 DEC"
PRINT "4 ASCII"
PRINT
INPUT "OUTPUT: ",OM%
GOSUB CLEARKEYS

IF OM% < 1 OR OM% > 4 THEN
  PRINT "INVALID CHOICE"
  PAUSE 800
  GOTO OUTMENU
ENDIF

R$ = CONVERT$(S$,IM%,OM%)

PRINT
PRINT "RESULT"
PRINT "=============================="
PRINT R$
PRINT "=============================="
PRINT

INPUT "SAVE TO FILE? Y/N: ",Y$
GOSUB CLEARKEYS

IF UCASE$(LEFT$(Y$,1)) = "Y" THEN
  INPUT "FILENAME: ",F$
  GOSUB CLEARKEYS

  IF LEN(F$) > 0 THEN
    OPEN F$ FOR OUTPUT AS #1
    PRINT #1,"PicoMite Converter"
    PRINT #1,"Input: ";S$
    PRINT #1,"Result:"
    PRINT #1,R$
    CLOSE #1
    PRINT
    PRINT "SAVED: ";F$
  ENDIF
ENDIF

PRINT
PRINT "PRESS ANY KEY"
GOSUB CLEARKEYS
GOSUB WAITKEY
GOTO MAIN

'---------------------------------------
' CLEAR SERIAL INPUT
'---------------------------------------

CLEARKEYS:
K$ = INKEY$
IF K$ <> "" THEN GOTO CLEARKEYS
RETURN

'---------------------------------------
' KEYBOARD INPUT
'---------------------------------------

GETINPUT:
K$ = INKEY$
IF K$ = "" THEN GOTO GETINPUT

A% = ASC(K$)

IF A% = 9 OR A% = 10 OR A% = 13 THEN
  PRINT
  RETURN
ENDIF

IF A% = 8 OR A% = 127 THEN
  IF LEN(S$) > 0 THEN
    S$ = LEFT$(S$,LEN(S$)-1)
    PRINT CHR$(8);" ";CHR$(8);
  ENDIF
  GOTO GETINPUT
ENDIF

IF A% < 32 THEN GOTO GETINPUT

S$ = S$ + K$
PRINT K$;
GOTO GETINPUT

'---------------------------------------
' CONVERTER
'---------------------------------------

FUNCTION CONVERT$(S$,IM%,OM%)
LOCAL N%,T$,I%,V%

IF IM% = 4 THEN
  IF OM% = 4 THEN
    CONVERT$ = S$
    EXIT FUNCTION
  ENDIF

  T$ = ""

  FOR I% = 1 TO LEN(S$)
    V% = ASC(MID$(S$,I%,1))

    IF OM% = 1 THEN
      T$ = T$ + B8$(V%)
    ENDIF

    IF OM% = 2 THEN
      T$ = T$ + H2$(V%)
    ENDIF

    IF OM% = 3 THEN
      T$ = T$ + STR$(V%)
    ENDIF

    IF I% < LEN(S$) THEN
      T$ = T$ + " "
    ENDIF
  NEXT I%

  CONVERT$ = T$
  EXIT FUNCTION
ENDIF

IF OM% = 4 THEN
  IF IM% = 1 THEN
    T$ = BINASCII$(S$)
  ELSEIF IM% = 2 THEN
    T$ = HEXASCII$(S$)
  ELSE
    T$ = DECASCII$(S$)
  ENDIF

  CONVERT$ = T$
  EXIT FUNCTION
ENDIF

IF IM% = 1 THEN
  N% = B2D%(S$)
ELSEIF IM% = 2 THEN
  N% = H2D%(S$)
ELSE
  N% = D2D%(S$)
ENDIF

IF N% < 0 THEN
  CONVERT$ = "ERROR: INVALID INPUT"
  EXIT FUNCTION
ENDIF

IF OM% = 1 THEN
  CONVERT$ = D2B$(N%)
ELSEIF OM% = 2 THEN
  CONVERT$ = D2H$(N%)
ELSE
  CONVERT$ = STR$(N%)
ENDIF

END FUNCTION

'---------------------------------------
' BINARY TO DECIMAL
'---------------------------------------

FUNCTION B2D%(S$)
LOCAL I%,N%,C$

S$ = CLEAN$(S$)

IF LEN(S$) = 0 THEN
  B2D% = -1
  EXIT FUNCTION
ENDIF

N% = 0

FOR I% = 1 TO LEN(S$)
  C$ = MID$(S$,I%,1)

  IF C$ <> "0" AND C$ <> "1" THEN
    B2D% = -1
    EXIT FUNCTION
  ENDIF

  N% = N% * 2 + ASC(C$) - 48
NEXT I%

B2D% = N%
END FUNCTION

'---------------------------------------
' HEX TO DECIMAL
'---------------------------------------

FUNCTION H2D%(S$)
LOCAL I%,N%,C$,V%

S$ = CLEAN$(S$)

IF LEN(S$) = 0 THEN
  H2D% = -1
  EXIT FUNCTION
ENDIF

N% = 0

FOR I% = 1 TO LEN(S$)
  C$ = UCASE$(MID$(S$,I%,1))

  IF C$ >= "0" AND C$ <= "9" THEN
    V% = ASC(C$) - 48
  ELSEIF C$ >= "A" AND C$ <= "F" THEN
    V% = ASC(C$) - 55
  ELSE
    H2D% = -1
    EXIT FUNCTION
  ENDIF

  N% = N% * 16 + V%
NEXT I%

H2D% = N%
END FUNCTION

'---------------------------------------
' DECIMAL CHECK
'---------------------------------------

FUNCTION D2D%(S$)
LOCAL I%,N%,C$

S$ = CLEAN$(S$)

IF LEN(S$) = 0 THEN
  D2D% = -1
  EXIT FUNCTION
ENDIF

N% = 0

FOR I% = 1 TO LEN(S$)
  C$ = MID$(S$,I%,1)

  IF C$ < "0" OR C$ > "9" THEN
    D2D% = -1
    EXIT FUNCTION
  ENDIF

  N% = N% * 10 + ASC(C$) - 48
NEXT I%

D2D% = N%
END FUNCTION

'---------------------------------------
' DECIMAL TO BINARY
'---------------------------------------

FUNCTION D2B$(N%)
LOCAL T$,R%

IF N% = 0 THEN
  D2B$ = "0"
  EXIT FUNCTION
ENDIF

T$ = ""

DO WHILE N% > 0
  R% = N% MOD 2
  T$ = STR$(R%) + T$
  N% = N% \ 2
LOOP

D2B$ = T$
END FUNCTION

'---------------------------------------
' DECIMAL TO HEX
'---------------------------------------

FUNCTION D2H$(N%)
LOCAL T$,R%,D$

D$ = "0123456789ABCDEF"

IF N% = 0 THEN
  D2H$ = "0"
  EXIT FUNCTION
ENDIF

T$ = ""

DO WHILE N% > 0
  R% = N% MOD 16
  T$ = MID$(D$,R%+1,1) + T$
  N% = N% \ 16
LOOP

D2H$ = T$
END FUNCTION

'---------------------------------------
' 8 BIT BINARY
'---------------------------------------

FUNCTION B8$(N%)
LOCAL I%,T$,Q%

T$ = ""

FOR I% = 7 TO 0 STEP -1
  Q% = (N% \ (2^I%)) MOD 2
  T$ = T$ + STR$(Q%)
NEXT I%

B8$ = T$
END FUNCTION

'---------------------------------------
' 2 DIGIT HEX
'---------------------------------------

FUNCTION H2$(N%)
LOCAL D$

D$ = "0123456789ABCDEF"

H2$ = MID$(D$,(N%\16)+1,1)
H2$ = H2$ + MID$(D$,(N% MOD 16)+1,1)
END FUNCTION

'---------------------------------------
' BINARY TO ASCII
'---------------------------------------

FUNCTION BINASCII$(S$)
LOCAL I%,V%,P$,T$

S$ = CLEAN$(S$)

IF LEN(S$) MOD 8 <> 0 THEN
  BINASCII$ = "ERROR: USE 8 BIT GROUPS"
  EXIT FUNCTION
ENDIF

T$ = ""

FOR I% = 1 TO LEN(S$) STEP 8
  P$ = MID$(S$,I%,8)
  V% = B2D%(P$)

  IF V% < 0 OR V% > 255 THEN
    BINASCII$ = "ERROR: INVALID BYTE"
    EXIT FUNCTION
  ENDIF

  T$ = T$ + CHR$(V%)
NEXT I%

BINASCII$ = T$
END FUNCTION

'---------------------------------------
' HEX TO ASCII
'---------------------------------------

FUNCTION HEXASCII$(S$)
LOCAL I%,V%,P$,T$

S$ = CLEAN$(S$)

IF LEN(S$) MOD 2 <> 0 THEN
  HEXASCII$ = "ERROR: USE 2 DIGIT GROUP"
  EXIT FUNCTION
ENDIF

T$ = ""

FOR I% = 1 TO LEN(S$) STEP 2
  P$ = MID$(S$,I%,2)
  V% = H2D%(P$)

  IF V% < 0 OR V% > 255 THEN
    HEXASCII$ = "ERROR: INVALID BYTE"
    EXIT FUNCTION
  ENDIF

  T$ = T$ + CHR$(V%)
NEXT I%

HEXASCII$ = T$
END FUNCTION

'---------------------------------------
' DECIMAL TO ASCII
'---------------------------------------

FUNCTION DECASCII$(S$)
LOCAL I%,P%,V%,T$,W$

T$ = ""
I% = 1

DO WHILE I% <= LEN(S$)

  DO WHILE I% <= LEN(S$)
    IF MID$(S$,I%,1) <> " " THEN EXIT DO
    I% = I% + 1
  LOOP

  IF I% > LEN(S$) THEN EXIT DO

  P% = INSTR(I%,S$," ")

  IF P% = 0 THEN
    W$ = MID$(S$,I%)
    I% = LEN(S$) + 1
  ELSE
    W$ = MID$(S$,I%,P%-I%)
    I% = P% + 1
  ENDIF

  V% = D2D%(W$)

  IF V% < 0 OR V% > 255 THEN
    DECASCII$ = "ERROR: VALUES 0-255"
    EXIT FUNCTION
  ENDIF

  T$ = T$ + CHR$(V%)
LOOP

DECASCII$ = T$
END FUNCTION

'---------------------------------------
' REMOVE SEPARATORS
'---------------------------------------

FUNCTION CLEAN$(S$)
LOCAL I%,C$,T$

T$ = ""

FOR I% = 1 TO LEN(S$)
  C$ = MID$(S$,I%,1)

  IF C$ <> " " THEN
    IF C$ <> "_" THEN
      IF C$ <> "," THEN
        T$ = T$ + C$
      ENDIF
    ENDIF
  ENDIF
NEXT I%

CLEAN$ = T$
END FUNCTION

'---------------------------------------
' WAIT FOR KEY
'---------------------------------------

WAITKEY:
K$ = INKEY$
IF K$ = "" THEN GOTO WAITKEY
RETURN