;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose: 
;    比较日冕亮点环顶和环底的光变曲线，看看点亮顺序
;    step 2 : 取出环足点（2个）环顶点(1个)的数据
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;Pro main
@hmiBP.in

oAiaData = obj_new('AIA',fix(waveLen))  
 
;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
aiaSavFile = '*.sav'
  
;定义输出路径
aiaInboxDir = MakeDir('../Save/LoopData/' + date + '/' + wavelen + '/' + areaNum + '/') ;存储面积、通量、强度等数据

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir,inputFile=aiaSavFile

;搜索hmi文件 
oAiaData->FileSearch
;获得找到后的文件个数
oAiaData->GetProperty,fileArr=aiaFileArr,nFiles=nAia

;建立存放Loop内时间数据的数组
arrTime = strarr(nAia)

;获得Loop坐标
arrNeedArea = hmiGetLoopCoord(areaNum) ;环底和环顶的坐标
if (n_elements(arrNeedArea[*,0]) ne 4) then message,'needArea没有四个元素，请检查hmiBP_h的设置'


for i=0,nAia-1 do begin
    ;读入aia数据
    restore,aiaFileArr[i],/ve  ;数据存储成了stuMap
    
    ;获取时间
    arrTime[i] = aiaMap.time
     
    ;设置aia数据              
    oAiaData->SetProperty,map=aiaMap,data=aiaMap.data
    oAiaData->DExprTime  ;消除曝光时间的影响 
    
    for k=0,2 do begin
        ;设置Loop坐标 
        oAiaData->SetProperty,needArea=arrNeedArea[*,k] 
                              
        ;获取 Box内的aia强度
        tmpAiaIntyBox = oAiaData->GetAreTotPhy(/map)
                
        if (tmpAiaIntyBox le 2) then begin  ;去除坏点
            tmpAiaIntyBox = !VALUES.F_NAN
        endif
     
        if (k eq 0) then begin
            Push,arrLpBottomL,tmpAiaIntyBox
        endif $
        else if (k eq 1) then begin
            Push,arrLpBottomR,tmpAiaIntyBox
        endif $ 
        else if (k eq 2) then begin
            Push,arrLpTop,tmpAiaIntyBox
        endif
     endfor  
endfor

Dbg,max(arrlpbottomL),min(arrlpbottomL),Means(arrlpbottomL),median(arrlpbottomL),variance(arrlpbottomL)
Dbg,max(arrlpbottomR),min(arrlpbottomR),Means(arrlpbottomR),median(arrlpbottomR),variance(arrlpbottomR)
Dbg,max(arrLpTop),min(arrLpTop),Means(arrLpTop),median(arrLpTop),variance(arrLpTop)

;存储磁场面积，磁通量，aia所有强度，aia和hmi对应强度，时间
save,arrTime,arrLpBottomL,arrLpBottomR,arrLpTop,filename=aiaInboxDir+'Loop.sav'

;销毁对象
obj_destroy,oAiaData

;消除push添加的变量
undefine,arrLpBottomL
undefine,arrLpBottomR
undefine,arrLpTop
Say,'areaNum: ',areaNum
Over
END