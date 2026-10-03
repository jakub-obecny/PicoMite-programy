' GET TIME
' WebMite 6.1.0

' Standard (winter) offset from UTC in hours: 1 = CET, 0 = UK, 2 = Finland/Greece...
tz = 1

' First set the clock to UTC
WEB NTP 0

' Year
yr$ = Right$(Date$, 4)

' Find the last Sunday in March
d = 31
Do
  dat$ = Str$(d) + "-03-" + yr$
  If Day$(dat$) = "Sunday" Then Exit Do
  d = d - 1
Loop
mar = d

' Find the last Sunday in October
d = 31
Do
  dat$ = Str$(d) + "-10-" + yr$
  If Day$(dat$) = "Sunday" Then Exit Do
  d = d - 1
Loop
oct = d

' Current UTC date and time
mon = Val(Mid$(Date$, 4, 2))
day = Val(Left$(Date$, 2))
hour = Val(Left$(Time$, 2))

' Decide whether daylight saving time is active (dst = 1) or not (dst = 0)
dst = 0

If mon > 3 And mon < 10 Then
  dst = 1
EndIf

If mon = 3 Then
  If day > mar Then dst = 1
  If day = mar And hour >= 1 Then dst = 1
EndIf

If mon = 10 Then
  If day < oct Then dst = 1
  If day = oct And hour < 1 Then dst = 1
EndIf

' Apply local time: standard offset + 1 hour if DST is active
WEB NTP tz + dst
Print "UTC+" + Str$(tz + dst)

Print ""
Print "------------"
Print "Time:"
Print Time$, Date$