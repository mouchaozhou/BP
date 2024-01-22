;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    看看有没有四极场结构，验证模型所做的普通图
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;Pro main
@hmiBP.in

;创建aia和hmi对象
oAiaData = obj_new('AIA',fix(waveLen))  ;第二项是波长信息
oHmiData = obj_new('HMI')

;输入路径和输入文件
aiaDir = '/data1/moucz/AIA_BP/Data/' + date + '/' + waveLen + '/'
hmiDir = '/data1/moucz/HMI_BP/Data/' + date +'/'
hmiFile = hmiFileHead + '*.fits'

;输出路径
aiaSavDir = MakeDir('../../AIA_BP/Save/AfterFindQuadrupole/' + date + '/' + waveLen + '/' + areaNum +'/')
hmiSavDir = MakeDir('../Save/AfterFindQuadrupole/' + date + '/' + waveLen + '/' + areaNum +'/')
bothFigDir = MakeDir('../Figure/FindQuadrupole/'+ date + '/' + waveLen + '/' + areaNum + '/')

;直接制作动画
goto,make_movie

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaDir,outputDir=bothFigDir  
oHmiData->SetProperty,inputDir=hmiDir,inputFile=hmiFile,outputDir=hmiFigDir

;搜索文件 
oHmiData->FileSearch 

;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr,nFiles=nHmi

;得到事件的起始和结束文件编号
hmiGetEvtNum,date,areaNum,beginNum=beginNum,refNum=refNum,endNum=endNum

;/********** 读入校准用的参考数据 **********/
oHmiData->ReadData,refNum,/prep
oHmiData->Index2Map

;扩展区域
cropPar = aiaCropPar(date,areaNum)
ds = 20;角秒  上下左右各扩张20角秒
cropPar[0] -= ds
cropPar[1] += ds
cropPar[2] -= ds
cropPar[3] += ds

;获得hmi的参考数据
oHmiData->GetDRotRefPar,/subMap,cropPar=cropPar

;查找对应的aia数据
;或得hmi文件的中的时间
oHmiData->GetFnamTime,hmiFileHead,i=refNum,Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
;得到aia文件名
aiaFile = strcompress(aiaFileHead + Year + aiaymdChar + Month + aiaymdChar + Day + aiaconnChar + $
                      Hour + aiahmsChar + Minute + '*.fits',/remove_all)  ;获取AIA文件中的小时和分钟传递给HMI用来读取数据
;搜索aia文件                                           
oAiaData->SetProperty,inputFile=aiaFile
oAiaData->FileSearch  
;获得aia的参考数据                                    
oAiaData->ReadData,0,/prep
oAiaData->Index2Map
;获得AIA的参考数据  
oAiaData->GetDRotRefPar,/subMap,cropPar=cropPar

;画图参数
device,decomposed=0
xsize = 700
ysize = xsize

;设置画图参数
oAiaData->SetProperty,threshold=aiaThreshold,barPosition=barPosition,barColor=barColor,charsize=charsize
oHmiData->SetProperty,threshold=hmiThreshold,barPosition=barPosition,barColor=barColor,charsize=charsize

;test begin;
  ;endNum = beginNum
;endtest;
for i=beginNum,endNum do begin
    ;Error handler
    catch,error_status
    if (error_status ne 0) then begin
        continue
    endif 
      
    ;获得HMI的数据
    oHmiData->ReadData,i,/prep
    oHmiData->Index2Map
    ;太阳自传消除并截取相同区域   
    oHmiData->DRotate
    ;得到对应的map数据
    oHmiData->GetProperty,map=hmiMap   
       
    ;从Hmi挑出与Aia符合的图
    oHmiData->GetFnamTime,HmiFileHead,i=i,Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
    aiaFile = strcompress(aiaFileHead + Year + aiaymdChar + Month + aiaymdChar + Day + aiaconnChar + $
                          Hour + aiahmsChar + Minute + '*.fits',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据
                                  
    ;搜索aia数据
    oAiaData->SetProperty,inputFile=aiaFile
    oAiaData->FileSearch 
    oAiaData->GetProperty,nFiles=nAia,fileArr=aiaFileArr
    
    ;test begin; 
      nAia = 1  ;1min一幅图吧
    ;endtest;
    
    for j=0,nAia-1 do begin
        ;读入aia的Map数据  
        oAiaData->ReadData,j,/prep
        oAiaData->Index2Map
        ;太阳自传消除并截取相同区域
        oAiaData->DRotate
        ;得到对应的map数据
        oAiaData->GetProperty,map=aiaMap
        
          
        ;/********** Aia和Hmi画在一幅图中  **********/  
        window,9,xsize=2*xsize,ysize=ysize,retain=2              
        oAiaData->Lct,waveLen=1600  ;导入色表
        oAiaData->PlotMap,position=[0.025,0.05,0.475,0.95],/noerase
        
        loadct,0  ;清空色表，画磁场图
        oHmiData->PlotMap,position=[0.525,0.05,0.975,0.95],/noerase
        
        ;存储图片
        oAiaData->SavImage,description='__'+file_basename(hmiFileArr[i])+'_'+strcompress(i)+'_'+strcompress(j)+'_'
           
        ;存储aia的数据
        aiaSavFile = oAiaData->GetOutFnam(description='_AiaMap_',ext='sav')
        save,aiaMap,filename=aiaSavDir+aiaSavFile
        aiaFitsFile = oAiaData->GetOutFnam(description='_AiaData_',ext='fits')
        writefits,aiaSavDir+aiaFitsFile,aiaMap.data     
    endfor
    
    ;存储hmi的数据
    hmiSavFile = oHmiData->GetOutFnam(description='_HmiMap_',ext='sav')
    save,hmiMap,filename=hmiSavDir+hmiSavFile
    hmiFitsFile = oHmiData->GetOutFnam(description='_HmiData_',ext='fits')
    writefits,hmiSavDir+hmiFitsFile,hmiMap.data  
endfor

;制作Both的GIF动画
make_movie:
Say,'Making movie...'
oHmiData->SetProperty,inputDir=bothFigDir,outputDir=bothFigDIr,inputFile='*.png'
oHmiData->MakeMovie,gifName=waveLen+'_'+areaNum+'_both.gif',fileIntev=3

;销毁对象
obj_destroy,oAiaData 
obj_destroy,oHmiData
Say,'areaNum: ',areaNum
Over
END