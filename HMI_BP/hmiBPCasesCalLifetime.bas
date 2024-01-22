
Sub hmiBPCasesCalLifetime()
    Dim line As Integer
    Dim beginTime As Date
    Dim endTime As Date
    Dim minute As Single
    
    For line = 3 To 72
        beginTime = Sheets(1).Cells(line, 2)        'The index of array starts from 1, not 0.
        endTime = Sheets(1).Cells(line, 3)
        minute = DateDiff("n", beginTime, endTime)  'Calculate the difference of the time in minutes
        minute = minute / 60                        'Change minutes to hours
        Set lifetime = Sheets(1).Cells(line, 4)
        lifetime.Value = Format(minute, "0.0")
    Next

End Sub