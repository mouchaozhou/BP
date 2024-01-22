;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose: 
;    比较日冕亮点环顶和环底的光变曲线，看看点亮顺序
;    step 3 : 做环足点（2个）和环顶点(1个)的扫描图
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

;PRO main
@hmiBP.in

oHmiData = obj_new('HMI')  ;这里搜索hmi的数据是为了获取文件名中的时间信息
oAiaData = obj_new('AIA',fix(waveLen))  
 
;输入路径和输入文件(hmiBPGetBoxPhys)
aiaSavDir = '../../AIA_BP/Save/AfterCmp/'  + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavDir = '../Save/AfterCmp/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiSavFile = '*.sav' 
hmiInboxDir = '../Save/LoopData/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;定义输出路径
scanImgDir = MakeDir('../Figure/LoopScan/' + date + '/' + wavelen + '/' + areaNum + '/') ;画出位置（画圆）

;设置搜索文件的相关参数
oAiaData->SetProperty,inputDir=aiaSavDir
oHmiData->SetProperty,inputDir=hmiSavDir,inputFile=hmiSavFile,outputDir=scanImgDir

;搜索文件 
oHmiData->FileSearch
;获得找到后的文件个数
oHmiData->GetProperty,fileArr=hmiFileArr,nFiles=nHmi

;恢复sav中存放的数据
hmiBPGetLoopSavData,hmiInboxDir+hmiInboxFile,/normal,arrTime=arrTime,arrLpBottomL=arrLpBottomL,arrLpBottomR=arrLpBottomR,arrLpTop=arrLpTop

;画图参数
xsize = 1600
ysize = 900
;       x0    y0    x1    y1
pos = [0.025,0.49,0.975,0.99]
y0 = 0.04 & y1 = 0.45
x01 = 0.1 & x11 = ysize*(y1-y0)/xsize + x01
x02 = x11 + 0.3 & x12 = ysize*(y1-y0)/xsize + x02

;aia contour参数
;Bmin = 100. & Bmax = 500. & nB = 40.  ;211
Bmin = 300. & Bmax = 1000. & nB = 40.  ;193
cntorLevels = GradeArr(Bmin,nB,Bmax)
Cmin = 50. & Cmax = 255. & nC = (Cmax-Cmin)*nB/(Bmax-Bmin)
cntorCcolors = GradeArr(Cmin,nC,Cmax)

;设置画图参数
arrNeedArea = hmiGetLoopCoord(areaNum) ;环底和环顶的坐标
oAiaData->SetProperty,threshold=aiaThreshold,position=[x01,y0,x11,y1],charsize=1.0
oHmiData->SetProperty,threshold=hmiThreshold,position=[x02,y0,x12,y1],charsize=1.0

;test begin; 
  ;i0 = 970 & nHmi = i0 + 1    ;For testing
  ;goto,make_movie
;endtest;

for i=0,nHmi-1 do begin
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
         
    j = 0   ;不需要画那么多幅图  
    
    ;读入aia数据
    restore,aiaFileArr[j],/ve 
       
    oAiaData->SetProperty,map=aiaMap,data=aiaMap.data
    oAiaData->DExprTime  ;消除曝光时间的影响 
    oAiaData->Data2Contour  ;将消除曝光时间后的数据给contour
                                     
    ;/********** 画在一幅图中  **********/
    window,1,xsize=xsize,ysize=ysize,retain=2
        
    ;画hmi磁场图
    device,decomposed=1  ;打开颜色分解，否则color那里不起作用—_-！
    oHmiData->PlotImage,/onlyData,/noerase   
    ;画Box
    for k=0,2 do begin
        oHmiData->SetProperty,needArea=arrNeedArea[*,k]
        oHmiData->PlotBox,color=GetColour('Yellow')
    endfor
    ;画角秒坐标轴        
    oHmiData->PlotMap,/no_data,/noerase
 
    ;画aia图
    device,decomposed=0  ;关闭颜色分解,伪彩色
    oAiaData->Lct,waveLen=1600  ;导入色表
    oAiaData->PlotImage,/onlyData,/noerase
    ;画aia的contour
    loadct,13  ;选择色表 Rainbow画contour，xloadct可用来查看色表情况
    oAiaData->Contour,c_colors=cntorCcolors,levels=cntorLevels
    ;画Box
    device,decomposed=1  ;打开颜色分解，真彩色
    for k=0,2 do begin
        oAiaData->SetProperty,needArea=arrNeedArea[*,k]
        oAiaData->PlotBox,color=GetColour('Blue')  ;与swamis类的swDrawBox完全相同
    endfor 
    ;画角秒坐标轴        
    oAiaData->PlotMap,/no_data,/noerase
        
    ;画Sav文件的数据
    hmiBPLoopPlotCurves,arrTime,arrLpBottomL,arrLpBottomR,arrLpTop,title='Normal',tLine=arrTime[i*5],pos=pos  
        
    ;存储图片(读的是谁的就不需要设置谁的)
    oHmiData->SavImage,description='__'+file_basename(aiaFileArr[j])+'_'+strcompress(i)+'_'+strcompress(j)+'_'
endfor

;制作GIF动画
make_movie:
Say,'Making movie...'
oHmiData->SetProperty,inputDir=scanImgDir,inputFile='*.png',outputDir=scanImgDir
oHmiData->MakeMovie,gifName=waveLen+'_'+areaNum+'_loop_scan.gif',fileIntev=5
 
;销毁对象
obj_destroy,oHmiData
obj_destroy,oAiaData
Say,'areaNum: ',areaNum
Over
END