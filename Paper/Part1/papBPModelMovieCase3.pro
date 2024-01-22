;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    为模型的第三个例子做部分动画
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;PRO main
@../../HMI_BP/Program/hmiBP.in

choice = 'p'  ;p: pix 选择是画pix还是角秒 

oHmiData = obj_new('HMI')  ;这里搜索hmi的数据是为了获取文件名中的时间信息
oAiaData = obj_new('AIA',fix(waveLen)) 

;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav' 
;为了或得arrTime参数
hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;定义输出路径
if (choice eq 'p') then $
    imgDir = MakeDir('../Image/ModelMovieCase3_pix/' + date + '/' + wavelen + '/' + areaNum + '/') $
else $
    imgDir = MakeDir('../Image/ModelMovieCase3/' + date + '/' + wavelen + '/' + areaNum + '/') ;画出位置（画圆）


;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,outputDir=imgDir
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr,nFiles=nHmi

;恢复sav中存放的数据(曲线数据)
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime

;画动画的时间范围
timeRange = [' 1-Jan-2011 03:08:40.200', $   ;起始时间
             ' 1-Jan-2011 04:13:10.300'  ]   ;结束时间
             
;根据算选事件取出相应的文件index
fileIndex = intarr(2)
for i=0,1 do begin
    fileIndex[i] = WhereEx(timeRange[i] eq arrTime)
endfor    

;设置画图参数
oAiaData->SetProperty,threshold=papBPGetAiaThresholdModel('3'),charsize=2.0,position=[0.1,0.1,0.9,0.9]
xsize = 700
ysize = 700

loadct,0
for i=fileIndex[0],fileIndex[1] do begin              
    ;从Hmi挑出与Aia符合的图
    oHmiData->GetFnamTime,hmiFileHead,i=i,Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
    aiaSavFile = strcompress(aiaFileHead + Year + AiaymdChar + Month + AiaymdChar + Day + AiaconnChar + $
                             Hour + AiahmsChar + Minute + '*.sav',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据
                          
    ;搜索aia数据
    oAiaData->SetProperty,inputFile=aiaSavFile
    oAiaData->FileSearch 
    oAiaData->GetProperty,nFiles=nAia,FileArr=aiaFileArr
    
    for j=0,nAia-1 do begin
        ;读入aia数据
        restore,aiaFileArr[j],/ve 
           
        oAiaData->SetProperty,map=aiaMap
        if (choice eq 'p') then begin
            oAiaData->DExprTime,/data      ;消除曝光时间的影响 
            oAiaData->ImageNegatives       ;图像反转
        endif $
        else begin
            oAiaData->DExprTime            ;消除曝光时间的影响 
            oAiaData->ImageNegatives,/map  ;图像反转
        endelse
        
        ;/********** 画在一幅图中  **********/
        window,1,xsize=xsize,ysize=ysize,retain=2
        if (choice eq 'p') then $
            oAiaData->PlotImage $
        else $
            oAiaData->PlotMap
        
        ;存储图片(读的是谁的就不需要设置谁的)
        oAiaData->SavImage,i=j,description='_'+strcompress(i)+'_'      
    endfor
endfor
  
;制作GIF动画
make_movie:
Say,'Making movie...'
oAiaData->SetProperty,inputDir=imgDir,inputFile='*.png',outputDir=imgDir
oAiaData->MakeMovie,gifName=waveLen+'_'+areaNum+'_mov.gif'
 
;销毁对象
obj_destroy,oHmiData
obj_destroy,oAiaData
Say,'areaNum: ',areaNum
Over
END        