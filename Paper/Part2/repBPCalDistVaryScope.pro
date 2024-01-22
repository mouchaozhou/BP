;+===========================annotation--begin===================================================
; :Purpose:
;    将 Magnetic Formation 中的 Local coalescence的距离变化百分比计算出来
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

;输入路径和文件
savdir = 'C:\Users\yanlm\Desktop\work\'
savFile = 'repBPDistVaryData.sav'

;恢复数据
restore,savDir+savFile,/ve

meanDistVaryScopeArr = fltarr(n_elements(locBegDis))

for i=0,n_elements(locBegDis)-1 do begin
    print,locBegDis[i],locPekDis[i]
    meanDistVaryScopeArr[i] = abs((float(locPekDis[i]) - float(locBegDis[i]))) / float(locBegDis[i])
endfor

print,meanDistVaryScopeArr
print,Means(meanDistVaryScopeArr)


END