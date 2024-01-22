PRO papBPPlotCurves,nCase,t,posFluxBg,negFluxBg,Intensity,arrSelTime, $
                    pos=pos,timeRange=timeRange,charsize=charsize,maxBgPosFlux=maxBgPosFlux,maxBgNegFlux=maxBgNegFlux
 ;+===========================annotation--begin===================================================
 ; 画光变曲线和磁场通量图
 ;-===========================annotation--end=====================================================             
                    
  ;设置颜色(ps设备下只能用伪彩色) 
  tvlct,0,0,0,0    ;Black Intensity 指示线
  tvlct,0,0,255,1  ;Blue posFluxBg
  tvlct,255,0,0,2  ;Red  posFluxBg
  
  if (fix(nCase) le 3) then begin
      items = ['Intensity', $
               'Flux(+) MAX: '+num2str(maxBgPosFlux,format='(e14.1)')+' Mx', $  ;format='(e14.1)' 保证了float的精度，保留1位小数
               'Flux(-) MAX: '+num2str(abs(maxBgNegFlux),format='(e14.1)')+' Mx'  ]
  endif $ 
  else begin
      items = ['Intensity']
  endelse
  lineStyle = intarr(n_elements(items))
  if (n_elements(charsize) eq 0) then charsize = 0.8
  charthick = 3
  
  ;根据timeRange判断y的范围
  if (n_elements(timeRange) ne 0) then begin
      tIndex = [where(timeRange[0] eq t),where(timeRange[1] eq t)]  
      yFloor = min([min(posFluxBg[tIndex[0]:tIndex[1]]), min(negFluxBg[tIndex[0]:tIndex[1]]), min(Intensity[tIndex[0]:tIndex[1]])])
  endif $
  else begin
      yFloor = min([min(posFluxBg),min(negFluxBg),min(Intensity)])
  endelse
  
  yRange = [yFloor,1]
  yticklen = 0.01
  
  ;计算y轴刻度值
  ylabel = strcompress('.' + string(GradeArr(ceil(yFloor*10),1,10)),/remove_all)
  ylabel[n_elements(ylabel)-1] = '1.'
 
  ;aia强度
  utplot,t,Intensity,color=0,yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
         xtitle='Start Time ('+strmid(t[0],0,strlen(t[0])-4)+' UT)',/nolabel, $
         ytitle='Normalised Radiance and Magnetic flux (A.U.)',charthick=charthick,ytickname=ylabel
  if (fix(nCase) le 3) then begin
      ;正极磁场+背景
      utplot,t,posFluxBg,color=1,yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
             /nolabel,ytickname=ylabel
      ;负极磁场+背景
      utplot,t,negFluxBg,color=2,yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
             /nolabel,ytickname=ylabel
  endif
  
  ;获得aia强度与通量强度的最小值，为了画选出来的时刻的线
  minCurve = min([[Intensity],[transpose(posFluxBg)],[transpose(negFluxBg)]],dimension=2)  ;posFluxBg和negFluxBg都是列向量，Intensity是行向量
  
  ;画选出来的时刻的线
  for i=0,n_elements(arrSelTime)-1 do begin
      arrVal = GradeArr(Arr0(minCurve[where(arrSelTime[i] eq t)]),0.005,1.)
      outplot,replicate(arrSelTime[i],n_elements(arrVal)),arrVal,color=0,psym=3
  endfor

  ;legend的位置
  case nCase of 
        '1': begin  
                lpos = [pos[2]-0.47,pos[1]+0.08]  ;矩形框的左上角坐标
             end
        '2': begin
                lpos = [pos[2]-0.88,pos[1]+0.42]  ;矩形框的左上角坐标
             end
        '3': begin
                lpos = [pos[2]-0.86,pos[1]+0.42]  ;矩形框的左上角坐标
             end
        '4': begin
                lpos = [pos[2]-0.47,pos[1]+0.08]  ;矩形框的左上角坐标
             end
      else: message,'No sucn choice!'
  endcase
  ;指示符
  legend,items,linestyle=lineStyle,colors=[0,1,2],charsize=0.9,pos=lpos,/normal,charthick=3,thick=3
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPPlotStage,nCase
  ;+===========================annotation--begin===================================================
  ; 画出前中后三个时期的分割线
  ;-===========================annotation--end=====================================================
  case nCase of 
        '4': begin
               stageLineTime = [ ['31-Dec-2010 23:59:40.200'], $
                                [' 1-Jan-2011 05:29:40.300'], $
                                 [' 1-Jan-2011 23:59:40.200']  ]
             end
       else: message,'No sucn choice!'
  endcase
 
  tvlct,255,0,0,2  ;Red 
  ;画选出来的时刻的线
  for i=0,n_elements(stageLineTime)-1 do begin
      arrVal = GradeArr(0,0.005,1.)
      outplot,replicate(stageLineTime[i],n_elements(arrVal)),arrVal,color=2,thick=2
  endfor
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPFormatTime,time
  ;+===========================annotation--begin===================================================
  ; 将时间处理成标准形式
  ;-===========================annotation--end=====================================================
  strTime = strsplit(time,/extract)
 
  if (strlen(strTime[0] eq 11)) then begin  ;去掉年
      strTime[0] = strmid(strTime[0],0,6)  
  endif $
  else begin
      strTime[0] = strmid(strTime[0],0,5)
  endelse
 
  strTime[1] = strmid(strTime[1],0,5)  ;去掉秒
  return,strTime[0]+' '+strTime[1]+' UT'
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPPlotCurve,nCase,t,phyVar,arrSelTime, $
                   type=type,pos=pos,timeRange=timeRange,item=item,ytitle=ytitle,lpos=lpos,yRange=yRange, $
                   xlab=xlab,ylab=ylab,xtitle=xtitle
  ;+===========================annotation--begin===================================================
  ; 画单独的曲线
  ;-===========================annotation--end=====================================================                                    
  xcharsize = 0.7
  ycharsize = 0.8
  
  charthick = 3.0  
  yticklen = 0.01
 
  utplot,t,phyVar,color=0,yrange=yRange,xstyle=1,ystyle=1,/noerase,charsize=charsize,position=pos,yticklen=yticklen,timerange=timeRange, $
         xtitle=xtitle,/nolabel,ytitle=ytitle,charthick=charthick,xtickname=xlab,ytickname=ylab,xcharsize=xcharsize,ycharsize=ycharsize

  ;获得aia强度与通量强度的最小值，为了画选出来的时刻的线
  minCurve = phyVar
  
  ;画选出来的时刻的线
  for i=0,n_elements(arrSelTime)-1 do begin
      minVal = Arr0(minCurve[WhereEx(arrSelTime[i] eq t)])
      if (type eq 'Intensity') then begin
          arrVal = GradeArr(minVal,0.005,1.) 
      endif $
      else begin         
          arrVal = GradeArr(minVal,papBPGetPointInterval(nCase),yRange[1])
      endelse
      outplot,replicate(arrSelTime[i],n_elements(arrVal)),arrVal,color=0,psym=3
  endfor
  
  ;指示符
  if (n_elements(item) ne 0) then begin
      lineStyle = intarr(1) 
      legend,item,linestyle=lineStyle,colors=[0],charsize=0.6,pos=lpos,/normal,charthick=1,thick=1
  endif
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPType2Num,arrDataTmp,type1,num1,type2,num2,type3,num3
  szArrDataTmp = n_elements(arrDataTmp)
  arrData = fltarr(szArrDataTmp)
  for i=0,szArrDataTmp-1 do begin
    arrDataTmp[i] = strtrim(arrDataTmp[i],2)  ;去除前后的空格
    if (arrDataTmp[i] eq type1) then begin
        arrData[i] = num1
    endif $
    else if (arrDataTmp[i] eq type2) then begin
        arrData[i] = num2
    endif $
    else if (arrDataTmp[i] eq type3) then begin
        arrData[i] = num3
    endif $
    else begin
        print,i,'  ',arrDataTmp[i]
        message,'papBPType2Num has a problem here!, no such type!'
    endelse
  endfor
  return,arrData  
END
;-----------------------------------------------------------------------------------------------------------------------------