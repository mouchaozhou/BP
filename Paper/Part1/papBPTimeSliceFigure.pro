;+===========================annotation--begin===================================================
; 画模型分析例3的jet的time-slice图
;-===========================annotation--begin===================================================

@papBP.in

;实例选择 3
nCase = '3'

defsysv,'!ps_y',10 ;待定
defsysv,'!ps_x',50

;打开PS
set_plot,'PS'

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
figDir = '../Document/Figure/'
figFile = 'papBPTimeSlice_' + nCase + '_.eps'
device,filename=figDir+figFile,xsize=!ps_x,ysize=!ps_y,bits=8,/color,/encapsul  ;A4纸 ： 21cm × 29.7cm

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile

;搜索文件 
oHmiData->FileSearch

;恢复sav中存放的数据(曲线数据)，这里主要是时间序列
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;根据算选事件取出相应的文件index范围
tsTimeRange = [' 1-Jan-2011 03:28:10.200', $   ;起始时间
               ' 1-Jan-2011 03:53:40.300'  ]   ;结束时间
indexRange = [where(tsTimeRange[0] eq arrTime), where(tsTimeRange[1] eq arrTime)]

;设置要截取的区域
oAiaData->SetProperty,needArea=[65,95,45,55]  ;pix [x0,x1,y0,y1]

k = 0  ;索引数组用的
index0 = 0 ;存储时使用的索引
for i=indexRange[0]-1,indexRange[1] do begin
    ;从Hmi挑出与Aia符合的图
    oHmiData->GetFnamTime,hmiFileHead,i=i,Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
    aiaSavFile = strcompress(aiaFileHead + Year + AiaymdChar + Month + AiaymdChar + Day + AiaconnChar + $
                             Hour + AiahmsChar + Minute + '*.sav',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据 
    
    ;搜索aia数据
    oAiaData->SetProperty,inputFile=aiaSavFile
    oAiaData->FileSearch 
    oAiaData->GetProperty,nFiles=nAia,FileArr=aiaFileArr
    
    ;创建time-slice图像数组
    if (i eq (indexRange[0]-1)) then begin
        restore,aiaFileArr[0],/ve
        oAiaData->SetProperty,map=aiaMap
        oAiaData->SubMap,/pixel
        oAiaData->GetProperty,map=aiaSliceMap
        szAiaSliceData = size(aiaSliceMap.data,/dimensions)  ;[x, y]
        timeSliceImg = fltarr((indexRange[1]-indexRange[0]+1)*nAia*szAiaSliceData[1],szAiaSliceData[0])  ;数据x大小作为第二维
        continue
    endif
    
    for j=0,nAia-1 do begin
        ;读入aia数据
        restore,aiaFileArr[j],/ve        
        oAiaData->SetProperty,map=aiaMap
        
        ;消除曝光时间的影响 ，只处理Map的数据
        oAiaData->DExprTime      
        
        ;截取指定区域，用来做time-slice图
        oAiaData->SubMap,/pixel
        
        ;把map数据给data
        oAiaData->Map2Data
        
        ;图像反转
        oAiaData->ImageNegatives
        
        ;取出数据
        oAiaData->GetProperty,data=aiaSliceData
        
        ;储存slice数据      
        timeSliceImg[index0:index0+szAiaSliceData[1]-1,*] = reverse(transpose(aiaSliceData))   ;Reverse the columns      
        index0 += szAiaSliceData[1]
    endfor    
    
    k++                                                                      
endfor

;销毁对象
obj_destroy,oHmiData 

;作图
;设置画图参数和取得数据
oAiaData->SetProperty,threshold=[-180,-50],position=[0.1,0.1,0.9,0.9]
oAiaData->SetProperty,data=timeSliceImg
;画time-slice图
oAiaData->PlotTimeSlice,arrTime,timeRange=tsTimeRange

;销毁对象
obj_destroy,oAiaData

;关闭PS
device,/close_file
set_plot,'x'

Over
END       