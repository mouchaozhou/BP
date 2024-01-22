;+===========================annotation--begin===================================================
; 计算Format磁场分开的距离
;-===========================annotation--begin===================================================

@papBP.in

;实例选择 1-2
nCase = '3'

;创建对象
oHmiData = obj_new('HMI') 

;获得画图实例的相关参数
papBPGetCasePars,nCase,areaNum=areaNum,arrSelTime=arrSelTime,newArea=needArea

;输入路径和输入文件
hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav' 
;为了或得arrTime参数
hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;输出路径
outDir = '../Temp/'

;设置搜索文件的相关参数
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=outDir

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr

;恢复sav中存放的数据(曲线数据)
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;根据算选事件取出相应的文件index
nSelTime = n_elements(arrSelTime)
fileIndex = intarr(nSelTime)
for i=0,nSelTime-1 do begin
    fileIndex[i] = where(arrSelTime[i] eq arrTime)
endfor 

;设置画图参数
oHmiData->SetProperty,threshold=hmiThreshold,charsize=1.0,needArea=needArea,position=[0.1,0.1,0.9,0.9] 
device,decomposed=1

;获得需要计算距离几幅图的index
arrIdx = papBPGetCalMagDisNum(nCase)

;定义contour值大小
magContVal = 30;(Gs)

for j=0,n_elements(arrIdx)-1 do begin
    i = arrIdx[j]
    outFile = 'papCalMagDis_' + nCase + ' ' + IToA(i) + '_.txt'
        
    restore,hmiFileArr[fileIndex[i]],/ve 
    
    ;设置相应数据        
    oHmiData->SetProperty,map=hmiMap
    
    ;截出黄色方框内的数据
    oHmiData->SubMap,/pixel
    
    ;画图
    window,1,xsize=900,ysize=900,retain=2
    
    ;#region 作30Gs的Contour
    oHmiData->Map2Data
    ;只画图
    oHmiData->PlotImage,/onlyData
    oHmiData->Data2Contour,polarity='pos'
    oHmiData->Contour,levels=[magContVal],color=GetColour('Blue')
    oHmiData->Data2Contour,polarity='neg'
    oHmiData->Contour,levels=[-magContVal],color=GetColour('Yellow')
    ;画坐标轴
    oHmiData->PlotMap,/no_data,/noerase
    ;#endregion
    
    CursorPoints,file=outDir+outFile,/info,/draw,/down,/data,psym=2,color=GetColour('Red'), $
                 strWFun='printf,lun,IToA(x)+" "+IToA(y)'
    ;存储图片             
    oHmiData->SavImage,description='__'+file_basename(hmiFileArr[fileIndex[i]])+'_'+strcompress(i)+'_'             
                 
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
endfor

;销毁对象
obj_destroy,oHmiData 

Over
END               