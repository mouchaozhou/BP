
Sub hmiBPCasesCancelStat2Num()
    Dim line As Integer
    Dim num As Integer
    Dim cancelStat As String
    Set oRegExp = CreateObject("vbscript.regexp")
    
    '�����Ƿ�ƥ�����еķ����True��ʾƥ������, False��ʾ��ƥ���һ��������
    oRegExp.Global = True
    '�����Ƿ����ִ�Сд��True��ʾ�����ִ�Сд, False��ʾ���ִ�Сд
    oRegExp.IgnoreCase = True
        
    For line = 3 To 72
        cancelStat = Sheets(1).Cells(line, 11)        'The index of array starts from 1, not 0.
        Set cancelStatInt = Sheets(1).Cells(line, 16)
                
        oRegExp.Pattern = "ǰ��"    				  '����Ҫ���ҵ��ַ�ģʽ
        If oRegExp.Test(cancelStat) Then			  '�ж��Ƿ�����ҵ�ƥ����ַ����������򷵻�True	
            num = 1
            cancelStatInt.Value = num
            GoTo Continue
        End If
        
        oRegExp.Pattern = "����"
        If oRegExp.Test(cancelStat) Then
            num = 2
            cancelStatInt.Value = num
            GoTo Continue
        End If
        
        oRegExp.Pattern = "����"
        If oRegExp.Test(cancelStat) Then
            num = 3
            cancelStatInt.Value = num
            GoTo Continue
        End If
        
        oRegExp.Pattern = "��"
        If oRegExp.Test(cancelStat) Then
            num = 0
            cancelStatInt.Value = num
            GoTo Continue
        End If
Continue:
    Next
End Sub