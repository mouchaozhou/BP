;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    为模型的第三个例子做jet在335和94的动画
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
@papBP.in

;waveLen = '335'
waveLen = '94'
areaNum = '22'

;创建aia和hmi对象
oAiaData = obj_new('AIA',fix(waveLen))  ;第二项是波长信息

;输入路径和输入文件
aiaDir = '/data1/moucz/AIA_BP/Data/' + date + '/' + waveLen + '/'
aiaFile = aiaFileHead + '*.fits'

;定义输出路径
imgDir = MakeDir('../Image/ImgForMovie/' + date + '/' + wavelen + '/' + areaNum + '/') ;画出位置（画圆）

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaDir,inputFile=aiaFile,outputDir=imgDir  

;搜索文件 
oAiaData->FileSearch 

;获得找到后的文件个数
oAiaData->GetProperty,fileArr=aiaFileArr,nFiles=nAia

;画图参数
device,decomposed=0
xsize = 700
ysize = xsize
;oAiaData->SetProperty,position=[0.1,0.1,0.9,0.9],threshold=[-15.,0]  ;335
oAiaData->SetProperty,position=[0.1,0.1,0.9,0.9],threshold=[-7,0.]  ;94

;test begin;
  ;nAia = 1
;endtest;

for i=0,nAia-1 do begin
    ;读入aia的数据                                    
    oAiaData->ReadData,i,/prep
    oAiaData->Index2Map
  
    if (i eq 0) then begin
        ;获得AIA的参考数据  
        oAiaData->GetDRotRefPar,/subMap,cropPar=[322,382,-110,-50]
    endif
    

    ;太阳自传消除并截取相同区域
    oAiaData->DRotate
    ;消除曝光时间的影响 
    ;oAiaData->DExprTime   
    ;图像反转 
    oAiaData->ImageNegatives,/map  
    
    window,1,xsize=xsize,ysize=ysize,retain=2
    
    oAiaData->PlotMap
    oAiaData->SavImage,description='_'+strcompress(i)+'_'
endfor

;制作GIF动画
Say,'Making movie...'
oAiaData->SetProperty,inputDir=imgDir,inputFile='*.png',outputDir=imgDir
oAiaData->MakeMovie,gifName=waveLen+'_'+areaNum+'_mov.gif'

;销毁对象
obj_destroy,oAiaData 
Over
END
