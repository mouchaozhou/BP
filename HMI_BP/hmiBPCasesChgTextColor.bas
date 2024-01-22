Attribute VB_Name = "Ä£¿é1"
Sub hmiBPCasesChgTextColor()
    Dim i As Integer
    Dim col As Integer
    
    For col = 7 To 8
        For i = 3 To 72
            Set cell = Sheets(1).Cells(i, col)  'The index of array starts from 1, not 0.
        
            If cell.Value = "Emergence" Then
                cell.Font.Color = vbRed
            ElseIf cell.Value = "Convergence" Then
                cell.Font.Color = vbBlue
			ElseIf cell.Value = "Local Combination" Then
				cell.Font.Color = vbBlack
            End If
        Next
    Next
End Sub
