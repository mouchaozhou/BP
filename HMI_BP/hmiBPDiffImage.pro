;+===========================annotation--begin===================================================
; 做差分图
;-===========================annotation--begin===================================================
;Pro main
@hmiBP.in

;创建aia和hmi对象
oAiaData = obj_new('AIA',fix(waveLen))  ;第二项是波长信息

;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
aiaSavFile = '*.sav'

;定义输出路径
aiaOutSavDir = MakeDir('../Save/AfterDiff/' + date + '/' + waveLen + '/' + areaNum +'/')
diffImgDir = MakeDir('../Figure/DiffImage/' + date + '/' + wavelen + '/' + areaNum + '/') ;画出位置（画圆）

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,inputFile=aiaSavFile,outputDir=diffImgDir

;搜索文件 
oAiaData->FileSearch 
;获得找到后的文件个数
oAiaData->GetProperty,nFiles=nAia,FileArr=aiaFileArr

;设置画图参数
needArea = hmiGetBoxCoord(areaNum) ;Box的坐标
oAiaData->SetProperty,charsize=1.0,needArea=needArea,position=[0.1,0.1,0.9,0.9],threshold=[-50,50]

i0 = 3220  ;22
;test begin;
  nAia = i0+2
;endtest

for i=i0,nAia-2 do begin 
    ;读入hmi数据
    restore,aiaFileArr[i],/ve
    aiaMapPre = aiaMap
    restore,aiaFileArr[i+1],/ve
    
    ;做差分
    aiaMapPre.data = aiaMap.data - aiaMapPre.data 
    aiaMapPre.data = smooth(aiaMapPre.data,3,/edge_truncate)  
    
    ;设置相应数据        
    oAiaData->SetProperty,map=aiaMapPre,data=aiaMapPre.data
    oAiaData->DExprTime
    
    ;画aia差分图
    window,1,xsize=1000,ysize=1000,retain=2
    device,decomposed=0
    oAiaData->PlotImage,/onlyData,/noerase
    device,decomposed=1
    ;画Box
    oAiaData->PlotBox,color=GetColour('Yellow')
    ;画角秒坐标轴        
    oAiaData->PlotMap,/no_data,/noerase
    
    ;存储图片(读的是谁的就不需要设置谁的)
    oAiaData->SavImage,description='__'+file_basename(aiaFileArr[i])+'_'+strcompress(i)+'_'
    ;存储数据
    aiaSavFile = oAiaData->GetOutFnam(description='_AiaMapDiff_',ext='sav')
    save,aiaMapPre,filename=aiaOutSavDir+aiaSavFile
endfor

;制作GIF动画
make_movie:
Say,'Making movie...'
oAiaData->SetProperty,inputDir=diffImgDir,inputFile='*.png',outputDir=diffImgDir
oAiaData->MakeMovie,gifName=waveLen+'_'+areaNum+'_diff.gif',fileIntev=5

;销毁对象
obj_destroy,oAiaData
Say,'areaNum: ',areaNum
Over
END