;+===========================annotation--begin===================================================
; 找出模型3实例图上time-slice图所需要的区域的坐标
;-===========================annotation--begin===================================================
@papBP.in

;实例选择 1,2,3
nCase = '3'

;创建对象
oAiaData = obj_new('AIA',fix(waveLen))
oHmiData = obj_new('HMI') 

;获得画图实例的相关参数
papBPGetModelPars,nCase,areaNum=areaNum,arrSelTime=arrSelTime,needArea=needArea

;输入路径和输入文件(只画hmi的图，所以只读入hmi处理后数据和曲线数据)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav'
hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;输出路径
tmpFile = '../Temp/papBPGetCoords.tmp'

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile

;搜索文件 
oHmiData->FileSearch

;恢复sav中存放的时间数组
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;设置画图参数(主要是磁场图的)
oAiaData->SetProperty,threshold=papBPGetAiaThresholdModel(nCase),needArea=needArea,position=Area2Pos(needArea,x1=0.1,x2=0.9,y1=0.1),charsize=1.5 

;根据算选事件取出相应的文件index
nSelTime = n_elements(arrSelTime)
fileIndex = intarr(nSelTime)
for i=0,nSelTime-1 do begin
    fileIndex[i] = where(arrSelTime[i] eq arrTime)
endfor 

for i=0,nSelTime-1 do begin
  ;从Hmi挑出与Aia符合的图
  oHmiData->GetFnamTime,hmiFileHead,i=fileIndex[i],Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
  aiaSavFile = strcompress(aiaFileHead + Year + AiaymdChar + Month + AiaymdChar + Day + AiaconnChar + $
                           Hour + AiahmsChar + Minute + '*.sav',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据 
  
  ;搜索aia数据
  oAiaData->SetProperty,inputFile=aiaSavFile
  oAiaData->FileSearch 
  oAiaData->GetProperty,FileArr=aiaFileArr
  
  restore,aiaFileArr[0],/ve   
  
  oAiaData->SetProperty,map=aiaMap
  oAiaData->DExprTime      ;消除曝光时间的影响 ，只处理Map的数据
  
  ;截出黄色方框内的数据
  oAiaData->SubMap,/pixel
  
  ;把map数据给data
  oAiaData->Map2Data
  
  ;图像反转
  oAiaData->ImageNegatives
    
  ;因为都用初始时刻坐标,所以先画图
  window,1,xsize=900,ysize=900,retain=2
  loadct,0
  oAiaData->PlotImage,title=IToA(i)  
  device,decomposed=1
  CursorPoints,file=tmpFile,/info,/round,/draw,/down,/data,psym=2,color=GetColour('Red'), $
               strWFun='printf,lun,IToA(x)+","+IToA(y)+","'
               ;strWFun='printf,lun,IToA(x)+","+IToA(y)+",], $"'
endfor

;销毁对象
obj_destroy,oHmiData 
obj_destroy,oAiaData

Over
END