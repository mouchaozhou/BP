@aiaBP.in

;创建对象
oAiaData = obj_new('AIA',fix(waveLen)) 

;导入aia的色表
oAiaData->Lct,waveLen=1600

;输出路径
figDir = '../Figure/FindBPs/'+ date + '/' + waveLen + '/'

;画图参数
screenSz = get_screen_size()
xsize = screenSz[0];1200 
ysize = screenSz[1];xsize

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaDir,inputFile=aiaFile,outputDir=figDir
;搜索文件 
oAiaData->FileSearch 

;设置画图参数
oAiaData->SetProperty,threshold=aiaThreshold,barPosition=barPosition,barColor=barColor,charsize=charsize, $
                      position=[0,0,screenSz[1]/screenSz[0],1.0]

;已找出的位置
arrNeedArea = aiaGetFindBPsPar(/all)
              
;画图
window,0,xsize=xsize,ysize=ysize,retain=2
oAiaData->ReadData,0,/prep 
oAiaData->Index2Map 
oAiaData->PlotMap

szNeedArea = size(arrNeedArea,/dimensions)

device,decomposed=1
for i=0,szNeedArea[1]-1 do begin
    oAiaData->SetProperty,needArea=arrNeedArea[*,i]
    oAiaData->PlotBox,color=GetColour('Yellow')
    xyouts,arrNeedArea[0,i],arrNeedArea[2,i],IToA(i+1),charsize=2.0,color=GetColour('Yellow')
endfor

oAiaData->SavImage,description='check_area'

;销毁对象
obj_destroy,oAiaData  
Over
END