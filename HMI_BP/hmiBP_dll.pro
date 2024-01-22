PRO hmiBPGetBoxSavData,file,normal=normal,scale=scale,info=info, $
                       arrTime=arrTime,bgPosFlux=bgPosFlux,bgNegFlux=bgNegFlux,Intensity=Intensity, $
                       maxBgPosFlux=maxBgPosFlux,maxBgNegFlux=maxBgNegFlux                    
  ;数据处理，arrTime是HMI的时间
  restore,file,/ve
  smNum = 7  ;平滑点的个数
  if (keyword_set(normal)) then begin
      bgPosFlux = Normal(smooth(arrHmiFluxBoxBg[0,*],smNum,/edge_truncate)) ;解决ambiguous keyword abbreviation问题
      bgNegFlux = Normal(smooth(arrHmiFluxBoxBg[1,*],smNum,/edge_truncate)) ;相似关键字必须从前缀区分
      Intensity = Normal(arrAiaIntyBoxMean)
  endif $
  else if (keyword_set(scale)) then begin  
      ;>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ;>>>>>>>>>  1 麦克斯韦 = 1 高斯× 厘米^2 = 10^−8 韦伯     <<<<<<<<
      ;>>>>>>>>>  1  Mx     = 1 Gs  × cm^2  = 10^-8  Wb   <<<<<<<<
      ;>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   
      bgPosFlux = double(smooth(arrHmiFluxBoxBg[0,*],smNum,/edge_truncate)) * (0.60000002*720*1e5)^2 / 1e19 ;转换为Mx单位,再除以1e19量级
      bgNegFlux = double(abs(smooth(arrHmiFluxBoxBg[1,*],smNum,/edge_truncate))) * (0.60000002*720*1e5)^2 / 1e19
      Intensity = Normal(arrAiaIntyBoxMean)
  endif $
  else begin
      bgPosFlux = smooth(arrHmiFluxBoxBg[0,*],smNum,/edge_truncate) ;解决ambiguous keyword abbreviation问题
      bgNegFlux = smooth(arrHmiFluxBoxBg[1,*],smNum,/edge_truncate) ;相似关键字必须从前缀区分
      Intensity = arrAiaIntyBoxMean 
  endelse 
  
  ;取出正负极的最大值，曲线图中定标用
  maxBgPosFlux = max(arrHmiFluxBoxBg[0,*])
  maxBgNegFlux = min(arrHmiFluxBoxBg[1,*])
 
  if (keyword_set(info)) then begin
      Dbg,arrTime[0],Last(arrTime)
      Echo,decp='posFluxBg:',bgPosFlux,/str
      Echo,decp='negFluxBg:',bgNegFlux,/str
      Echo,decp='Intensity:',Intensity,/str
  endif
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO hmiBPGetLoopSavData,file,normal=normal,info=info, $
                        arrTime=arrTime,arrLpBottomL=arrLpBottomL,arrLpBottomR=arrLpBottomR,arrLpTop=arrLpTop
  ;数据处理
  restore,file,/ve  ;数据存储成了arrTime,arrLpBottomL,arrLpBottomR,arrLpTop                   
  smNum = 25  ;5分钟平滑
  if (keyword_set(normal)) then begin
      arrLpBottomL = Normal(smooth(arrLpBottomL,smNum,/edge_truncate,/nan))
      arrLpBottomR = Normal(smooth(arrLpBottomR,smNum,/edge_truncate,/nan))
      arrLpTop     = Normal(smooth(arrLpTop,smNum,/edge_truncate,/nan))
  endif $
  else begin
      arrLpBottomL = smooth(arrLpBottomL,smNum,/edge_truncate,/nan)
      arrLpBottomR = smooth(arrLpBottomR,smNum,/edge_truncate,/nan)
      arrLpTop     = smooth(arrLpTop,smNum,/edge_truncate,/nan) 
  endelse 
  
  if (keyword_set(info)) then begin
    Dbg,arrTime[0],Last(arrTime)
    Echo,decp='arrLpBottomL:',arrLpBottomL,/str
    Echo,decp='arrLpBottomR:',arrLpBottomR,/str
    Echo,decp='arrLpTop:',arrLpTop,/str
  endif                   
END
;-----------------------------------------------------------------------------------------------------------------------------


