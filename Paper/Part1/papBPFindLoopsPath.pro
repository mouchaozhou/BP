;+===========================annotation--begin===================================================
; 描出模型1的Loop
;-===========================annotation--begin===================================================

@papBP.in

;实例选择 1-2
nCase = '1'

;创建对象
oHmiData = obj_new('HMI') 
oAiaData = obj_new('AIA',fix(waveLen))

;获得画图实例的相关参数
papBPGetModelPars,nCase,areaNum=areaNum,arrSelTime=arrSelTime,needArea=needArea

;输入路径和输入文件
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav' 
;为了或得arrTime参数
hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;输出路径
outDir = MakeDir('../Save/LoopCoords/' + date + '/' + wavelen + '/' + areaNum + '/')

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,outputDir=outDir
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr

;恢复sav中存放的数据(曲线数据)
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;根据算选事件取出相应的文件index
nSelTime = n_elements(arrSelTime) / 2
fileIndex = intarr(nSelTime)
for i=0,nSelTime-1 do begin
    fileIndex[i] = where(arrSelTime[i] eq arrTime)
endfor 

oAiaData->SetProperty,threshold=papBPGetAiaThresholdModel(nCase),needArea=needArea

for i=0,nSelTime-1 do begin
    oHmiData->GetFnamTime,hmiFileHead,i=fileIndex[i],Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
    aiaSavFile = strcompress(aiaFileHead + Year + AiaymdChar + Month + AiaymdChar + Day + AiaconnChar + $
                             Hour + AiahmsChar + Minute + '*.sav',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据
                          
    ;搜索aia数据
    oAiaData->SetProperty,inputFile=aiaSavFile
    oAiaData->FileSearch 
    oAiaData->GetProperty,FileArr=aiaFileArr
    
    ;读入aia数据
    restore,aiaFileArr[0],/ve 
      
    oAiaData->SetProperty,map=aiaMap
    oAiaData->DExprTime  ;消除曝光时间的影响 ，只处理Map的数据
    
    ;截出黄色方框内的数据
    oAiaData->SubMap,/pixel
        
    ;把map数据给data
    oAiaData->Map2Data  ;不加这句处理曝光时间后的数据只是map数据，不是data数据
    
    ;图像反转
    oAiaData->ImageNegatives
    
    ;画图
    window,1,xsize=500,ysize=500,retain=2
    loadct,0
    oAiaData->PlotImage,/noerase,position=[0.1,0.1,0.9,0.9]
    
    ;loop坐标文件
    outFile = 'LoopCoords' + nCase + '_' + IToA(i) + '_.txt'
    
    ;删除旧的
    file_delete,outDir+outFile,/allow_nonexistent
    
    ;打开文件准备存储相应坐标
    openu,lun,outDir+outFile,/get_lun,/append
    ;鼠标取点
    tvlct,255,255,0,1  ;Yellow 
    Say,'请截取一块区域...'
    while (!mouse.button ne 4) do begin      
          cursor,x,y,/data,/down            ;像素坐标 
          plots,x,y,/data,psym=2,color=1    
          printf,lun,x,y 
    endwhile
    ;!mouse.button重置
    !mouse.button = 0
    free_lun,lun 
    
    ;存储图片             
    oAiaData->SavImage,description='__'+file_basename(aiaFileArr[0])+'_'+strcompress(i)+'_' 
    
    yes_no,'觉得区域满意就按y继续，否则按回车或n中断程序',answer,'n'  ;最后一个是按回车的默认选项
    if (answer eq 0) then $
        i--
endfor  

;销毁对象
obj_destroy,oHmiData 
obj_destroy,oAiaData

Over
END  