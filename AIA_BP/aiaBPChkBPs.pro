Function aiaBPGetBPNum,nArea
  case nArea of 
    '1': return,['4','5','6','7','8','9','10','11','12']
    '2': return,['13','14','15','16','17','18','19','20']
    '3': return,['3','21','22','23','24','25','26','27','28','29','30','31','32','33']
    '4': return,['1','2','34','35','36','37','38','39','40','41','42','43','44','45','46','47']
    '5': return,['48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65']
    '6': return,['66','67','68','69','70']
    else: message,'Wrong nArea!'
  endcase 
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO aiaBPGetBPArea,arrNum=arrNum,arrPosCoordPix=arrPosCoordPix,arrBPNum=arrBPNum
  @aiaBP.in
  oAiaTmp = obj_new('AIA',fix(waveLen)) 
  ;设置搜索文件的相关参数
  oAiaTmp->SetProperty,inputDir=aiaDir,inputFile=aiaFile
  ;搜索文件 
  oAiaTmp->FileSearch 
 
  ;获得BP编号
  arrBPNum = aiaBPGetBPNum(nArea)
  arrPosCoordPix = intarr(4,n_elements(arrBPNum)) ;box坐标
  arrNum = intarr(2,n_elements(arrBPNum)) ;refNum 和 endNum
  
  ;读入aia数据
  oAiaTmp->ReadData,0,/prep 
  oAiaTmp->Index2Map
  
  ;获得区域
  cropArea = aiaGetFindBPsPar(nArea=nArea)
  
  ;获取消除太阳自传参数
  oAiaTmp->GetDRotRefPar,/subMap,cropPar=cropArea
  
  for i=0,n_elements(arrBPNum)-1 do begin
      ;得到hmi数据编号
      hmiGetEvtNum,date,arrBPNum[i],refNum=refNum,endNum=endNum
      ;转化为aia数据编号     
      arrNum[0,i] = refNum * 5  ;refNum是hmi的编号，乘以5才是aia的   ;aia 1min 5幅图
      arrNum[1,i] = endNum * 5  ;endNum是hmi的编号，乘以5才是aia的
      ;读入并处理数据
      oAiaTmp->ReadData,arrNum[0,i],/prep  
      oAiaTmp->Index2Map
      oAiaTmp->DRotate
      ;截图获得像素坐标
      oAiaTmp->SetProperty,needArea=aiaCropPar(date,arrBPNum[i])
      oAiaTmp->SubMap,irange=irange  ;转换为像素坐标     
      arrPosCoordPix[*,i] = irange
  endfor 
;销毁对象
obj_destroy,oAiaTmp 
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO aiaBPIfPlotBox,i,oAiaData,refNum,endNum,posCoordPix,BPNum
  if (i ge refNum) && (i le endNum) then begin
      oAiaData->SetProperty,needArea=posCoordPix
      oAiaData->PlotBox,color=255
      xyouts,posCoordPix[0],posCoordPix[2],BPNum,charsize=2.0,color=255
  endif
END
;-----------------------------------------------------------------------------------------------------------------------------

;Pro main
@aiaBP.in

;创建对象
oAiaData = obj_new('AIA',fix(waveLen)) 

;导入aia的色表
oAiaData->Lct,waveLen=1600

;输出路径
figDir = MakeDir('../Figure/CheckBPs/'+ date + '/' + waveLen + '/' + nArea + '/')

;画图参数
xsize = 1000 
ysize = xsize

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaDir,inputFile=aiaFile,outputDir=figDir
;搜索文件 
oAiaData->FileSearch 
;获得找到后的文件个数
oAiaData->GetProperty,nFiles=nAia

;设置画图参数
oAiaData->SetProperty,threshold=aiaThreshold,barPosition=barPosition,barColor=barColor,charsize=charsize,position=position

;读入aia数据
oAiaData->ReadData,0,/prep 
oAiaData->Index2Map

;获得区域
cropArea = aiaGetFindBPsPar(nArea=nArea)

;获取消除太阳自传参数
oAiaData->GetDRotRefPar,/subMap,cropPar=cropArea

;设置画图坐标
oAiaData->SetProperty,position=Area2Pos(cropArea,y1=0.1)

;得到BP所在box的像素坐标
aiaBPGetBPArea,arrNum=arrNum,arrPosCoordPix=arrPosCoordPix,arrBPNum=arrBPNum

tIntv = 10  ;时间间隔 min  
for i=0,nAia-1,5*tIntv do begin ;5幅图1分钟  
    oAiaData->ReadData,i,/prep
    oAiaData->Index2Map
    ;太阳自传消除并截取相同区域
    oAiaData->DRotate
    window,1,xsize=xsize,ysize=ysize,retain=2
    oAiaData->Map2Data
    oAiaData->PlotImage,/onlyData,/colbar,/noerase
    ;画box
    for j=0,n_elements(arrBPNum)-1 do begin
        aiaBPIfPlotBox,i,oAiaData,arrNum[0,j],arrNum[1,j],arrPosCoordPix[*,j],arrBPNum[j]
    endfor  
    oAiaData->PlotMap,/no_data,/noerase 
    oAiaData->SavImage,description=string(i)
endfor

;销毁对象
obj_destroy,oAiaData  
Over
END