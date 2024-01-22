;+===========================annotation--begin===================================================
; 将算出的宁静区的平均值与各case的峰值强度进行对比
;-===========================annotation--begin===================================================

@rep2BP.in

device,decomposed=1
;宁静区平均值
meanQR = 14.5193

;输出路径
figDir = MakeDir('../Image/test_CmpQR2Peak/')

ratioFile = 'qr2peak.txt'

if (file_test(figDir+ratioFile)) then $
    file_delete,figDir+ratioFile
    
;将原始的起始时刻，结束时刻与峰值时刻的强度比率写入文件
openu,lun,figDir+ratioFile,/get_lun,/append

ratioQR2Peak = fltarr(70)

;统计大于1和小于1的个数
nLe = 0 
nGe = 0

for i=1,70 do begin
    areaNum = IToA(i)
    ;输入路径
    hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
    
    ;恢复sav中存放的数据(曲线数据)
    hmiBPGetBoxSavData,hmiInboxDir+'*.sav',arrTime=arrTime,Intensity=Intensity,/info
    
    ;获得BP到达峰值的时间(只截取有用部分)
    bpPeakTime = repBPGetPeakTime(areaNum)
    
    ;获得峰值的强度
    bpPeakInty = Intensity[WhereEx(bpPeakTime eq arrTime)]
    
    ;得到Box的坐标
    needArea = hmiGetBoxCoord(areaNum) ;Box的坐标
    
    ;Box中峰值的强度的平均值
    bpMeanPeakInty = bpPeakInty / ((needArea[1]-needArea[0]+1)*(needArea[3]-needArea[2]+1))
    
    ;求出比值放在数组中
    ratioQR2Peak[i-1] = bpMeanPeakInty * 1./!e / meanQR 
    
    if (ratioQR2Peak[i-1] lt 1.) then begin
        nLe++
    endif $ 
    else begin
        nGe++
    endelse
    
    ;写入文件中
    printf,lun,ratioQR2Peak[i-1]    
endfor

;关闭文件
free_lun,lun

;画图
window,0,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,ratioQR2Peak,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1, $
     title='< 1 = ' + IToA(nLe) + '    >= 1 = ' +  IToA(nGe)
oplot,[0,70],[1.,1.],color=GetColour('Yellow')
write_png,figDir+'QR2Peak.png',tvrd(true=1)
    
Over
END    
    
    