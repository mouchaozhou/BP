;+===========================annotation--begin===================================================
; 用contour的方法定义一下Emergence
;-===========================annotation--begin===================================================

@rep2BP.in

magContVal = 30;(Gs)

for j=53,70 do begin
    areaNum = IToA(j)
    ;创建对象
    oHmiData = obj_new('HMI') 
    ;输入路径和输入文件
    hmiSavDir = '../../HMI_BP/Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
    hmiSavFile = '*.sav' 
    ;为了或得arrTime参数
    hmiInboxDir = '../../HMI_BP/Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
    hmiInboxFile = '*.sav'
    
    ;得到磁场浮现时间（临时变量）
    magEmgTimeTmp = rep2BPGetEmergenceTime(areaNum)
    
    if (magEmgTimeTmp ne 'null') && (magEmgTimeTmp ne 'diff') then begin  
        ;输出路径
        imgDir = MakeDir('../Image/test_MagContour4Emerg/' + date + '/' + IToA(magContVal) + 'Gs/' + areaNum + '/')
        
        ;设置搜索文件的相关参数
        oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=imgDir
        
        ;搜索文件 
        oHmiData->FileSearch
        ;获得找到后的文件个数
        oHmiData->GetProperty,fileArr=hmiFileArr
        
        ;设置画图参数
        oHmiData->SetProperty,threshold=hmiThreshold,charsize=1.0,position=[0.1,0.1,0.9,0.9],needArea=hmiGetBoxCoord(areaNum) ;Box的坐标
        device,decomposed=1
        
        ;得到磁场浮现时间
        magEmgTime = rep2BPFormatTime(magEmgTimeTmp)
        
        ;恢复sav中存放的数据(曲线数据)
        hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime
        arrTime = rep2BPStrmidTime(arrTime)
        
        ;浮现时刻的文件索引
        magEmgIndex = Arr0(WhereEx(magEmgTime eq arrTime))
        Dbg,'magEmgIndex: ',magEmgIndex
        
        for i=magEmgIndex-50,magEmgIndex+100 do begin
            ;恢复数据
			if (i ge 0) then begin				
                restore,hmiFileArr[i],/ve
				;设置相应数据        
                oHmiData->SetProperty,map=hmiMap,data=hmiMap.data,iFile=i
		    endif $
		    else begin
			    restore,hmiFileArr[0],/ve
				;设置相应数据        
                oHmiData->SetProperty,map=hmiMap,data=hmiMap.data,iFile=0
		    endelse
             
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
            
            ;画Box
            oHmiData->PlotBox,color=GetColour('Red')  ;与swamis类的swDrawBox完全相同
            
            ;画坐标轴
            oHmiData->PlotMap,/no_data,/noerase
        
            ;存储图片             
            oHmiData->SavImage,description='_'+areaNum+'_'+IToA(magContVal)+'Gs_'+IToA(i)+'_'
        endfor
        
        ;制作GIF动画
        Say,'Making movie...'
        oHmiData->SetProperty,inputDir=imgDir,inputFile='*.png',outputDir=imgDir
        oHmiData->MakeMovie,gifName='contour4emerg_'+areaNum+'_'+IToA(magContVal)+'Gs_.gif',fileIntev=1
    endif 
    ;销毁对象
    obj_destroy,oHmiData 
endfor

Over
END 