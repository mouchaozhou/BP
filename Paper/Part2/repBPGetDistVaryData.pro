;+===========================annotation--begin===================================================
; :Purpose:
;    将 Magnetic Formation 中的Emergence、 Convergence 和  Local coalescence数据读出来并存储
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

;输入路径和文件
exceldir = 'C:\Users\yanlm\Desktop\work\'
excelFile = 'hmiBPCases.xlsx'

;输出路径和文件
savFile = 'repBPDistVaryData.sav'

;事件编号
evntNum = strcompress(fix(reform(ReadExcel(exceldir+excelFile,"A3:A72"))),/remove_all)
;正极磁场形成类型
posType = strcompress(reform(ReadExcel(exceldir+excelFile,"G3:G72")),/remove_all)
;负极磁场形成类型
negType = strcompress(reform(ReadExcel(exceldir+excelFile,"H3:H72")),/remove_all)
;亮点出现时主正负极距离
begDist = fix(reform(round(float(ReadExcel(exceldir+excelFile,"N3:N72")))))
;亮点到峰值时主正负极距离
pekDist = fix(reform(round(float(ReadExcel(exceldir+excelFile,"O3:O72")))))

for i=0,69 do begin   
    if ((posType[i] eq 'Emergence') && (negType[i] eq 'Emergence')) then begin
        Push,emgBegDis,begDist[i]
        Push,emgPekDis,pekDist[i]
        Push,emgEvtNum,evntNum[i]
    endif $
    else if ((posType[i] eq 'Convergence') && (negType[i] eq 'Convergence')) then begin
        Push,covBegDis,begDist[i]
        Push,covPekDis,pekDist[i]
        Push,covEvtNum,evntNum[i]
    endif $
    else if ((posType[i] eq 'LocalCombination') && (negType[i] eq 'LocalCombination')) then begin
        Push,locBegDis,begDist[i]
        Push,locPekDis,pekDist[i]
        Push,locEvtNum,evntNum[i]
    endif
endfor

;#test
print,n_elements(emgBegDis)
print,n_elements(covBegDis)
print,n_elements(locBegDis)
;#endtest

save,emgBegDis,emgPekDis,emgEvtNum, $
     covBegDis,covPekDis,covEvtNum, $
     locBegDis,locPekDis,locEvtNum, $
     filename=exceldir+savFile

;删除数组
undefine,emgBegDis
undefine,emgPekDis
undefine,emgEvtNum
undefine,covBegDis
undefine,covPekDis
undefine,covEvtNum
undefine,locBegDis
undefine,locPekDis
undefine,locEvtNum

Over
END    