;+===========================annotation--begin===================================================
; 找出实例图上的箭头和圆圈（标出磁场）的坐标
;-===========================annotation--begin===================================================
@papBP.in

;实例选择 1,2,3
nCase = '3'

;创建对象
oHmiData = obj_new('HMI') 

;获得画图实例的相关参数
papBPGetCasePars,nCase,areaNum=areaNum,arrSelTime=arrSelTime,newArea=needArea

;输入路径和输入文件(只画hmi的图，所以只读入hmi处理后数据和曲线数据)
hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav'
hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;输出路径
tmpFile = '../Temp/papBPGetCoords.tmp'

;设置搜索文件的相关参数
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=figDir

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr

;恢复sav中存放的时间数组
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;设置画图参数(主要是磁场图的)
oHmiData->SetProperty,threshold=hmiThreshold,charsize=1.5,needArea=needArea,position=Area2Pos(needArea,x1=0.1,x2=0.9,y1=0.1) 

;根据算选事件取出相应的文件index
nSelTime = n_elements(arrSelTime)
fileIndex = intarr(nSelTime)
for i=0,nSelTime-1 do begin
    fileIndex[i] = where(arrSelTime[i] eq arrTime)
endfor 

for i=0,nSelTime-1 do begin
  ;读入hmi数据
  restore,hmiFileArr[fileIndex[i]],/ve 
       
  ;设置相应数据        
  oHmiData->SetProperty,map=hmiMap
  
  ;截出黄色方框内的数据
  oHmiData->SubMap,/pixel
  
  ;把map数据给data,准备画image
  oHmiData->Map2Data
        
  ;因为都用初始时刻坐标,所以先画图
  window,1,xsize=900,ysize=900,retain=2
  loadct,0
  oHmiData->PlotImage,title=IToA(i)  
  device,decomposed=1
  CursorPoints,file=tmpFile,/info,/round,/draw,/down,/data,psym=2,color=GetColour('Red'), $
               strWFun='printf,lun,IToA(x)+","+IToA(y)+","'
               ;strWFun='printf,lun,IToA(x)+","+IToA(y)+",], $"'
endfor

;销毁对象
obj_destroy,oHmiData 

Over
END