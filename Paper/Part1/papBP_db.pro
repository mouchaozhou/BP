PRO papBPGetCasePars,nCase,areaNum=areaNum,arrSelTime=arrSelTime,offset=offset,newArea=newArea,boxArea=boxArea
                     
  ;获得每个实例选择的时刻点
  case nCase of 
    '1': begin
          ;选用的事件编号 
          areaNum = '1'  ;Emergence
          arrSelTime = [ '31-Dec-2010 17:49:10.100', $  ;0  时间采用HMI的
                         ' 1-Jan-2011 00:49:10.200', $  ;1
                         ' 1-Jan-2011 06:54:25.300'  ]  ;2                                                                       
          ;画图时的前后偏移量               
          offset = [ '31-Dec-2010 16:49:10.100', $
                     ' 1-Jan-2011 07:29:40.300'  ]       
         end
    '2': begin
          areaNum = '42'  ;Convergence  
          arrSelTime = [ ' 2-Jan-2011 07:49:10.300', $  ;0            
                         ' 2-Jan-2011 16:44:40.100', $  ;1                                                                                                                                                                                                      
                         ' 2-Jan-2011 19:44:40.100'  ]  ;2                                                                                                                                                                             
          offset = [ ' 2-Jan-2011 06:44:40.300', $
                     ' 2-Jan-2011 20:24:25.100'  ]
 
         end
    '3': begin
          areaNum = '19'  ;Local Combination
          arrSelTime = [ ' 2-Jan-2011 05:09:25.300', $  ;0                        
                         ' 2-Jan-2011 10:34:10.200', $  ;1                                                                                                                                                                                
                         ' 2-Jan-2011 17:49:10.100'  ]  ;3                                                                                                                                                                                                                                                               
          offset = [ ' 2-Jan-2011 04:09:25.300', $
                     ' 2-Jan-2011 18:49:10.100'  ]
         end
    else: message,'No sucn choice!'
  endcase
  
  ;为了磁场显示在中心所扩展的新的区域
  papBPGetArea,areaNum,newArea=newArea,boxArea=boxArea
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetCaseSymbol,nCase,posArrowCord=posArrowCord,negArrowCord=negArrowCord, $
                       posCircleCord=posCircleCord,negCircleCord=negCircleCord
    ;获得每个磁图上的箭头和圆圈坐标
    case nCase of 
      '1': begin
            ;箭头的坐标 [x0,y0,x1,y1]
            posArrowCord = [ [-1,-1,-1,-1], $  ;0
                             [-1,-1,-1,-1], $  ;1
                             [-1,-1,-1,-1]  ]  ;15
                              
            negArrowCord = [ [-1,-1,-1,-1], $  ;0 
                             [-1,-1,-1,-1], $  ;1
                             [-1,-1,-1,-1]  ]  ;2
                                   
            ;圈出磁场的圆坐标  [x0,y0,radius]
            posCircleCord = [ [-1,-1,-1],$  ;0
                              [74,51,5], $  ;1
                              [76,41,8]  ]  ;2
                              
            negCircleCord = [ [-1,-1,-1],$  ;0
                              [67,56,7], $  ;1
                              [50,53,10] ]  ;2
            
           end
      '2': begin
                        ;箭头的坐标 [x0,y0,x1,y1]
            posArrowCord = [ [-1,-1,-1,-1], $  ;0
                             [-1,-1,-1,-1], $  ;1
                             [-1,-1,-1,-1]  ]  ;15
                              
            negArrowCord = [ [-1,-1,-1,-1], $  ;0
                             [-1,-1,-1,-1], $  ;1
                             [-1,-1,-1,-1]  ]  ;15
                             
            ;圈出磁场的圆坐标  [x0,y0,radius]
            posCircleCord = [ [10,38,5],  $
                              [32,42,5],  $
                              [35,40,5]   ]
                              
            negCircleCord = [ [48,11,8],  $
                              [50,32,8],  $
                              [50,33,8]   ]
           end
      '3': begin
            ;箭头的坐标 [x0,y0,x1,y1]
            posArrowCord = [ [5,48,12,48, -1,-1,-1,-1],  $  ;0
                             [20,53,14,50, 3,38,4,45],   $  ;1
                             [19,61,12,54, -1,-1,-1,-1]  ]  ;15
                              
            negArrowCord = [ [24,11,27,17, 36,36,33,30, -1,-1,-1,-1, -1,-1,-1,-1], $  ;0
                             [31,15,34,22, 39,40,36,34, -1,-1,-1,-1, -1,-1,-1,-1], $  ;1
                             [22,22,26,30, 33,17,34,24, 44,46,39,41, 15,33,22,35]  ]  ;15
                             
            ;圈出磁场的圆坐标  [x0,y0,radius]
            posCircleCord = [ [-1,-1,-1], $
                              [-1,-1,-1], $
                              [-1,-1,-1]  ]                             
                              
            negCircleCord = [ [-1,-1,-1], $
                              [-1,-1,-1], $
                              [-1,-1,-1]  ]                               
           end
      else: message,'No sucn choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetLables,nCase,xlabel=xlabel,ylabel=ylabel,xnolab=xnolab,ynolab=ynolab
  ;获得每个磁图上的自定义的刻度值
  xnolab = [' ',' ',' ',' ',' ',' ',' ']
  ynolab = [' ',' ',' ',' ',' ',' ',' ']
  case nCase of 
    '1': begin
          xlabel = [' ','-600',' ','-580',' ','-560',' ']            
          ylabel = [' ','330',' ','350',' ','370',' ']             
         end
    '2': begin
          xlabel = ['-420','-410','-400',' ']
          ylabel = ['350','360','370',' ']
         end
    '3': begin
          xlabel = ['400','410','420']            
          ylabel = ['-360','-350','-340','-330']
         end
    else: message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetTimeLables,nCase
  ;获得每个曲线图上的自定义的x刻度值
  case nCase of 
    '1': begin
          return,xtimeLabel = ['18:00','21:00','00:00','03:00','06:00']                       
         end
    '2': begin
          return,xtimeLabel = [' ','10:00',' ','14:00',' ','18:00',' ']
         end
    '3': begin
          return,xtimeLabel = ['06:00','09:00','12:00','15:00',' ']            
         end
    else: message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetCoordinates,nCase,needArea,n,m,x0=x0,y0=y0, $
                        dx=dx,dy=dy,mid=mid,seperate=seperate                     
  ;n: 列数
  ;m: 行数
                      
  ;获得每个磁图上的自定义的坐标
  needArea = float(needArea)
  case nCase of 
    '1': begin  ;Emergence           
          ;以y为主
          x0 = 0.15 & y0 = 0.99  ;左上角图像的左上角坐标
          mid = 0.07   ;HMI与曲线图之间的间隔
          down = 0.08  ;底部间隔
          dy = (y0 - down - mid) / m ;图y方向的宽度 
          dx = (needArea[1] - needArea[0]) / (needArea[3] - needArea[2]) * dy  ;先通过图像比例计算
          dx *= !ps_y / !A4.x  ;再通过A4纸的大小转换一下
          seperate = 0.05 ;最下面三幅曲线图，第一幅和第二三幅隔开的距离                  
         end
    '2': begin  ;Convergence
          ;以y为主
          x0 = 0.15 & y0 = 0.99  ;左上角图像的左上角坐标
          mid = 0.07   ;HMI与曲线图之间的间隔
          down = 0.08  ;底部间隔
          dy = (y0 - down - mid) / m ;图y方向的宽度   
          dx = (needArea[1] - needArea[0]) / (needArea[3] - needArea[2]) * dy  ;先通过图像比例计算
          dx *= !ps_y / !A4.x  ;再通过A4纸的大小转换一下
          seperate = 0.07 ;最下面三幅曲线图，第一幅和第二三幅隔开的距离  
         end
    '3': begin  ;Local Combination
          ;以y为主
          x0 = 0.2 & y0 = 0.99  ;左上角图像的左上角坐标
          mid = 0.07   ;HMI与曲线图之间的间隔
          down = 0.08  ;底部间隔
          dy = (y0 - down - mid) / m ;图y方向的宽度   
          dx = (needArea[1] - needArea[0]) / (needArea[3] - needArea[2]) * dy  ;先通过图像比例计算
          dx *= !ps_y / !A4.x  ;再通过A4纸的大小转换一下
          seperate = 0.07 ;最下面三幅曲线图，第一幅和第二三幅隔开的距离  
         end
    else: message,'No sucn choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetAiaThreshold,nCase
 case nCase of  ;193
      '1': begin
            return,[-500.,0.]
           end
      '2': begin
            return,[-250.,0.]
           end
      '3': begin
            return,[-200.,0.]
           end
      else: message,'No sucn choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetLegendPos,nCase,i
  ;获得Legend的iterm的position的相对坐标
  case nCase of 
      '1': begin
            if (i eq 0) then return,[0.13,0.03]
            if (i eq 1) then return,[0.02,0.03]
            if (i eq 2) then return,[0.03,0.03]
           end
      '2': begin
            if (i eq 0) then return,[0.03,0.25]
            if (i eq 1) then return,[0.025,0.25]
            if (i eq 2) then return,[0.02,0.04]
           end
      '3': begin
            if (i eq 0) then return,[0.086,0.25]
            if (i eq 1) then return,[0.005,0.25]
            if (i eq 2) then return,[0.005,0.21]
           end
      else: message,'No sucn choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetFittingTimeRange,nCase,posRange=posRange,negRange=negRange
  ;或得拟合磁场的时间范围
  case nCase of  ;193
      '1': begin
            posRange = ['31-Dec-2010 23:24:25.200',' 1-Jan-2011 01:39:25.200']
            negRange = ['31-Dec-2010 22:49:10.100',' 1-Jan-2011 02:04:10.200']
           end
      else: message,'No sucn choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetPointInterval,nCase
  ;获得选出来的时刻的线的最佳间隔
  case nCase of 
      '1': begin
            return,0.05
           end
      '2': begin
            return,0.01
           end
      '3': begin
            return,0.01
           end
      else: message,'No sucn choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

