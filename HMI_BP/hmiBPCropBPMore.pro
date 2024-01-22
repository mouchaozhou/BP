;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    截出AIA和HMI上相同的区域并消除太阳自转
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;Pro main
@hmiBP.in

for z=22,70 do begin
    areaNum = IToA(z)
    ;创建aia和hmi对象
    oAiaData = obj_new('AIA',fix(waveLen))  ;第二项是波长信息
    oHmiData = obj_new('HMI')
    
    ;输入路径和输入文件
    aiaDir = '/data1/moucz/AIA_BP/Data/' + date + '/' + waveLen + '/'
    hmiDir = '/data1/moucz/HMI_BP/Data/' + date +'/'
    hmiFile = hmiFileHead + '*.fits'
    
    ;输出路径
    aiaSavDir = MakeDir('../../AIA_BP/Save/AfterCmp/' + date + '/' + waveLen + '/' + areaNum +'/')
    hmiSavDir = MakeDir('../Save/AfterCmp/' + date + '/' + waveLen + '/' + areaNum +'/')
    bothFigDir = MakeDir('../Figure/WithContourOfAia/'+ date + '/' + waveLen + '/' + areaNum + '/')
    
    ;设置搜索文件的相关参数
    oAiaData->SetProperty,inputDir=aiaDir,outputDir=bothFigDir  
    oHmiData->SetProperty,inputDir=hmiDir,inputFile=hmiFile
    
    ;搜索文件 
    oHmiData->FileSearch 
    
    ;获得找到后的文件个数
    oHmiData->GetProperty,fileArr=hmiFileArr,nFiles=nHmi
    
    ;得到事件的起始和结束文件编号
    hmiGetMoreEvtNum,date,areaNum,beginNum=beginNum,refNum=refNum
    endNum = beginNum + 180 ;3个小时之后
    if (endNum gt 5039) then endNum = 5039
    
    ;/********** 读入校准用的参考数据 **********/
    oHmiData->ReadData,refNum,/prep
    oHmiData->Index2Map
    ;获得hmi的参考数据
    oHmiData->GetDRotRefPar,/subMap,cropPar=aiaCropPar(date,areaNum)
    
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
    oAiaData->GetDRotRefPar,/subMap,cropPar=aiaCropPar(date,areaNum)
        
    ;test begin; 
      ;选一个refNum和endNum之间的数
      ;beginNum = 2500 & endNum = beginNum     
    ;endtest;
    
    for i=beginNum,endNum do begin     
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
          ;nAia = 1
        ;endtest;
        
        for j=0,nAia-1 do begin
            ;读入aia的Map数据  
            oAiaData->ReadData,j,/prep
            oAiaData->Index2Map
            ;太阳自传消除并截取相同区域
            oAiaData->DRotate
            ;得到对应的map数据
            oAiaData->GetProperty,map=aiaMap                           
            ;存储aia的数据
            aiaSavFile = oAiaData->GetOutFnam(description='_AiaMap_',ext='sav')
            save,aiaMap,filename=aiaSavDir+aiaSavFile  
        endfor
        
        ;存储hmi的数据
        hmiSavFile = oHmiData->GetOutFnam(description='_HmiMap_',ext='sav')
        save,hmiMap,filename=hmiSavDir+hmiSavFile
        Say,'areaNum: ',areaNum
    endfor
endfor

;销毁对象
obj_destroy,oAiaData 
obj_destroy,oHmiData
Over
END