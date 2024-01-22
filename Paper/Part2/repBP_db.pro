PRO repBPGetXYoffset,areaNum,xcOffset=xcOffset,ycOffset=ycOffset
  ;图像修正时的参数
  case areaNum of 
    '1' : begin
            xcOffset = 2.5
            ycOffset = 2.5
          end
    else: message,'Wrong areaNum, my friend!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function repBPGetPeakTime,areaNum
  ;BP 达到峰值的时刻  in 211
  ;HMI的时间
  case areaNum of  ;pix
    '1':begin    
          return,' 1-Jan-2011 21:20:40.100'
        end 
    '2':begin
          return,' 2-Jan-2011 13:36:25.200'
        end
    '3':begin
          return,' 2-Jan-2011 15:15:25.100'
        end
    '4':begin
          return,' 2-Jan-2011 23:24:25.100'
        end
    '5':begin
          return,' 1-Jan-2011 11:25:10.200'
        end
    '6':begin
          return,' 1-Jan-2011 16:29:40.100'
        end
    '7':begin
          return,' 2-Jan-2011 07:44:40.300'
        end  
    '8':begin
          return,' 2-Jan-2011 09:40:10.300'
        end
    '9':begin
          return,' 3-Jan-2011 12:19:10.200'  
        end
   '10':begin
          return,' 2-Jan-2011 05:31:10.300'
        end
   '11':begin
          return,' 2-Jan-2011 04:17:40.300'  
        end
   '12':begin
          return,' 2-Jan-2011 18:34:10.100'  
        end
   '13':begin
          return,' 1-Jan-2011 09:08:40.300'  
        end
   '14':begin
          return,' 2-Jan-2011 00:25:10.200'  
        end
   '15':begin
          return,' 2-Jan-2011 07:44:40.300'  
        end
   '16':begin
          return,' 2-Jan-2011 19:40:10.100'               
        end
   '17':begin
          return,' 2-Jan-2011 21:24:25.100'  
        end
   '18':begin
          return,' 3-Jan-2011 00:29:40.200'  
        end
   '19':begin
          return,' 3-Jan-2011 00:49:10.200'  
        end
   '20':begin
          return,' 2-Jan-2011 22:34:10.100'  
        end
   '21':begin
          return,' 1-Jan-2011 04:56:40.300'              
        end 
   '22':begin
          return,' 1-Jan-2011 08:46:10.300'
        end 
   '23':begin
          return,' 2-Jan-2011 20:39:25.100'  
        end 
   '24':begin
          return,' 2-Jan-2011 22:29:40.100'  
        end 
   '25':begin
          return,' 2-Jan-2011 21:54:25.100'                    
        end 
   '26':begin
          return,' 1-Jan-2011 18:54:25.100'  
        end 
   '27':begin
          return,' 1-Jan-2011 19:39:25.100'  
        end
   '28':begin
          return,' 2-Jan-2011 21:55:10.100'  
        end 
   '29':begin
          return,' 2-Jan-2011 14:10:10.200'  
        end 
   '30':begin
          return,' 3-Jan-2011 06:49:10.300'  
        end 
   '31':begin
          return,' 3-Jan-2011 03:30:25.200'  
        end 
   '32':begin
          return,' 3-Jan-2011 12:04:10.200'  
        end 
   '33':begin
          return,' 1-Jan-2011 10:23:40.200'  
        end
   '34':begin
          return,' 1-Jan-2011 09:13:10.300'  
        end
   '35':begin
          return,' 2-Jan-2011 12:15:25.200'  
        end 
   '36':begin
          return,' 2-Jan-2011 08:35:40.300'  
        end 
   '37':begin
          return,' 2-Jan-2011 02:30:25.200'  
        end 
   '38':begin
          return,' 1-Jan-2011 14:58:10.100'  
        end 
   '39':begin
          return,' 1-Jan-2011 18:49:10.100'  
        end 
   '40':begin
          return,' 3-Jan-2011 17:34:10.100'  
        end 
   '41':begin
          return,' 2-Jan-2011 22:34:10.100'  
        end
   '42':begin
          return,' 3-Jan-2011 00:09:25.200'  
        end 
   '43':begin
          return,' 1-Jan-2011 08:23:40.300'  
        end 
   '44':begin
          return,' 2-Jan-2011 11:25:10.200'  
        end 
   '45':begin
          return,' 1-Jan-2011 11:03:25.200'  
        end 
   '46':begin
          return,' 2-Jan-2011 21:14:40.100'  
        end 
   '47':begin
          return,' 3-Jan-2011 09:24:25.300'  
        end  
   '48':begin
          return,' 1-Jan-2011 14:38:40.200'  
        end 
   '49':begin
          return,' 1-Jan-2011 10:48:25.200'  
        end 
   '50':begin
          return,' 1-Jan-2011 07:39:25.300'  
        end
   '51':begin
          return,' 1-Jan-2011 12:33:25.200'  
        end 
   '52':begin
          return,' 2-Jan-2011 01:10:10.200'  
        end 
   '53':begin
          return,' 1-Jan-2011 21:29:40.100'
        end 
   '54':begin
          return,' 2-Jan-2011 09:17:40.300'  
        end
   '55':begin
          return,' 2-Jan-2011 11:00:25.200'  
        end 
   '56':begin
          return,' 2-Jan-2011 14:04:10.200'  
        end 
   '57':begin
          return,' 2-Jan-2011 23:54:25.200'  
        end 
   '58':begin
          return,' 2-Jan-2011 19:39:25.100'  
        end 
   '59':begin
          return,' 3-Jan-2011 11:04:10.200'  
        end 
   '60':begin
          return,' 3-Jan-2011 08:46:10.300'  
        end
   '61':begin
          return,' 2-Jan-2011 07:10:10.300'  
        end 
   '62':begin
          return,' 1-Jan-2011 12:10:10.200'  
        end 
   '63':begin
          return,' 1-Jan-2011 05:29:40.300'  
        end 
   '64':begin
          return,' 1-Jan-2011 15:19:10.100'  
        end
   '65':begin
          return,' 1-Jan-2011 17:44:40.100'  
        end 
   '66':begin
          return,' 2-Jan-2011 09:04:10.300'  
        end 
   '67':begin
          return,' 1-Jan-2011 23:00:25.100'  
        end 
   '68':begin
          return,' 3-Jan-2011 03:29:40.200'  
        end 
   '69':begin
          return,' 2-Jan-2011 23:29:40.200'  
        end
   '70':begin
          return,' 2-Jan-2011 04:20:40.300'  
        end
   else:message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function repBPGetDistLineNumCord,eventNum
  ;Magnetic Formation 中的Emergence、 Convergence 和  Local coalescence的距离变化中线对应的事件编号坐标
  case eventNum of 
    ;Emergence
    '1' : return,[1.61,5.0]  ;0
    '4' : return,[0.72,13.30] ;1
    '5' : return,[1.25,5.90] ;2
    '6' : return,[1.6,4.28] ;3
    '7' : return,[0.82,9.71] ;4
    '8' : return,[0.60,4.06] ;5
    '11' : return,[1.32,6.75] ;6
    '12' : return,[2.28,17.72] ;7
    '14' : return,[1.65,5.90] ;8
    '15' : return,[0.91,9.26] ;9
    '16' : return,[2.33,16.86] ;10
    '18' : return,[1.47,3.34] ;11
    '21' : return,[0.64,11.08] ;12
    '22' : return,[1.5,-0.1] ;13
    '23' : return,[2.30,10.12] ;14
    '24' : return,[2.14,11.55] ;15
    '25' : return,[2.10,3.17] ;16
    '30' : return,[1.37,12.80] ;17
    '32' : return,[0.55,3.45] ;18
    '34' : return,[2.26,2.79] ;19
    '37' : return,[1.23,3.22] ;20
    '41' : return,[1.29,1.91] ;21
    '44' : return,[1.87,3.39] ;22
    '45' : return,[0.58,9.60] ;23
    '50' : return,[2.28,10.86] ;24
    '51' : return,[0.76,11.65] ;25
    '52' : return,[0.90,11.80] ;26
    '54' : return,[2.27,8.89] ;27
    '55' : return,[1.70,3.55] ;28
    '57' : return,[1.73,3.01] ;29
    '58' : return,[2.16,6.77] ;30
    '60' : return,[0.92,16.45] ;31
    '67' : return,[2.13,4.82] ;32
    '69' : return,[2.35,21.68] ;33
    '36' : return,[1.5,18.99]  ;34
    ;Convergence  
    '10' : return,[4.16,13.88]  ;0
    '40' : return,[4.60,14.60]  ;1
    '42' : return,[4.57,3.31]  ;2
    '64' : return,[4.80,5.70]  ;3
    '70' : return,[4.34,24.27]  ;4
    ;Local Coalescence
    '19' : return,[7.5,14.8]
    '26' : return,[7.35,8.5]
    '29' : return,[7.5,16.5]
    '31' : return,[7.5,13.0]
    '38' : return,[7.5,10.3]
    '48' : return,[7.5,8.8]
    else : message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------
