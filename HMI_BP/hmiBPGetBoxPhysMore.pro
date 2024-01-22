;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    获取日冕亮点对应的磁场强度及aia数据光变曲线数据
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;Pro main
@hmiBP.in

for z=11,21 do begin
    areaNum = IToA(z)
    oHmiData = obj_new('HMI') 
    oAiaData = obj_new('AIA',fix(waveLen))  
     
    ;输入路径和输入文件(hmiBPGetBoxPhys)
    aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
    hmiSavDir = '../Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
    hmiSavFile = '*.sav'
      
    ;定义输出路径
    hmiInboxDir = MakeDir('../Save/PhysInboxMore/' + date + '/' + wavelen + '/' + areaNum + '/') ;存储面积、通量、强度等数据
    
    ;设置搜索文件的相关参数
    oAiaData->SetProperty,inputDir=aiaSavDir
    oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile
    
    ;搜索hmi文件 
    oHmiData->FileSearch
    ;获得找到后的文件个数
    oHmiData->GetProperty,fileArr=hmiFileArr,nFiles=nHmi
    
    ;建立存放Box内的磁场数组
    arrAiaIntyBoxMean = fltarr(nHmi)
    arrHmiFluxBoxBg = fltarr(2,nHmi) ;第一列放正极磁场通量，第二列放负极磁场通量 --hmi
    arrTime = strarr(nHmi)
    
    ;设置box坐标
    needArea = hmiGetBoxCoord(areaNum) ;Box的坐标
    if (n_elements(needArea) ne 4) then message,'needArea没有四个元素，请检查hmiBP_h的设置'
    oAiaData->SetProperty,needArea=needArea 
    oHmiData->SetProperty,needArea=needArea 
    
    ;test begin; 
      ;i0 = 1500 & nHmi = i0 + 1    ;For testing
      ;for i=i0,nHmi-1 do begin
    ;endtest;
    
    for i=0,nHmi-1 do begin
        ;读入hmi数据
        restore,hmiFileArr[i],/ve  ;数据存储成了stuMap
        
        ;获取时间
        arrTime[i] = hmiMap.time
              
        oHmiData->SetProperty,map=hmiMap,data=hmiMap.data
                     
        ;从Hmi挑出与Aia符合的图
        oHmiData->GetFnamTime,hmiFileHead,i=i,Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
        aiaSavFile = strcompress(aiaFileHead + Year + AiaymdChar + Month + AiaymdChar + Day + AiaconnChar + $
                                 Hour + AiahmsChar + Minute + '*.sav',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据
                              
        ;搜索aia数据
        oAiaData->SetProperty,inputFile=aiaSavFile
        oAiaData->FileSearch 
        oAiaData->GetProperty,nFiles=nAia,FileArr=aiaFileArr
       
        tmpAiaIntyBoxSum = 0 ;统计aia1分钟内平均强度的临时参数
        ;test; nAia =1
        for j=0,nAia-1 do begin
            ;读入aia数据
            restore,aiaFileArr[j],/ve  
    
            oAiaData->SetProperty,map=aiaMap,data=aiaMap.data
            oAiaData->DExprTime  ;消除曝光时间的影响 
                                       
            ;获取 Box内的aia强度
            tmpAiaIntyBox = oAiaData->GetAreTotPhy(/map)
                        
            if (tmpAiaIntyBox le 2) then begin  ;去除坏点
                tmpAiaIntyBox = !VALUES.F_NAN
            endif
             
            Push,arrAiaIntyBoxAll,tmpAiaIntyBox
            tmpAiaIntyBoxSum += tmpAiaIntyBox
        endfor
        
        ;处理视线方向上纬度造成的误差
        oHmiData->CorrLatitudeLOS    
                                
        ;获取 Box内的磁场，包括背景
        arrHmiFluxBoxBg[0,i] = oHmiData->GetAreTotPhy(/map,polarity='pos')
        arrHmiFluxBoxBg[1,i] = oHmiData->GetAreTotPhy(/map,polarity='neg')
        
        ;aia平均1分钟内的强度
        arrAiaIntyBoxMean[i] = tmpAiaIntyBoxSum / nAia      
    endfor
    
    ;存储磁场面积，磁通量，aia所有强度，aia和hmi对应强度，时间
    save,arrHmiFluxBoxBg,arrAiaIntyBoxAll,arrAiaIntyBoxMean,arrTime,filename=hmiInboxDir+'InBox.sav'
    
    ;销毁对象
    obj_destroy,oHmiData
    obj_destroy,oAiaData
    
    ;消除push添加的变量
    undefine,arrAiaIntyBoxAll
    Say,'areaNum: ',areaNum
endfor
Over
END