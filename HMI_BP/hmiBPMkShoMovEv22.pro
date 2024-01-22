;+===========================annotation--begin===================================================
; 为22号事件的准备的短动画
;-===========================annotation--begin===================================================
;Pro main
@hmiBP.in

;创建aia和hmi对象
oAiaData = obj_new('AIA',fix(waveLen))  ;第二项是波长信息

;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
aiaSavFile = '*.sav'

mvImgDir = MakeDir('../Figure/mvImgDir/' + date + '/' + wavelen + '/' + areaNum + '/') ;画出位置（画圆）

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,inputFile=aiaSavFile,outputDir=mvImgDir

;搜索文件 
oAiaData->FileSearch 
;获得找到后的文件个数
oAiaData->GetProperty,FileArr=aiaFileArr

;设置画图参数
oAiaData->SetProperty,charsize=1.0,position=[0.1,0.1,0.9,0.9],threshold=[50,150]
oAiaData->Lct

;22号事件的范围
i0 = 4005
i1 = 4055

;test begin;
  ;i1 = i0 + 1
;endtest

for i=i0,i1 do begin 
    ;读入hmi数据
    restore,aiaFileArr[i],/ve
        
    ;设置相应数据        
    oAiaData->SetProperty,map=aiaMap
    oAiaData->DExprTime
    
    ;画aia差分图
    window,1,xsize=500,ysize=500,retain=2 
    oAiaData->PlotMap
    
    ;存储图片(读的是谁的就不需要设置谁的)
    oAiaData->SavImage,description='__'+file_basename(aiaFileArr[i])+'_'+strcompress(i)+'_'
endfor

;制作GIF动画
make_movie:
Say,'Making movie...'
oAiaData->SetProperty,inputDir=mvImgDir,inputFile='*.png',outputDir=mvImgDir
oAiaData->MakeMovie,gifName=waveLen+'_'+areaNum+'_mv.gif'

;销毁对象
obj_destroy,oAiaData
Say,'areaNum: ',areaNum
Over
END