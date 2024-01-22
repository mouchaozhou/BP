PRO papBPGetModelPars,nCase,areaNum=areaNum,arrSelTime=arrSelTime,needArea=needArea
  ;获得每个实例选择的时刻点
  case nCase of 
    '1': begin
          ;选用的事件编号 
          areaNum = '1'  ;small
          arrSelTime = [ ' 1-Jan-2011 00:49:10.200', $  ;新加的浮现时刻
                         ' 1-Jan-2011 11:34:10.200', $  ;0  时间采用HMI的
                         ' 1-Jan-2011 13:34:10.200', $  ;1
                         ' 1-Jan-2011 15:34:10.100', $  ;2
                         
                         ' 1-Jan-2011 00:49:10.200', $  ;新加的浮现时刻
                         ' 1-Jan-2011 11:34:10.200', $  ;0  时间采用HMI的 ;重复一遍时间
                         ' 1-Jan-2011 13:34:10.200', $  ;1
                         ' 1-Jan-2011 15:34:10.100'  ]  ;2                                                                     
         end
    '2': begin
          areaNum = '42'  ;converge  
          arrSelTime = [ ' 2-Jan-2011 18:09:25.100', $  ;0            
                         ' 2-Jan-2011 21:34:10.100', $  ;1                                                                                                                                                                                                      
                         ' 3-Jan-2011 00:29:40.200', $  ;2
                         
                         ' 2-Jan-2011 18:09:25.100', $  ;0            
                         ' 2-Jan-2011 21:34:10.100', $  ;1                                                                                                                                                                                                      
                         ' 3-Jan-2011 00:29:40.200'  ]  ;2                                                                                                                                                                             
         end
    '3': begin
          areaNum = '22'
          arrSelTime = [ ' 1-Jan-2011 01:52:10.200', $                                                
                         ' 1-Jan-2011 02:18:25.200', $                                                      
                         ' 1-Jan-2011 03:53:40.300', $  ;1         
                         ' 1-Jan-2011 10:18:25.300', $
                         
                         ' 1-Jan-2011 01:52:10.200', $ 
                         ' 1-Jan-2011 02:18:25.200', $ 
                         ' 1-Jan-2011 03:53:40.300', $  ;1  
                         ' 1-Jan-2011 10:18:25.300'  ] 
         end
     else: message,'No sucn choice!'
  endcase
  
  ;为了磁场显示在中心所扩展的新的区域
  papBPGetArea,areaNum,newArea=needArea
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetModelSymbol,nCase,posArrowCord=posArrowCord,negArrowCord=negArrowCord, $
                        posCircleCord=posCircleCord,negCircleCord=negCircleCord
  ;获得每个磁图上的箭头和圆圈坐标
  case nCase of 
    '1': begin
          ;箭头的坐标 [x0,y0,x1,y1]
          posArrowCord = [ [-1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,-1], $
                           [44,70,44,60, 26,54,33,55, 28,42,35,48, -1,-1,-1,-1], $  ;0
                           [29,57,39,55, 22,46,32,44, 31,51,39,48, -1,-1,-1,-1], $  ;1
                           [41,69,45,61, 29,56,39,55, 27,42,39,45, 65,33,64,41]  ]  ;15
                            
          negArrowCord = [ [-1,-1,-1,-1], $
                           [96,53,90,46], $  ;0 
                           [97,59,94,52], $  ;1
                           [93,58,92,50]  ]  ;2
                                 
          ;圈出磁场的圆坐标  [x0,y0,radius]
          posCircleCord = [ [74,51,5], $  
                            [77,35,8], $  ;0
                            [80,36,7], $  ;1
                            [81,35,8]  ]  ;2
                            
          negCircleCord = [ [67,56,7], $  
                            [51,48,8], $  ;0
                            [51,48,8], $  ;1
                            [53,49,8]  ]  ;2
          
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
            posCircleCord = [ [33,40,6],  $
                              [35,39,6],  $
                              [38,40,7]   ]
                              
            negCircleCord = [ [45,33,4],   $
                              [46,31,4],  $
                              [49,35,4]   ]
         end
    '3': begin
                        ;箭头的坐标 [x0,y0,x1,y1]
            posArrowCord = [ [-1,-1,-1,-1], $
                             [-1,-1,-1,-1], $
                             [-1,-1,-1,-1], $  ;1
                             [-1,-1,-1,-1]  ]  
                              
            negArrowCord = [ [-1,-1,-1,-1], $
                             [-1,-1,-1,-1], $
                             [-1,-1,-1,-1], $  ;1
                             [-1,-1,-1,-1]  ]  
                             
            ;圈出磁场的圆坐标  [x0,y0,radius]
            posCircleCord = [ [29,27,2],  $
                              [26,28,3],  $
                              [22,27,5],  $  
                              [15,28,5]   ]
                              
            negCircleCord = [ [36,21,4],  $
                              [33,24,6],  $
                              [36,24,7],  $
                              [24,29,6]   ]
         end          
    else: message,'No sucn choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetModelLables,nCase,xlabel=xlabel,ylabel=ylabel,xnolab=xnolab,ynolab=ynolab
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
          xlabel = ['310','320','330','340']            
          ylabel = ['-90','-80','-70','-60']
         end
    else: message,'No sucn choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetModelCoords,nCase,needArea,n,m,x0=x0,y0=y0,x1=x1,y1=y1, $
                        dx=dx,dy=dy,yy0=yy0,yy1=yy1,xx0=xx0,xx1=xx1, $
                        ix=ix,iy=iy
  ;n: 列数
  ;m: 行数
                      
  ;获得每个磁图上的自定义的坐标
  needArea = float(needArea)
  ix = 0.00 & iy = 0.00 ;图与图之间间隔 
  case nCase of 
    '1': begin  ;Emergence
          y0 = 0.96
          ;磁图（以y为主）
          diy = 0.18   ;曲线图和磁场图之间间隔
          biy = 0.19   ;底部间隔
          dy = (y0 - biy - diy - 2*iy) / m ;磁场图y方向的宽度           
          dx = (needArea[1] - needArea[0]) / (needArea[3] - needArea[2]) * dy  ;先通过图像比例计算
          dx *= !ps_y / !A4.x  ;再通过A4纸的大小转换一下
          yy1 = y0 - diy & yy0 = yy1 - dy
          xx0 = (1 - n * dx) / 2.  ;磁图的起始位置（每画一个就会更新）
          xx1 = xx0 + dx  ;磁图的结束位置（每画一个就会更新）
         end
    '2': begin  ;Convergence
          y0 = 0.99 
          ;磁图（以y为主）
          diy = 0.12   ;曲线图和磁场图之间间隔
          biy = 0.2   ;底部间隔
          dy = (y0 - biy - diy - 2*iy) / m ;磁场图y方向的宽度           
          dx = (needArea[1] - needArea[0]) / (needArea[3] - needArea[2]) * dy  ;先通过图像比例计算
          dx *= !ps_y / !A4.x  ;再通过A4纸的大小转换一下
          yy1 = y0 - diy & yy0 = yy1 - dy
          xx0 = (1 - n * dx) / 2.  ;磁图的起始位置（每画一个就会更新）
          xx1 = xx0 + dx  ;磁图的结束位置（每画一个就会更新）
         end
    '3': begin  ;Local Combination
          y0 = 0.96 
          ;磁图（以y为主）
          diy = 0.1   ;曲线图和磁场图之间间隔
          biy = 0.16   ;底部间隔
          dy = (y0 - biy - diy - 2*iy) / m ;磁场图y方向的宽度           
          dx = (needArea[1] - needArea[0]) / (needArea[3] - needArea[2]) * dy  ;先通过图像比例计算
          dx *= !ps_y / !ps_x  ;再通过A4纸的大小转换一下
          yy1 = y0 - diy & yy0 = yy1 - dy
          xx0 = (1 - n * dx) / 2.  ;磁图的起始位置（每画一个就会更新）
          xx1 = xx0 + dx  ;磁图的结束位置（每画一个就会更新）
         end
     else: message,'No sucn choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetAiaThresholdModel,nCase
  case nCase of  ;193
      '1': begin
            return,[-300.,0.]
           end
      '2': begin
            return,[-300.,0.]
           end
      '3': begin
            return,[-800.,-300.] ;180 20 
           end
      else: message,'No sucn choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetCalMagDisNum,nCase
  case nCase of  ;193
      '1': begin
            return,[2]
           end
      '2': begin
            return,[0,1,2]
           end
      '3': begin
            return,[0,1,2]
           end
      else: message,'No sucn choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetMovThreshold,areaNum
  case areaNum of 
    '1': begin
          return,[-300.,0.]
         end
    '42': begin
           return,[-250.,0.]
          end
    '19': begin
           return,[-200.,0.]
          end
    '22': begin
           return,[-180.,-10.]
          end
    else: message,'No such choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetModle1LCTimeRange,i
  ;LC:light curve
  ;要画在模型分析例子1上的AIA光变曲线小图的时间范围
  case i of 
    0: begin
        return,[' 1-Jan-2011 11:04:10.300', ' 1-Jan-2011 13:04:10.200']
       end
    1: begin
        return,[' 1-Jan-2011 12:04:10.200', ' 1-Jan-2011 15:04:10.100']
       end
    2: begin
        return,[' 1-Jan-2011 14:04:10.200', ' 1-Jan-2011 17:04:10.100']
       end
    else: message,'No such choice!'
  endcase   
