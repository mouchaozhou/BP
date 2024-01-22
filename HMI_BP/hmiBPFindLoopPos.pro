;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose: 
;    比较日冕亮点环顶和环底的光变曲线，看看点亮顺序
;    step 1 : 选出环足点（2个）环顶点(1个)的坐标并作图观看效果（偏不偏）
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;Pro main
@hmiBP.in

oHmiData = obj_new('HMI')  
oAiaData = obj_new('AIA',fix(waveLen)) 


;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavDir = '../Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav'

;选择手动还是设定
if ('1') then begin
    i0 = 1250  ;取Box时的参考图
    isFindBox = !true ;是否手动选择
    ;创建所有的参数数组
    arrNeedArea = intarr(4,3)
endif $
else begin
    i0 = 0
    isFindBox = !false
    ;使用已找出的参数
    arrNeedArea = [[80,88,114,122] , $  ;环底1（左）
                   [110,118,89,97] , $  ;环底2（右）
                   [96,104,100,108]  ]  ;环顶
endelse

;画图参数
xsize = 700
ysize = 700
oAiaData->SetProperty,threshold=aiaThreshold,charsize=1.0
oHmiData->SetProperty,threshold=hmiThreshold,charsize=1.0

;定义输出路径
hmiFindBoxDir = MakeDir('../Figure/CmpLightCurve/' + date + '/' + wavelen + '/' + areaNum + '/') ;存储面积、通量、强度等数据
;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=hmiFindBoxDir

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr,nFiles=nHmi

for i=i0,nHmi-1,20 do begin
    ;读入hmi数据
    restore,hmiFileArr[i],/ve  
    
    ;设置相应数据        
    oHmiData->SetProperty,map=hmiMap,data=hmiMap.data
                 
    ;从Hmi挑出与Aia符合的图
    oHmiData->GetFnamTime,hmiFileHead,i=i,Year=Year,Month=Month,Day=Day,Hour=Hour,Minute=Minute
    aiaSavFile = strcompress(aiaFileHead + Year + AiaymdChar + Month + AiaymdChar + Day + AiaconnChar + $
                             Hour + AiahmsChar + Minute + '*.sav',/remove_all)  ;获取hmi文件中的小时和分钟传递给aia用来读取数据
                          
    ;搜索aia数据
    oAiaData->SetProperty,inputFile=aiaSavFile
    oAiaData->FileSearch 
    oAiaData->GetProperty,nFiles=nAia,FileArr=aiaFileArr
    
    ;读入aia数据
    j = 0
    restore,aiaFileArr[j],/ve  ;数据存储成了stuMap
    oAiaData->SetProperty,map=aiaMap,data=aiaMap.data,contrData=aiaMap.data
    oAiaData->DExprTime  ;消除曝光时间的影响 
    
    device,decomposed=0  ;关闭颜色分解,伪彩色 
    oAiaData->Lct,waveLen=1600  ;导入色表  
    
    if (i eq i0) && (isFindBox) then begin
        coordFile = hmiFindBoxDir + 'coordinates.xml'
        file_delete,coordFile,/allow_nonexistent
        openu,lun,coordFile,/get_lun,/append
        
        ;手动截取一块区域 
        window,0,xsize=1000,ysize=1000,retain=2 
        oAiaData->SetProperty,position=[0.1,0.1,0.9,0.9]     
        oAiaData->PlotImage,/pix 
        
        for j=0,2 do begin  ;选三块区域，环底2个，环顶1个                     
            print,'请截取一块区域...'
            if (j eq 0) then begin  ;第一次截出一个矩形来
                needArea = round(CursorCrop(/data,/info))  ;用鼠标截取一块区域
                xHalfLen = 0.5 * (needArea[1] - needArea[0])
                yHalfLen = 0.5 * (needArea[3] - needArea[2])
            endif $
            else begin  ;后二次只取矩形的中心点
                cursor,/down,cenX,cenY,/data
                needArea = round([cenX-xHalfLen,cenX+xHalfLen,cenY-yHalfLen,cenY+yHalfLen])
            endelse
            
            oAiaData->SetProperty,needArea=needArea
            oAiaData->PlotBox,color=0                                 
            needArea = ItoA(needArea)  ;转化为字符串
            
            ;写入获得的坐标                    
            printf,lun,'areaNum: ',areaNum
            printf,lun,'[',needArea[0],',',needArea[1],',',needArea[2],',',needArea[3],']'
            printf,lun,''
            
            ;保存参数
            arrNeedArea[*,j] = needArea
        endfor
        
        ;判断区域是否满意
        Say,'areaNum: ',areaNum
        yes_no,'觉得区域满意就按y继续，否则按回车或n中断程序',answer,'n'  ;最后一个是按回车的默认选项
        if (answer eq 0) then begin
            free_lun,lun
            Dbg,'程序中止！',/sp
        endif
        
        free_lun,lun       
        i = 0
        isFindBox = !false       
    endif
    
          
    ;/********** 画在一幅图中  **********/
    window,1,xsize=xsize*2,ysize=ysize,retain=2 

    ;画aia图  
    oAiaData->SetProperty,position=[0.025,0.05,0.475,0.95]
    oAiaData->PlotImage,/onlyData,/noerase
    ;画Box
    device,decomposed=1  ;打开颜色分解，真彩色
    for j=0,2 do begin
        oAiaData->SetProperty,needArea=arrNeedArea[*,j]
        oAiaData->PlotBox,color=GetColour('Blue')  
    endfor
    ;画角秒坐标轴        
    oAiaData->PlotMap,/no_data,/noerase
    
    ;画hmi磁场图
    oHmiData->SetProperty,position=[0.525,0.05,0.975,0.95]   
    oHmiData->PlotImage,/onlyData,/noerase  
    ;画Box
    for j=0,2 do begin
        oHmiData->SetProperty,needArea=arrNeedArea[*,j]
        oHmiData->PlotBox,color=GetColour('Yellow')
    endfor
    ;画角秒坐标轴        
    oHmiData->PlotMap,/no_data,/noerase
     
    ;存储图片(读的是谁的就不需要设置谁的)
    oHmiData->SavImage,description='__'+file_basename(aiaFileArr[j])+'_'+strcompress(i)+'_'         
endfor

;销毁对象
obj_destroy,oHmiData
obj_destroy,oAiaData
Say,'areaNum: ',areaNum
Over
END
