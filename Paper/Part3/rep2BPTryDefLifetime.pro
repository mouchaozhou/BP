;+===========================annotation--begin===================================================
; 用光变曲线的方法定义BP的寿命
; 测试一下峰值最大值的多少比较合适
;-===========================annotation--begin===================================================

@rep2BP.in

mode = 2
;1 : 1/e
;2 : 背景强度

device,decomposed=1

;输出路径
if (mode eq 1) then begin
    figDir = MakeDir('../Image/test_TryDefLifeTime/1e/')
endif $
else if (mode eq 2) then begin
    figDir = MakeDir('../Image/test_TryDefLifeTime/background/') 
    ;宁静区平均值
    meanQR = 14.5193
endif

ratioFile = 'ratio.txt'

if (file_test(figDir+ratioFile)) then $
	  file_delete,figDir+ratioFile

;将原始的起始时刻，结束时刻与峰值时刻的强度比率写入文件
openu,lun,figDir+ratioFile,/get_lun,/append

for j=1,70 do begin
    areaNum = IToA(j)
    ;输入路径
    hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
      
    ;恢复sav中存放的数据(曲线数据)
    hmiBPGetBoxSavData,hmiInboxDir+'*.sav',arrTime=arrTime,Intensity=Intensity,/info
    
    ;只截取有用部分
    arrTime = rep2BPStrmidTime(arrTime)
    
    ;获得BP手动找到的起始和结束时间
    ;结束时间由于文件名和内部时间差一点，统一用arrTime的最后一个时间
    bpBgAndEdTime = rep2BPGetOrigBgAndEdTime(areaNum)
    ;把时间格式修改一下
    bpBgAndEdTime[0] = rep2BPFormatTime(bpBgAndEdTime[0])
    
    ;获得BP到达峰值的时间(只截取有用部分)
    bpPeakTime = rep2BPStrmidTime(repBPGetPeakTime(areaNum))
    
    ;获得峰值的强度
    bpPeakInty = Intensity[WhereEx(bpPeakTime eq arrTime)]
    
    if (mode eq 1) then begin
        ;峰值强度的一部分
        bpPeakInty1e = bpPeakInty * (1/!e)
    endif $ 
    else if (mode eq 2) then begin
        ;得到Box的坐标
        needArea = hmiGetBoxCoord(areaNum) ;Box的坐标
                
        ;峰值强度的一部分
        bpPeakInty1e = meanQR * ((needArea[1]-needArea[0]+1)*(needArea[3]-needArea[2]+1)) 
    endif    
    
    ;#test
    ;Dbg,'bpPeakInty',bpPeakInty
    ;Dbg,'bpPeakInty1e',bpPeakInty1e
    ;#endtest
    
    ;用肉眼看出的起始和结束时间 强度与peak强度的比值    
    ratioBg =  IToA(Intensity[WhereEx(bpBgAndEdTime[0] eq arrTime)] / bpPeakInty)
    ratioEd =  IToA(Last(Intensity) / bpPeakInty)
	
	  ;写入文件
	  printf,lun,areaNum+'   ratioBg: '+ratioBg+'    '+'ratioEd: '+ratioEd
    
    ;找到与峰值强度的一部分误差小于一定误差的值
    for i=0,n_elements(Intensity)-1 do begin
        if (Intensity[i] le bpPeakInty1e) then begin        
            Push,arrBPLifetimeInty,Intensity[i]
            Push,arrBPLifetimeNum,i
        endif
    endfor
    
    ;画Sav文件的数据
    window,0,xsize=1200,ysize=600,retain=2
    utplot,arrTime,Intensity,/xstyle,/ystyle,/noerase,position=[0.1,0.1,0.9,0.9],yticklen=0.01, $
           title=areaNum+'  '+'ratioBg: '+ratioBg+'  '+'ratioEd: '+ratioEd
       
    ;用指示线表示所有满足条件的位置
    for i=0,n_elements(arrBPLifetimeInty)-1 do begin
        outplot,[arrTime[arrBPLifetimeNum[i]],arrTime[arrBPLifetimeNum[i]]], $
                [min(Intensity),arrBPLifetimeInty[i]],color=GetColour('Yellow')
    endfor  
   
    ;画出原来用肉眼看出的起始和结束时间 
    outplot,[bpBgAndEdTime[0],bpBgAndEdTime[0]],[min(Intensity),max(Intensity)],color=GetColour('Blue')
    outplot,[Last(arrTime),Last(arrTime)],[min(Intensity),max(Intensity)],color=GetColour('Blue')
    
    undefine,arrBPLifetimeInty
    undefine,arrBPLifetimeNum  
    
    write_png,figDir+areaNum+'.png',tvrd(true=1)    
endfor 

;关闭文件
free_lun,lun
    
Over
END