END
;-----------------------------------------------------------------------------------------------------------------------------

Function papBPGetMovBeginNum,areaNum,arrTime
  ;有些动画不需要从头开始
  case areaNum of 
    '1': begin
          return,0
         end
    '42': begin
           return,0
          end
    '19': begin
           return,0
          end
    '22': begin
           beginTime = ' 1-Jan-2011 01:53:40.200'  ;这里用数组就会失败，只能用变量
           return,WhereEx(beginTime eq arrTime)
          end
    else: message,'No such choice!'
  endcase           
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO papBPGetArea,areaNum,newArea=newArea,boxArea=boxArea
  ;动画要和图像的显示范围一样
  oldArea = hmiGetBoxCoord(areaNum) ;[x0,x1,y0,y1]
  boxArea = intarr(4)
  case areaNum of  
    '1': begin
          newArea = [47,160,63,172]
         end
    '42': begin
           newArea = [6,65,5,63]                  
          end
    '19': begin
           newArea = [31,89,21,91]
          end
    '22': begin
           newArea = [27,86,30,99]
          end
    else: message,'No such choice!'
  endcase 
  boxArea[0] = oldArea[0] - newArea[0]
  boxArea[1] = boxArea[0] + oldArea[1] - oldArea[0]
  boxArea[2] = oldArea[2] - newArea[2]
  boxArea[3] = boxArea[2] + oldArea[3] - oldArea[2]          
END
;-----------------------------------------------------------------------------------------------------------------------------  