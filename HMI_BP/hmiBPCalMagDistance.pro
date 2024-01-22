;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    测量BP刚开始出现时和AIA达到峰值时两个主极性的距离
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;PRO main
@hmiBP.in

;创建对象
oHmiData = obj_new('HMI') 

;输入路径和输入文件(hmiBPGetBoxPhys)
hmiSavDir = '../Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav' 
hmiInboxDir = '../Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;输出路径
outDir = MakeDir('../Save/CalMagDistance/' + date + '/' + wavelen + '/' + areaNum + '/')
imgDir = MakeDir('../Figure/CalMagDistance/' + date + '/' + wavelen + '/' + areaNum + '/')

;设置搜索文件的相关参数
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=imgDir

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr

;恢复sav中存放的数据(曲线数据)
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;获得画图实例的相关参数
arrSelTime = hmiBPGetBeginTime(areaNum)

;根据算选事件取出相应的文件index
nSelTime = n_elements(arrSelTime)
fileIndex = intarr(nSelTime)
for i=0,nSelTime-1 do begin
    if(arrSelTime[i] eq '0') then $   ;从肉眼判断出来磁场间距离为0，即磁场挨在一起
       fileIndex[i] = 'NULL'  $ ;标记一下
    else $
       fileIndex[i] = WhereEx(arrSelTime[i] eq arrTime)
endfor 

;设置画图参数
oHmiData->SetProperty,threshold=hmiThreshold,charsize=1.0

for i=0,nSelTime-1 do begin
    if (fileIndex[i] ne 'NULL') then begin   ;如果等于NULL则不需要计算距离，距离为0
        ;输出文件
        outFile = 'papCalMagDis_' + areaNum + '_' + IToA(i) + '_.txt'
        ;恢复数据
        restore,hmiFileArr[fileIndex[i]],/ve
        ;设置相应数据        
        oHmiData->SetProperty,map=hmiMap  
        ;画图
        window,1,xsize=900,ysize=900,retain=2
        loadct,0
        oHmiData->PlotMap,position=[0.1,0.1,0.9,0.9]
        tvlct,255,0,0,1
        CursorPoints,file=outDir+outFile,/info,/draw,/down,/data,psym=2,color=1, $
                     strWFun='printf,lun,IToA(x)+" "+IToA(y)+" "'
        ;存储图片             
        oHmiData->SavImage,description='__'+file_basename(hmiFileArr[fileIndex[i]])+'_'+areaNum+'_'+ IToA(i)+'_'             
                     
        ;读入距离
        arrPoints = dblarr(2,2)
        openr,lun,outDir+outFile,/get_lun
        readf,lun,arrPoints
        free_lun,lun
        
        ;计算距离
        distance = sqrt((arrPoints[0,1]-arrPoints[0,0])^2 + (arrPoints[1,1]-arrPoints[1,0])^2)
        Say,distance  
        
        ;写回文件 
        openu,lun,outDir+outFile,/get_lun,/append
        printf,lun,distance
        free_lun,lun
    endif
endfor

;销毁对象
obj_destroy,oHmiData 

Say,'areaNum: ',areaNum
Over
END 