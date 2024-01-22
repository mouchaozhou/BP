;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    获得每个亮点的一块背景区域
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

@rep2BP.in

oAiaData = obj_new('AIA',fix(waveLen)) 
;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
aiaSavFile = '*.sav'

hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;定义输出路径
imgDir = MakeDir('../Image/test_GetBackground/' + date + '/' + wavelen + '/' + areaNum + '/') 

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,inputFile=aiaSavFile,outputDir=imgDir
oAiaData->FileSearch 
oAiaData->GetProperty,FileArr=aiaFileArr

;恢复sav中存放的数据
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime,Intensity=Intensity

;只截取有用部分
arrTime = rep2BPStrmidTime(arrTime)

;获得BP手动找到的起始和结束时间
;结束时间由于文件名和内部时间差一点，统一用arrTime的最后一个时间
bpBgAndEdTime = rep2BPGetOrigBgAndEdTime(areaNum)
;把时间格式修改一下
bpBgAndEdTime[0] = rep2BPFormatTime(bpBgAndEdTime[0])
;获得Index
bgTimeIndex = WhereEx(bpBgAndEdTime[0] eq arrTime)

;恢复手动选择了起始时刻的数据
restore,aiaFileArr[5*bgTimeIndex],/ve
oAiaData->SetProperty,map=aiaMap,data=aiaMap.data

;作图，截取宁静区
device,decomposed=0
window,0,xsize=1000,ysize=1000,retain=2
;导入aia的色表
oAiaData->Lct,waveLen=1600
oAiaData->SetProperty,iFile=5*bgTimeIndex,threshold=aiaGetThreshold(waveLen),charsize=1.0,position=[0.1,0.1,0.9,0.9]
oAiaData->PlotImage

;原box坐标
boxArea = hmiGetBoxCoord(areaNum)
oAiaData->SetProperty,needArea=boxArea ;Box的坐标
device,decomposed=1
oAiaData->PlotBox,color=GetColour('Yellow')

;消除曝光时间的影响,很重要
oAiaData->DExprTime  
oAiaData->Map2Data

;手动截取一块区域 
print,'请截取一块区域...'
cropArea = CursorCrop(/data,/info)  ;用鼠标截取一块区域

;画出刚取出的区域
oAiaData->SetProperty,needArea=cropArea
oAiaData->PlotBox,color=GetColour('Blue')
oAiaData->GetProperty,data=aiaData

;获得宁静区的平均值
quietRegionVal = Means(aiaData[cropArea[0]:cropArea[1],cropArea[2]:cropArea[3]])
Say,'quietRegionVal: ',quietRegionVal

print,'宁静区的平均值为： ',quietRegionVal

;存储图像    
oAiaData->SavImage

;计算手取起始位置的平均强度
bgTimeVal = Intensity[bgTimeIndex] / ((boxArea[1]-boxArea[0]+1)*(boxArea[3]-boxArea[2]+1))
;计算手取结束位置的平均强度
edTimeVal = Last(Intensity) / ((boxArea[1]-boxArea[0]+1)*(boxArea[3]-boxArea[2]+1))

;计算手取起始位置的平均强度与宁静区的平均值的比值
ratioBg = bgTimeVal / quietRegionVal
Say,'ratioBg: ',ratioBg
;计算手取结束位置的平均强度与宁静区的平均值的比值
ratioEd = edTimeVal / quietRegionVal
Say,'ratioEd: ',ratioEd

;存储数据
save,bgTimeVal,edTimeVal,quietRegionVal,ratioBg,ratioEd,cropArea,filename=imgDir+areaNum+'-'+wavelen+'_ratioBg_raitoEd.sav'

obj_destroy,oAiaData
Say,'areaNum: ',areaNum
Over
END




