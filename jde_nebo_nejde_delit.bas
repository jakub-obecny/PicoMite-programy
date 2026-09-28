10 Print "vase cislo: "
11 Input A
12 C=1
20 If A MOD C = 0 Then GoTo 21 Else GoTo 22
21 Print "lze delit cislem " C: GoTo 30
22 Print "nelze delit cislem " C: GoTo 30
30 EndIf
31 C=2
40 If A MOD C = 0 Then GoTo 41 Else GoTo 42
41 Print "lze delit cislem " C: GoTo 50
42 Print "nelze delit cislem " C: GoTo 50
50 EndIf
51 C=3
60 If A MOD C = 0 Then GoTo 61 Else GoTo 62
61 Print "lze delit cislem " C: GoTo 70
62 Print "nelze delit cislem " C: GoTo 70
70 EndIf
71 C=4
80 If A MOD C = 0 Then GoTo 81 Else GoTo 82
81 Print "lze delit cislem " C: GoTo 90
82 Print "nelze delit cislem " C: GoTo 90
90 EndIf
91 C=5
100 If A MOD C = 0 Then GoTo 101 Else GoTo 102
101 Print "lze delit cislem " C: GoTo 110
102 Print "nelze delit cislem " C: GoTo 110
110 EndIf
111 C=6
120 If A MOD C = 0 Then GoTo 121 Else GoTo 122
121 Print "lze delit cislem " C: GoTo 130
122 Print "nelze delit cislem " C: GoTo 130
130 EndIf
131 C=7
140 If A MOD C = 0 Then GoTo 141 Else GoTo 142
141 Print "lze delit cislem " C: GoTo 150
142 Print "nelze delit cislem " C: GoTo 150
150 EndIf
151 C=8
160 If A MOD C = 0 Then GoTo 161 Else GoTo 162
161 Print "lze delit cislem " C: GoTo 170
162 Print "nelze delit cislem " C: GoTo 170
170 EndIf
171 C=9
180 If A MOD C = 0 Then GoTo 181 Else GoTo 182
181 Print "lze delit cislem " C: GoTo 190
182 Print "nelze delit cislem " C: GoTo 190
190 EndIf
200 GoTo 10
