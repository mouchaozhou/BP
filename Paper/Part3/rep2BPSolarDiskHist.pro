;+===========================annotation--begin===================================================
; 做一个全日面图的直方图，仿照论文上的取出可以作为宁静区的部分
;-===========================annotation--begin===================================================

@rep2BP.in

;创建对象
oAiaData = obj_new('AIA',fix(waveLen)) 

;输入路径和输入文件
aiaDir = '/data1/moucz/AIA_BP/Data/' + date + '/' + waveLen + '/'
aiaFile = 'aia.lev1*.fits'

;输出路径
figDir = MakeDir('../Image/test_SolarDiskHist/')

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaDir,inputFile=aiaFile,outputDir=figDir
;搜索文件 
oAiaData->FileSearch 
;设置画图参数
oAiaData->SetProperty,threshold=aiaGetThreshold(waveLen),position=[0.1,0.1,0.9,0.9]
;读入aia数据
oAiaData->ReadData,0,/prep
;获得aia数据
oAiaData->GetProperty,data=aiaData,index=aiaIndex

;获得x和y的网格点
xyMatrix = Meshgrid(dindgen(aiaIndex.NAXIS1)-aiaIndex.CRPIX1,dindgen(aiaIndex.NAXIS2)-aiaIndex.CRPIX2) ;CRPIX1和CRPIX2是太阳中心坐标（像素）

;获得距离数组
dis2Center = sqrt((xyMatrix.x)^2 + (xyMatrix.y)^2)

;创建筛选后数据数组
aiaSunData = aiaData

;小于太阳半径的数据获得
aiaSunData[where(dis2Center ge aiaIndex.R_SUN)] = !VALUES.D_NAN

;设置数据
oAiaData->SetProperty,data=aiaSunData

;画图查看效果
device,decomposed=0
window,0,xsize=1000,ysize=1000,retain=2
oAiaData->Lct,waveLen=1600
oAiaData->PlotImage
write_png,figDir+'SolarDisk.png',tvrd(true=1) 

;消除曝光时间的影响,很重要
oAiaData->Index2Map
oAiaData->DExprTime,/data
oAiaData->GetProperty,data=aiaSunData

;计算标准偏差
sigma = stddev(aiaSunData,/nan)
Say,'sigma: ',sigma

;画直方图（原始版本）
window,0,xsize=1200,ysize=600,retain=2
plot,histogram(aiaSunData,/nan),/xstyle,/ystyle,/ylog,position=[0.1,0.1,0.9,0.9]
oplot,[3.*sigma,3.*sigma],[5.,30000.],linestyle=2
write_png,figDir+'SolarDiskHistOrig.png',tvrd(true=1)
 
;画直方图（加工版本）
window,1,xsize=800,ysize=800,retain=2
plot,histogram(aiaSunData,/nan),xrange=[0,1000],yrange=[1,200000],/xstyle,/ystyle,/ylog,position=[0.1,0.1,0.9,0.9]
oplot,[3.*sigma,3.*sigma],[5.,30000.],linestyle=2
write_png,figDir+'SolarDiskHist.png',tvrd(true=1) 

;宁静区数据
meanQR = Means(aiaSunData[where(aiaSunData le 3*sigma)]) 
Say,'meanQR: ',meanQR  ;14.5193

;销毁对象
obj_destroy,oAiaData
Over
END
