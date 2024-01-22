;+===========================annotation--begin===================================================
; 将三个时间列表
; 1/eIpeak Ibg 经验 
;-===========================annotation--begin===================================================

@rep2BP.in

;宁静区平均值
meanQR = 14.5193
device,decomposed=1

outDir = MakeDir('../Image/test_TimeList/')

timeListFile = 'timeList.txt'

if (file_test(outDir+timeListFile)) then $
    file_delete,outDir+timeListFile

;创建存储时间的数组
bpBeginTime1e = strarr(70)
bpEndTime1e = strarr(70)
bpBeginTimebc = strarr(70)
bpEndTimebc = strarr(70) 
  
;将原始的起始时刻，结束时刻与峰值时刻的强度比率写入文件
openu,lun,outDir+timeListFile,/get_lun,/append   

for j=1,70 do begin
    areaNum = IToA(j)
    ;输入路径
    hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
      
    ;恢复sav中存放的数据(曲线数据)
    hmiBPGetBoxSavData,hmiInboxDir+'*.sav',arrTime=arrTime,Intensity=Intensity
    
    ;只截取有用部分
    arrTime = rep2BPStrmidTime(arrTime)
    
    ;获得BP手动找到的起始和结束时间
    ;结束时间由于文件名和内部时间差一点，统一用arrTime的最后一个时间
    bpBgAndEdTime = rep2BPGetOrigBgAndEdTime(areaNum)
    ;把时间格式修改一下
    bpBgAndEdTime[0] = rep2BPFormatTime(bpBgAndEdTime[0])
    bpBgAndEdTime[1] = rep2BPFormatTime(bpBgAndEdTime[1])
    
    ;获得BP到达峰值的时间(只截取有用部分)
    bpPeakTime = rep2BPStrmidTime(repBPGetPeakTime(areaNum))
    
    ;获得峰值的强度
    bpPeakIndex = Arr0(WhereEx(bpPeakTime eq arrTime))  ;where函数返回来的是数组，要化为单个数
    bpPeakInty = Intensity[bpPeakIndex]
    
    ;#region 处理1/e
    ;峰值强度的1/e
    bpPeakInty1e = bpPeakInty * (1./!e)
    ;找到与峰值强度的一部分误差小于一定误差的值
    for i=0,n_elements(Intensity)-1 do begin
        if (Intensity[i] le bpPeakInty1e) then begin        
            Push,arrBP1eNum,i         
        endif        
    endfor
    
    if (n_elements(arrBP1eNum) ne 0) then begin
        ;获得1/e算出来的起始结束时间的index
        rep2BPGetBeginAndEndTimeIndex,arrBP1eNum,bpPeakIndex,bgTimeIndex=bgTimeIndex1e,edTimeIndex=edTimeIndex1e
        
        if (bgTimeIndex1e ne -1) then begin
            bpBeginTime1e[j-1] = arrTime[bgTimeIndex1e]
        endif $
        else begin
            bpBeginTime1e[j-1] = 'null'
        endelse
        
        if (edTimeIndex1e ne -1) then begin
            bpEndTime1e[j-1] = arrTime[edTimeIndex1e]
        endif $
        else begin
            bpEndTime1e[j-1] = 'null'
        endelse
    endif $
    else begin
        bpBeginTime1e[j-1] = 'null'
        bpEndTime1e[j-1] = 'null'
    endelse
    ;#endregion
    
    ;#region 处理背景强度
    ;得到Box的坐标
    needArea = hmiGetBoxCoord(areaNum) ;Box的坐标              
    ;背景强度
    bpPeakIntybc = meanQR * ((needArea[1]-needArea[0]+1)*(needArea[3]-needArea[2]+1))
    ;找到与峰值强度的一部分误差小于一定误差的值
    for i=0,n_elements(Intensity)-1 do begin
        if (Intensity[i] le bpPeakIntybc) then begin        
            Push,arrBPbcNum,i
        endif
    endfor
    
    if (n_elements(arrBPbcNum) ne 0) then begin
        ;获得背景算出来的起始结束时间的index
        rep2BPGetBeginAndEndTimeIndex,arrBPbcNum,bpPeakIndex,bgTimeIndex=bgTimeIndexbc,edTimeIndex=edTimeIndexbc
        
        if (bgTimeIndexbc ne -1) then begin
            bpBeginTimebc[j-1] = arrTime[bgTimeIndexbc]
        endif $
        else begin
            bpBeginTimebc[j-1] = 'null'
        endelse
        
        if (edTimeIndexbc ne -1) then begin
            bpEndTimebc[j-1] = arrTime[edTimeIndexbc]
        endif $
        else begin
            bpEndTimebc[j-1] = 'null'
        endelse
    endif $
    else begin
        bpBeginTimebc[j-1] = 'null'
        bpEndTimebc[j-1] = 'null'
    endelse
    ;#endregion
            
    ;写入文件
    printf,lun,bpBeginTime1e[j-1]+'  '+bpBeginTimebc[j-1]+'  '+bpBgAndEdTime[0]+'    ||    '+bpEndTime1e[j-1]+'  '+bpEndTimebc[j-1]+'  '+bpBgAndEdTime[1]
    
    ;画图
    window,0,xsize=1200,ysize=600,retain=2
    utplot,arrTime,Intensity,/xstyle,/ystyle,/noerase,position=[0.1,0.1,0.9,0.9],yticklen=0.01,title=areaNum
    ;肉眼看到的起始位置（结束位置就是图像的结束位置）
    outplot,[bpBgAndEdTime[0],bpBgAndEdTime[0]],[min(Intensity),max(Intensity)],color=GetColour('Red') 
    ;1/e的起始位置 
    if (bpBeginTime1e[j-1] ne 'null') then $        
        outplot,[bpBeginTime1e[j-1],bpBeginTime1e[j-1]],[min(Intensity),max(Intensity)],color=GetColour('Yellow') 
    ;1/e的结束位置
    if (bpEndTime1e[j-1] ne 'null') then $
        outplot,[bpEndTime1e[j-1],bpEndTime1e[j-1]],[min(Intensity),max(Intensity)],color=GetColour('Yellow') 
    ;background的起始位置
    if (bpBeginTimebc[j-1] ne 'null') then $ 
        outplot,[bpBeginTimebc[j-1],bpBeginTimebc[j-1]],[min(Intensity),max(Intensity)],color=GetColour('Blue') 
    ;background的结束位置
    if (bpEndTimebc[j-1] ne 'null') then $
        outplot,[bpEndTimebc[j-1],bpEndTimebc[j-1]],[min(Intensity),max(Intensity)],color=GetColour('Blue') 
    
    write_png,outDir+areaNum+'.png',tvrd(true=1) 
    
    undefine,arrBP1eNum
    undefine,arrBPbcNum    
endfor 


;关闭文件
free_lun,lun
    
Over
END    
    
    
    
     