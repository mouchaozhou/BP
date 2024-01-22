;+===========================annotation--begin===================================================
; 获得空间分辨率
;-===========================annotation--begin===================================================
@papBP.in

;创建aia和hmi对象
oAiaData = obj_new('AIA',fix(waveLen))  ;第二项是波长信息
oHmiData = obj_new('HMI') 

;输入路径和输入文件
aiaDir = '/data1/moucz/AIA_BP/Data/' + date + '/' + waveLen + '/'
aiaFile = aiaFileHead + '*.fits'
hmiDir = '/data1/moucz/HMI_BP/Data/' + date +'/'
hmiFile = hmiFileHead + '*.fits'

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaDir,inputFile=aiaFile  
oHmiData->SetProperty,inputDir=hmiDir,inputFile=hmiFile

;搜索文件 
oAiaData->FileSearch
oHmiData->FileSearch

;读入数据
oAiaData->ReadData,0,/prep
oHmiData->ReadData,0,/prep

;得到index
oAiaData->GetProperty,index=aiaIndex
oHmiData->GetProperty,index=hmiIndex

;输出空间分辨率
print,'Spatial resolution of aia is ',aiaIndex.CDELT1
print,'Spatial resolution of hmi is ',hmiIndex.CDELT1

;销毁对象
obj_destroy,oAiaData 
obj_destroy,oHmiData
Over
END