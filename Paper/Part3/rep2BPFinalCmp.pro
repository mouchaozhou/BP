;+===========================annotation--begin===================================================
; 半小时smooth，跳过1小时，取3小时比平滑后峰值
;-===========================annotation--begin===================================================

@rep2BP.in
device,decomposed=1

;输出路径
outDir = MakeDir('../Image/test_FinalCmp/') 

for j=11,21 do begin
;for j=1,10 do begin  
    areaNum = IToA(j)
    ;输入路径
    hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
    hmiInboxMoreDir = '../../HMI_BP/Save/PhysInboxMore/' + date + '/' + wavelen + '/' + areaNum + '/'
      
    ;恢复sav中存放的数据(曲线数据)
    hmiBPGetBoxSavData,hmiInboxDir+'*.sav',arrTime=arrTime
    hmiBPGetBoxSavData,hmiInboxMoreDir+'*.sav',arrTime=arrTimeMore,Intensity=IntensityMore
    
    ;只截取有用部分
    arrTime = rep2BPStrmidTime(arrTime)
    arrTimeMore = rep2BPStrmidTime(arrTimeMore)
    
    bpBgAndEdTime = rep2BPGetOrigBgAndEdTime(areaNum)
    ;获得手选的起始和结束时间
    oldBeginTime = rep2BPFormatTime(bpBgAndEdTime[0])
    oldEndTime = Last(arrTime)
    
    
    ;平均开始时刻4小时前到1小时前的数据
    bgTimeIndex = WhereEx(oldBeginTime eq arrTimeMore)
    if ((bgTimeIndex-240) ge 0) then begin ;3h
        meanBg = Means(IntensityMore[bgTimeIndex-240 : bgTimeIndex-60],/nan) ;因为1min平均过       
    endif $
    else begin
        meanBg = Means(IntensityMore[0 : bgTimeIndex-60],/nan) ;因为1min平均过
    endelse
    
    ;平均结束时刻后2.5小时的数据
    edTimeIndex = WhereEx(oldEndTime eq arrTimeMore)
    if ((edTimeIndex+150) le (n_elements(arrTimeMore)-1)) then begin ;2.5h
        meanEd =  Means(IntensityMore[edTimeIndex : edTimeIndex+150],/nan) 
    endif $
    else begin
        meanEd =  Means(IntensityMore[edTimeIndex : n_elements(arrTimeMore)-1],/nan)
    endelse
    
    ;起始时间线和结束时间线
    
    
    ;画图
    window,0,xsize=1200,ysize=600,retain=2
    utplot,arrTimeMore,IntensityMore,/xstyle,/ystyle,/noerase,position=[0.1,0.1,0.9,0.9],yticklen=0.01,title=areaNum
    ;画手动的起始时间   
    outplot,[oldBeginTime,oldBeginTime],[min(IntensityMore),max(IntensityMore)],color=GetColour('Yellow')
    ;画手动的结束时间
    
    outplot,[oldEndTime,oldEndTime],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
    
    
    ;画选取的开始部分平均的时间范围
;    if ((bgTimeIndex-240) ge 0) then begin
;        outplot,[arrTimeMore[bgTimeIndex-240],arrTimeMore[bgTimeIndex-240]],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
;    endif $
;    else begin
;        outplot,[arrTimeMore[0],arrTimeMore[0]],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
;    endelse
;    outplot,[arrTimeMore[bgTimeIndex-60],arrTimeMore[bgTimeIndex-60]],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
    
    
    ;画选取的结束部分平均的时间范围
;    if ((edTimeIndex+150) le (n_elements(arrTimeMore)-1)) then begin ;2.5h
;        outplot,[arrTimeMore[edTimeIndex+150],arrTimeMore[edTimeIndex+150]],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
;    endif $
;    else begin
;        outplot,[Last(arrTimeMore),Last(arrTimeMore)],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
;    endelse
    ;outplot,[arrTimeMore[edTimeIndex],arrTimeMore[edTimeIndex]],[min(IntensityMore),max(IntensityMore)],color=GetColour('Blue')
    
    
    ;画平均强度线（开始）
    outplot,arrTimeMore,replicate(meanBg,n_elements(arrTimeMore)),color=GetColour('Yellow')
    
    ;画平均强度线（结束）
    outplot,arrTimeMore,replicate(meanEd,n_elements(arrTimeMore)),color=GetColour('Blue')

    write_png,outDir+areaNum+'.png',tvrd(true=1)
endfor    
   
Over
END
