;+===========================annotation--begin===================================================
; 半小时smooth，跳过1小时，取3小时比平滑后峰值
;-===========================annotation--begin===================================================

@rep2BP.in
device,decomposed=1

;输出路径
outDir = MakeDir('../Image/test_SmoothCmp/') 

ratioPeak = fltarr(70)
ratioBegin = fltarr(70)

for j=1,70 do begin
    areaNum = IToA(j)
    ;输入路径
    hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
      
    ;恢复sav中存放的数据(曲线数据)
    hmiBPGetBoxSavData,hmiInboxDir+'*.sav',arrTime=arrTime,Intensity=Intensity
    
    ;只截取有用部分
    arrTime = rep2BPStrmidTime(arrTime)
    
    bpBgAndEdTime = rep2BPGetOrigBgAndEdTime(areaNum)
    ;把时间格式修改一下
    bpBgAndEdTime[0] = rep2BPFormatTime(bpBgAndEdTime[0])
    
    ;对强度作半小时平滑
    Intensity = smooth(Intensity,30,/edge_truncate,/nan) ;因为1min平均过
    ;找到此时最大值
    smPeak = max(Intensity)
    
    ;找到此时手选开始位置的强度值
    smBegin = Intensity[WhereEx(bpBgAndEdTime[0] eq arrTime)]
    
    ;平均开始时刻4小时前到1小时前的数据
    bgTimeIndex = WhereEx(bpBgAndEdTime[0] eq arrTime)
    if ((bgTimeIndex-240) ge 0) then begin
        mean3h = Means(Intensity[bgTimeIndex-240 : bgTimeIndex-60]) ;因为1min平均过       
    endif $
    else begin
        mean3h = Means(Intensity[0 : bgTimeIndex-60]) ;因为1min平均过
    endelse
    
    ;作比值
    ratioPeak[j-1] = mean3h / smPeak
    ratioBegin[j-1] = mean3h / smBegin
    
    ;画图
    window,0,xsize=1200,ysize=600,retain=2
    utplot,arrTime,Intensity,/xstyle,/ystyle,/noerase,position=[0.1,0.1,0.9,0.9],yticklen=0.01,title=areaNum
    outplot,[bpBgAndEdTime[0],bpBgAndEdTime[0]],[min(Intensity),max(Intensity)],color=GetColour('Yellow')
    if ((bgTimeIndex-240) ge 0) then begin
        outplot,[arrTime[bgTimeIndex-240],arrTime[bgTimeIndex-240]],[min(Intensity),max(Intensity)],color=GetColour('Blue')
    endif $
    else begin
        outplot,[arrTime[0],arrTime[0]],[min(Intensity),max(Intensity)],color=GetColour('Blue')
    endelse
    outplot,[arrTime[bgTimeIndex-60],arrTime[bgTimeIndex-60]],[min(Intensity),max(Intensity)],color=GetColour('Blue')
    write_png,outDir+areaNum+'.png',tvrd(true=1)
endfor    

;画散点图    
window,1,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,ratioPeak,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1
write_png,outDir+'ratioPeak.png',tvrd(true=1)
 
window,2,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,ratioBegin,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1
write_png,outDir+'ratioBegin.png',tvrd(true=1)    
Over
END
