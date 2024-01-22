
Sub hmiBPCasesCancelStat2Num()
    Dim line As Integer
    Dim num As Integer
    Dim cancelStat As String
    Set oRegExp = CreateObject("vbscript.regexp")
    
    '设置是否匹配所有的符合项，True表示匹配所有, False表示仅匹配第一个符合项
    oRegExp.Global = True
    '设置是否区分大小写，True表示不区分大小写, False表示区分大小写
    oRegExp.IgnoreCase = True
        
    For line = 3 To 72
        cancelStat = Sheets(1).Cells(line, 11)        'The index of array starts from 1, not 0.
        Set cancelStatInt = Sheets(1).Cells(line, 16)
                
        oRegExp.Pattern = "前期"    				  '设置要查找的字符模式
        If oRegExp.Test(cancelStat) Then			  '判断是否可以找到匹配的字符，若可以则返回True	
            num = 1
            cancelStatInt.Value = num
            GoTo Continue
        End If
        
        oRegExp.Pattern = "中期"
        If oRegExp.Test(cancelStat) Then
            num = 2
            cancelStatInt.Value = num
            GoTo Continue
        End If
        
        oRegExp.Pattern = "后期"
        If oRegExp.Test(cancelStat) Then
            num = 3
            cancelStatInt.Value = num
            GoTo Continue
        End If
        
        oRegExp.Pattern = "无"
        If oRegExp.Test(cancelStat) Then
            num = 0
            cancelStatInt.Value = num
            GoTo Continue
        End If
Continue:
    Next
End Sub