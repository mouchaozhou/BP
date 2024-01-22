;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose: 
;    比较日冕亮点环顶和环底的光变曲线，看看点亮顺序
;    step 3 : 做环足点（2个）和环顶点(1个)的光变曲线并对比
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;Pro main
@hmiBP.in

oAiaData = obj_new('AIA',fix(waveLen))

;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../Save/LoopData/'  + date + '/' + wavelen + '/' + areaNum + '/'
aiaSavFile = '*.sav'

;定义输出路径
aiaInboxDir = MakeDir('../Figure/LoopLightCurve/' + date + '/' + wavelen + '/' + areaNum + '/') ;存储面积、通量、强度等数据

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,inputFile=aiaSavFile

;搜索hmi文件 
oAiaData->FileSearch
;获得找到后的文件个数
oAiaData->GetProperty,fileArr=aiaFileArr,nFiles=nAia
;时间范围
timeRange = hmiGetLoopTimeRange(areaNum)
;画图位置
pos = [0.05,0.05,0.95,0.95]

;读入aia数据
hmiBPGetLoopSavData,aiaFileArr[0],arrTime=arrTime,arrLpBottomL=arrLpBottomL,arrLpBottomR=arrLpBottomR,arrLpTop=arrLpTop

;画光变曲线  
window,xsize=1500,ysize=800,retain=2
hmiBPLoopPlotCurves,arrTime,arrLpBottomL,arrLpBottomR,arrLpTop,timeRange=timeRange,title='Original',pos=pos

;存储图片
filename =  file_basename(aiaFileArr[0])
oExtLen = strlen(Last(strsplit(filename,'.',/extract))) + 1  ;+1是扩展名的“.”符号   

filenameOriginal = strmid(filename,0,strlen(filename)-oExtLen) + '_Loop_' + areaNum + '.png'
write_png,aiaInboxDir+filenameOriginal,tvrd(true=1)
;-----------------------------------------------------------------------------------------------------------------------------

;归一化
hmiBPGetLoopSavData,aiaFileArr[0],/normal,arrTime=arrTime,arrLpBottomL=arrLpBottomL,arrLpBottomR=arrLpBottomR,arrLpTop=arrLpTop

;画光变曲线
window,xsize=1500,ysize=800,retain=2
hmiBPLoopPlotCurves,arrTime,arrLpBottomL,arrLpBottomR,arrLpTop,timeRange=timeRange,title='Normal',pos=pos
filenameNormal = strmid(filename,0,strlen(filename)-oExtLen) + '_Loop_normal_' + areaNum + '.png'
write_png,aiaInboxDir+filenameNormal,tvrd(true=1)

;销毁对象
obj_destroy,oAiaData

Say,'areaNum: ',areaNum
Over
END