PRO hmiBPPlotCurves,t,posFluxBg,negFluxBg,Intensity,ti, $
                    pos=pos,timeRange=timeRange,_extra=_extra
  device,decomposed=1
  color = [ GetColour('Blue'), $   ;posFluxBg
            GetColour('Red'), $    ;negFluxBg
            GetColour('White'), $  ;Intensity
            GetColour('Yellow') ]  ;指示线

  items = ['Flux_bg(+)','Flux_bg(-)','Intensity']
  lineStyle = intarr(n_elements(items))
  charsize = 1.0
  
  if (n_elements(timeRange) ne 0) then begin
      tIndex = [where(timeRange[0] eq t),where(timeRange[1] eq t)]  
      yFloor = min([min(posFluxBg[tIndex[0]:tIndex[1]]), min(negFluxBg[tIndex[0]:tIndex[1]]), min(Intensity[tIndex[0]:tIndex[1]])])
  endif $
  else begin
      yFloor = min([min(posFluxBg),min(negFluxBg),min(Intensity)])
  endelse
  
  yRange = [yFloor,1]
  yticklen = 0.01
  
  ;正极磁场+背景
  utplot,t,posFluxBg,color=color[0],yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
         _extra=_extra
  ;负极磁场+背景
  utplot,t,negFluxBg,color=color[1],yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
         _extra=_extra
  ;aia强度
  utplot,t,Intensity,color=color[2],yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
         _extra=_extra
    
  ;画一条指示线
  outplot,[ti,ti],[yFloor,1.],color=color[3]
      
  ;指示符
  legend,items,linestyle=lineStyle,colors=color,charsize=1.0,/right,/bottom
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO hmiBPLoopPlotCurves,arrTime,arrLpBottomL,arrLpBottomR,arrLpTop,timeRange=timeRange,title=title,tLine=tLine,pos=pos
  ;设置颜色
  device,decomposed=1
  color = [ GetColour('Blue'), $   ;arrLpBottomL
            GetColour('Red'), $    ;arrLpBottomR
            GetColour('White'), $  ;arrLpTop
            GetColour('Yellow') ]  ;指示线 
  items = ['Loop Bottom1','Loop Bottom2','Loop Top']
  lineStyle = intarr(n_elements(items))
  charsize = 1.0
         
  if (n_elements(timeRange) ne 0) then begin
        tIndex = [where(timeRange[0] eq arrTime),where(timeRange[1] eq arrTime)]  
        yCeil  = max([max(arrLpBottomL[tIndex[0]:tIndex[1]]), max(arrLpBottomR[tIndex[0]:tIndex[1]]), max(arrLpTop[tIndex[0]:tIndex[1]])])
        yFloor = min([min(arrLpBottomL[tIndex[0]:tIndex[1]]), min(arrLpBottomR[tIndex[0]:tIndex[1]]), min(arrLpTop[tIndex[0]:tIndex[1]])])
  endif $
  else begin
        yCeil  = max([max(arrLpBottomL),max(arrLpBottomR),max(arrLpTop)])
        yFloor = min([min(arrLpBottomL),min(arrLpBottomR),min(arrLpTop)])
  endelse
  
  yRange = [yFloor,yCeil]
  yticklen = 0.01

  ;环足点（左）
  utplot,arrTime,arrLpBottomL,color=color[0],yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen, $
         timerange=timeRange,title=title
  ;环足点（右）
  utplot,arrTime,arrLpBottomR,color=color[1],yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen, $
         timerange=timeRange
  ;环顶上
  utplot,arrTime,arrLpTop,color=color[2],yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange
  
  ;画一条指示线
  if (n_elements(tLine) ne 0) then $
      outplot,[tLine,tLine],[yFloor,yCeil],color=color[3]
  
  ;指示符
  legend,items,linestyle=lineStyle,colors=color[0:2],charsize=1.5,/left,/top
END
;-----------------------------------------------------------------------------------------------------------------------------

Function hmiBPBlankFormat,i,num
  ;为了显示方便，选择空格
  len = strlen(IToA(num))
  if (i eq 0) then begin   ;beginNum
      case len of
        1: return,'          '
        2: return,'         '
        3: return,'        '
        4: return,'       '
        else: message,'No such possibility! ' + IToA(len)
      endcase
  endif $
  else begin     ;refNum endNum
      case len of
        2: return,'           '
        3: return,'          '
        4: return,'         '
        else: message,'No such possibility! ' + IToA(len)
      endcase
  endelse
END
;-----------------------------------------------------------------------------------------------------------------------------