;+===========================annotation--begin===================================================
; :Purpose:
;    将 Magnetic Formation 中的Emergence\ convergence和Emergence4的序号标注位置找出来
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

;输入路径和文件
savdir = 'C:\Users\yanlm\Desktop\work\'
savFile = 'repBPDistVaryData.sav'

;恢复数据
restore,savDir+savFile,/ve

;位置
pos = [0.1,0.2,0.9,0.9]
;颜色
device,decomposed=1

xArr = [0.5,2.5]
;#test
;tmp = 0
;for i=0,tmp,tmp do begin
for i=0,0 do begin
;    print,'i : ',i
;#endtest
;for i=0,n_elements(emgBegDis)-1 do begin 
    if (i eq 0) then begin
        window,0,xsize=1000,ysize=606.25,retain=2
        minY = min([emgBegDis,emgPekDis,covBegDis,covPekDis,locBegDis,locPekDis]) - 1
        maxY = max([emgBegDis,emgPekDis,covBegDis,covPekDis,locBegDis,locPekDis]) + 1
        plot,xArr,[emgBegDis[i],emgPekDis[i]],xstyle=1,ystyle=1,psym=-4, $
             xrange=[0,9], $
             yrange=[minY,maxY],ytitle='Distance (arcsec)',/nodata                                  
    endif $
    else begin
        oplot,xArr,[emgBegDis[i],emgPekDis[i]],psym=-4       
    endelse
    ;print,'Event Number: '+emgEvtNum[i]
    ;取点
    ;CursorPoints,x=x,y=y,file=tmpFile,/info,/down,/data,psym=2
    
    ;xyouts,x,y,emgEvtNum[i],/data,color=GetColour('Yellow'),charsize=0.5
endfor

;Convergence
xArr = [4,5]
;for i=0,n_elements(covBegDis)-1 do begin
;    oplot,xArr,[covBegDis[i],covPekDis[i]],psym=-2
;    print,'i : ',i
;    print,'Event Number: '+covEvtNum[i]
;    CursorPoints,x=x,y=y,file=tmpFile,/info,/down,/data,psym=2 
;    xyouts,x,y,covEvtNum[i],/data,color=GetColour('Yellow'),charsize=0.4
;endfor

;Emergence4
for i=0,n_elements(emg4BegDis)-1 do begin
    oplot,xArr,[emg4BegDis[i],emg4PekDis[i]],psym=-2
    print,'i : ',i
    print,'Event Number: '+emg4EvtNum[i]
    CursorPoints,x=x,y=y,file=tmpFile,/info,/down,/data,psym=2
    xyouts,x,y,emg4EvtNum[i],/data,color=GetColour('Yellow'),charsize=0.4
endfor


Over
END  
