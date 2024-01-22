;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    测量BP刚开始出现时和AIA达到峰值时两个主极性的距离
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;PRO main
@../../HMI_BP/Program/hmiBP.in

;创建对象
oHmiData = obj_new('HMI') 

;定义contour值大小
for magContVal=10,15,5 do begin;(Gs)
    for j=1,70 do begin
        areaNum = IToA(j)
        Say,'areaNum: ',areaNum
    
        ;输入路径和输入文件
        hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
        hmiSavFile = '*.sav' 
        ;为了或得arrTime参数
        hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
        hmiInboxFile = '*.sav'
        
        ;输出路径
        imgDir = MakeDir('../Image/MagContour4Dist/' + date + '/' + wavelen + '/' + IToA(magContVal) + 'Gs/' + areaNum + '/')
        
        ;设置搜索文件的相关参数
        oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=imgDir
        
        ;搜索文件 
        oHmiData->FileSearch
        ;获得找到后的文件个数
        oHmiData->GetProperty,fileArr=hmiFileArr
        
        ;恢复sav中存放的数据(曲线数据)
        hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime
        
        ;获得画图实例的相关参数
        arrSelTime = hmiBPGetBeginTime(areaNum)
        
        ;根据算选事件取出相应的文件index
        nSelTime = n_elements(arrSelTime)
        fileIndex = intarr(nSelTime)
        for i=0,nSelTime-1 do begin
            if(arrSelTime[i] eq '0') then $   ;从肉眼判断出来磁场间距离为0，即磁场挨在一起
               fileIndex[i] = 'NULL'  $ ;标记一下
            else $
               fileIndex[i] = WhereEx(arrSelTime[i] eq arrTime)
        endfor 
        
        ;设置画图参数
        oHmiData->SetProperty,threshold=hmiThreshold,charsize=1.0,position=[0.1,0.1,0.9,0.9] 
        device,decomposed=1
        
        for i=0,nSelTime-1 do begin
            if (fileIndex[i] ne 'NULL') then begin   ;如果等于NULL则不需要计算距离，距离为0
                ;恢复数据
                restore,hmiFileArr[fileIndex[i]],/ve
                ;设置相应数据        
                oHmiData->SetProperty,map=hmiMap,data=hmiMap.data 
                ;画图
                window,1,xsize=900,ysize=900,retain=2
                ;只画图
                oHmiData->PlotImage,/onlyData
                
                ;#region 作nGs的Contour
                oHmiData->Data2Contour,polarity='pos'
                oHmiData->Contour,levels=[magContVal],color=GetColour('Blue')
                oHmiData->Data2Contour,polarity='neg'
                oHmiData->Contour,levels=[-magContVal],color=GetColour('Yellow')
                ;#endregion
                
                ;画坐标轴
                oHmiData->PlotMap,/no_data,/noerase
        
                ;存储图片             
                oHmiData->SavImage,description='__'+file_basename(hmiFileArr[fileIndex[i]])+'_'+areaNum+'_'+ IToA(i)+'_'                                 
            endif
        endfor    
    endfor
endfor

;销毁对象
obj_destroy,oHmiData 

Over
END 