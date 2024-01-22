;+===========================annotation--begin===================================================
; :Prototype:
;    hmiBP_db
; :Purpose:
;    提供各种具体的数据参数
;    
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

Function aiaGetThreshold,waveLen
  case waveLen of 
    '211': begin
              return,[10.,200.]
           end
    '193': begin
              return,[10.,500.]
           end
    else: message,'Wavelength is not found!'
  endcase  
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO hmiGetEvtNum,date,areaNum,beginNum=beginNum,refNum=refNum,endNum=endNum
  ;获得每个事件的起始文件编号和结束文件编号，对应相应的时间
  case date of
    '2010.12.31_2011.01.03_full':begin
                                  case areaNum of               ;hmi->date & time
                                    '1':begin                          
                                          beginNum = 0          ;2010-12-31 12:00:45  
                                          refNum = 720          ;2011-01-01 00:00:45
                                          endNum = 2959         ;2011-01-02 13:19:35
                                        end
                                    '2':begin
                                          beginNum = 1261       ;2011-01-01 09:01:30
                                          refNum = 1981         ;2011-01-01 21:01:30
                                          endNum = 5038         ;2011-01-03 23:58:30                          
                                        end
                                    '3':begin ;原'5'
                                          beginNum = 660        ;2010-12-31 23:00:45
                                          refNum = 1380         ;2011-01-01 11:00:45
                                          endNum = 4879         ;2011-01-03 21:19:30
                                        end
                                    '4':begin
                                          beginNum = 2500       ;2011-01-02 05:40:30
                                          refNum = 3220         ;2011-01-02 17:40:30
                                          endNum = 4140         ;2011-01-03 09:00:45
                                        end
                                    '5':begin
                                          beginNum = 529        ;2010-12-31 20:49:30
                                          refNum = 1249         ;2011-01-01 08:49:30
                                          endNum = 2170         ;2011-01-02 00:10:30
                                        end
                                    '6':begin
                                          beginNum = 709        ;2010-12-31 23:49:30
                                          refNum = 1429         ;2011-01-01 11:49:30
                                          endNum = 2150         ;2011-01-02 23:50:15
                                        end
                                    '7':begin
                                          beginNum = 889        ;2011-01-01 02:49:30
                                          refNum = 1609         ;2011-01-01 14:49:30
                                          endNum = 3290         ;2011-01-02 18:50:15
                                        end
                                    '8':begin
                                          beginNum = 1120       ;2011-01-01 08:20:15
                                          refNum = 1940         ;2011-01-01 20:20:15
                                          endNum = 3160         ;2011-01-02 16:40:30
                                        end
                                    '9':begin
                                          beginNum = 2770       ;2011-01-02 10:10:30
                                          refNum = 3490         ;2011-01-02 22:10:30
                                          endNum = 5039         ;2011-01-03 23:59:15
                                        end
                                   '10':begin
                                          beginNum = 889        ;2011-01-01 02:49:30
                                          refNum = 1609         ;2011-01-01 14:49:30
                                          endNum = 2590         ;2011-01-02 07:10:30
                                        end
                                   '11':begin
                                          beginNum = 1060       ;2011-01-01 05:40:30
                                          refNum = 1780         ;2011-01-01 17:40:30
                                          endNum = 2910         ;2011-01-02 12:30:45
                                        end
                                   '12':begin
                                          beginNum = 1880       ;2011-01-01 19:20:15
                                          refNum = 2600         ;2011-01-02 07:20:15
                                          endNum = 3940         ;2011-01-03 05:40:30
                                        end
                                   '13':begin
                                          beginNum = 169        ;2010-12-31 14:49:30
                                          refNum = 889          ;2011-01-01 02:49:30
                                          endNum = 1770         ;2011-01-01 17:30:45
                                        end
                                   '14':begin
                                          beginNum = 990        ;2011-01-01 04:30:45
                                          refNum = 1710         ;2011-01-01 16:30:45
                                          endNum = 2850         ;2011-01-02 11:30:45
                                        end
                                   '15':begin
                                          beginNum = 889        ;2011-01-01 02:49:30
                                          refNum = 1609         ;2011-01-01 14:49:30
                                          endNum = 3370         ;2011-01-02 20:10:30
                                        end
                                   '16':begin
                                          beginNum = 1210       ;2011-01-01 08:10:30
                                          refNum = 1930         ;2011-01-01 20:10:30
                                          endNum = 4090         ;2011-01-03 08:10:30
                                        end
                                   '17':begin
                                          beginNum = 2400       ;2011-01-02 04:00:45
                                          refNum = 3120         ;2011-01-02 16:00:45
                                          endNum = 3680         ;2011-01-03 01:20:15
                                        end
                                   '18':begin
                                          beginNum = 1880       ;2011-01-01 19:20:15
                                          refNum = 2600         ;2011-01-02 07:20:15
                                          endNum = 4150         ;2011-01-03 09:10:30
                                        end
                                   '19':begin
                                          beginNum = 2360       ;2011-01-02 03:20:15
                                          refNum = 3080         ;2011-01-02 15:20:15
                                          endNum = 4140         ;2011-01-03 09:00:45
                                        end
                                   '20':begin
                                          beginNum = 2120       ;2011-01-01 23:20:15
                                          refNum = 2840         ;2011-01-02 11:20:15
                                          endNum = 3830         ;2011-01-03 03:50:15
                                        end
                                   '21':begin
                                          beginNum = 0          ;2010-12-31 12:00:45 ;(lt 12h)
                                          refNum = 619          ;2010-12-31 22:19:30
                                          endNum = 2130         ;2011-01-01 23:30:45
                                        end 
                                   '22':begin
                                          beginNum = 129        ;2010-12-31 14:09:45 
                                          refNum = 849          ;2011-01-01 02:09:45
                                          endNum = 1339         ;2011-01-01 10:19:30
                                        end 
                                   '23':begin
                                          beginNum = 2250       ;2011-01-02 01:30:45 
                                          refNum = 2970         ;2011-01-02 13:30:45
                                          endNum = 4000         ;2011-01-03 06:40:30
                                        end 
                                   '24':begin
                                          beginNum = 2540       ;2011-01-02 06:20:15 
                                          refNum = 3260         ;2011-01-02 18:20:15
                                          endNum = 4050         ;2011-01-03 07:30:45
                                        end 
                                   '25':begin
                                          beginNum = 2520       ;2011-01-02 06:00:45 
                                          refNum = 3240         ;2011-01-02 18:00:45
                                          endNum = 4320         ;2011-01-03 12:00:45
                                        end 
                                   '26':begin
                                          beginNum = 229        ;2010-12-31 15:49:30 
                                          refNum = 949          ;2011-01-01 03:49:30
                                          endNum = 2210         ;2011-01-02 00:50:15
                                        end 
                                   '27':begin
                                          beginNum = 929        ;2011-01-01 03:29:15 
                                          refNum = 1649         ;2011-01-01 15:29:15
                                          endNum = 2180         ;2011-01-02 00:20:15
                                        end
                                   '28':begin
                                          beginNum = 2550       ;2011-01-02 06:30:45 
                                          refNum = 3270         ;2011-01-02 18:30:45
                                          endNum = 3840         ;2011-01-03 04:00:45
                                        end 
                                   '29':begin
                                          beginNum = 1600       ;2011-01-01 14:40:30 
                                          refNum = 2320         ;2011-01-02 02:40:30
                                          endNum = 3350         ;2011-01-02 19:50:15
                                        end 
                                   '30':begin
                                          beginNum = 2660       ;2011-01-02 08:20:15 
                                          refNum = 3380         ;2011-01-02 20:20:15
                                          endNum = 4620         ;2011-01-03 17:00:45
                                        end 
                                   '31':begin
                                          beginNum = 2810       ;2011-01-02 10:50:15 
                                          refNum = 3530         ;2011-01-02 22:50:15
                                          endNum = 4160         ;2011-01-03 09:20:15
                                        end 
                                   '32':begin
                                          beginNum = 3050       ;2011-01-02 14:50:15 
                                          refNum = 3770         ;2011-01-03 02:50:15
                                          endNum = 4530         ;2011-01-03 15:30:45
                                        end 
                                   '33':begin
                                          beginNum = 89         ;2010-12-31 13:29:15 
                                          refNum = 809          ;2011-01-01 01:29:15
                                          endNum = 1960         ;2011-01-01 20:40:30
                                        end
                                   '34':begin
                                          beginNum = 469        ;2010-12-31 19:49:30 
                                          refNum = 1189         ;2011-01-01 07:49:30
                                          endNum = 1580         ;2011-01-01 14:29:15
                                        end
                                   '35':begin
                                          beginNum = 1120       ;2011-01-01 06:40:30 
                                          refNum = 1840         ;2011-01-01 18:40:30
                                          endNum = 3700         ;2011-01-03 01:40:30
                                        end 
                                   '36':begin
                                          beginNum = 1340       ;2011-01-01 10:20:15 
                                          refNum = 2060         ;2011-01-01 22:20:15
                                          endNum = 3980         ;2011-01-03 06:20:15
                                        end 
                                   '37':begin
                                          beginNum = 1060       ;2011-01-01 05:40:30 
                                          refNum = 1780         ;2011-01-01 17:40:30
                                          endNum = 2840         ;2011-01-02 11:20:15
                                        end 
                                   '38':begin
                                          beginNum = 579        ;2010-12-31 21:39:45 
                                          refNum = 1299         ;2011-01-01 09:39:45
                                          endNum = 2030         ;2011-01-01 21:50:15
                                        end 
                                   '39':begin
                                          beginNum = 449        ;2010-12-31 19:29:15 
                                          refNum = 1169         ;2011-01-01 07:29:15
                                          endNum = 3810         ;2011-01-03 03:30:45
                                        end 
                                   '40':begin
                                          beginNum = 3510       ;2011-01-02 22:30:45 
                                          refNum = 4230         ;2011-01-03 10:30:45
                                          endNum = 5039         ;2011-01-03 23:59:15
                                        end 
                                   '41':begin
                                          beginNum = 2120       ;2011-01-01 23:20:15
                                          refNum = 2840         ;2011-01-02 11:20:15
                                          endNum = 4620         ;2011-01-03 17:00:45
                                        end
                                   '42':begin
                                          beginNum = 2520       ;2011-01-02 06:00:45
                                          refNum = 3240         ;2011-01-02 18:00:45
                                          endNum = 4040         ;2011-01-03 07:20:15
                                        end 
                                   '43':begin
                                          beginNum = 299        ;2010-12-31 16:59:15
                                          refNum = 1019         ;2011-01-01 04:59:15
                                          endNum = 1750         ;2011-01-01 17:10:30                                    
                                        end 
                                   '44':begin
                                          beginNum = 1500       ;2011-01-01 13:00:45
                                          refNum = 2220         ;2011-01-02 01:00:45
                                          endNum = 3340         ;2011-01-02 19:40:30                                   
                                        end 
                                   '45':begin
                                          beginNum = 9          ;2010-12-31 12:09:45
                                          refNum = 729          ;2011-01-01 00:09:45
                                          endNum = 2120         ;2011-01-01 23:20:15
                                        end 
                                   '46':begin
                                          beginNum = 2450       ;2011-01-02 04:50:15
                                          refNum = 3170         ;2011-01-02 16:50:15
                                          endNum = 3720         ;2011-01-03 02:00:45                                    
                                        end 
                                   '47':begin
                                          beginNum = 3360       ;2011-01-02 20:00:45
                                          refNum = 4080         ;2011-01-03 08:00:45
                                          endNum = 4370         ;2011-01-03 12:50:15                                    
                                        end  
                                   '48':begin
                                          beginNum = 489        ;2010-12-31 20:09:45
                                          refNum = 1209         ;2011-01-01 08:09:45
                                          endNum = 1850         ;2011-01-01 18:50:15                                    
                                        end 
                                   '49':begin
                                          beginNum = 529        ;2010-12-31 20:49:30
                                          refNum = 1249         ;2011-01-01 08:49:30
                                          endNum = 2270         ;2011-01-02 01:50:15                                    
                                        end 
                                   '50':begin
                                          beginNum = 0          ;2010-12-31 12:00:45  ;(lt 12h)
                                          refNum = 529          ;2010-12-31 20:49:30
                                          endNum = 1940         ;2011-01-01 20:20:15
                                        end
                                   '51':begin
                                          beginNum = 119        ;2010-12-31 13:59:15
                                          refNum = 839          ;2011-01-01 01:59:15
                                          endNum = 1780         ;2011-01-01 17:40:30                                    
                                        end 
                                   '52':begin
                                          beginNum = 0          ;2010-12-31 12:00:45  ;(lt 12h)
                                          refNum = 679          ;2010-12-31 23:19:30
                                          endNum = 3210         ;2011-01-02 17:30:45
                                        end 
                                   '53':begin
                                          beginNum = 899        ;2011-01-01 02:59:15
                                          refNum = 1619         ;2011-01-01 14:59:15
                                          endNum = 2260         ;2011-01-02 01:40:30
                                        end 
                                   '54':begin
                                          beginNum = 1920       ;2011-01-01 20:00:45
                                          refNum = 2640         ;2011-01-02 08:00:45
                                          endNum = 3050         ;2011-01-02 14:50:15                                    
                                        end
                                   '55':begin
                                          beginNum = 1930       ;2011-01-01 20:10:30
                                          refNum = 2650         ;2011-01-02 08:10:30
                                          endNum = 3000         ;2011-01-02 14:00:45                                       
                                        end 
                                   '56':begin
                                          beginNum = 2260       ;2011-01-02 01:40:30
                                          refNum = 2980         ;2011-01-02 13:40:30
                                          endNum = 3220         ;2011-01-02 17:40:30                                    
                                        end 
                                   '57':begin
                                          beginNum = 2170       ;2011-01-02 00:10:30
                                          refNum = 2890         ;2011-01-02 12:10:30
                                          endNum = 4490         ;2011-01-03 14:50:15                                    
                                        end 
                                   '58':begin
                                          beginNum = 2190       ;2011-01-02 00:30:45
                                          refNum = 2910         ;2011-01-02 12:30:45
                                          endNum = 3690         ;2011-01-03 01:30:45
                                        end 
                                   '59':begin
                                          beginNum = 3220       ;2011-01-02 17:40:30
                                          refNum = 3940         ;2011-01-03 05:40:30
                                          endNum = 4840         ;2011-01-03 20:40:30                                    
                                        end 
                                   '60':begin
                                          beginNum = 2490       ;2011-01-02 05:30:45
                                          refNum = 3210         ;2011-01-02 17:30:45
                                          endNum = 4680         ;2011-01-03 18:00:45                                        
                                        end
                                   '61':begin
                                          beginNum = 1380       ;2011-01-01 11:00:45
                                          refNum = 2100         ;2011-01-01 23:00:45
                                          endNum = 3570         ;2011-01-02 23:30:45                                    
                                        end 
                                   '62':begin
                                          beginNum = 649        ;2010-12-31 22:49:30
                                          refNum = 1369         ;2011-01-01 10:49:30
                                          endNum = 1499         ;2011-01-01 12:59:15
                                        end 
                                   '63':begin
                                          beginNum = 0          ;2010-12-31 12:00:45  ;(lt 12h)
                                          refNum = 619          ;2010-12-31 22:19:30
                                          endNum = 1449         ;2011-01-01 12:09:45                                    
                                        end 
                                   '64':begin
                                          beginNum = 719        ;2010-12-31 23:59:15
                                          refNum = 1439         ;2011-01-01 11:59:15
                                          endNum = 1670         ;2011-01-01 15:50:15                                    
                                        end
                                   '65':begin
                                          beginNum = 629        ;2010-12-31 22:29:15
                                          refNum = 1349         ;2011-01-01 10:29:15
                                          endNum = 2120         ;2011-01-01 23:20:15                                    
                                        end 
                                   '66':begin
                                          beginNum = 349        ;2010-12-31 17:49:30
                                          refNum = 1069         ;2011-01-01 05:49:30
                                          endNum = 2800         ;2011-01-02 10:40:30                                    
                                        end 
                                   '67':begin
                                          beginNum = 1050       ;2011-01-01 05:30:45
                                          refNum = 1770         ;2011-01-01 17:30:45
                                          endNum = 3010         ;2011-01-02 14:10:30                                    
                                        end 
                                   '68':begin
                                          beginNum = 1710       ;2011-01-01 16:30:45
                                          refNum = 2430         ;2011-01-02 04:30:45
                                          endNum = 3850         ;2011-01-03 04:10:30                                    
                                        end 
                                   '69':begin
                                          beginNum = 2520       ;2011-01-02 06:00:45
                                          refNum = 3240         ;2011-01-02 18:00:45
                                          endNum = 3930         ;2011-01-03 05:30:45                                    
                                        end
                                   '70':begin
                                          beginNum = 1280       ;2011-01-01 09:20:15
                                          refNum = 2000         ;2011-01-01 21:20:15
                                          endNum = 3020         ;2011-01-02 14:20:15                                    
                                        end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                   else:message,'No such areaNum: ' + areaNum
                                  endcase
                                 end
                       else:message,'invalid date!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function hmiGetBoxCoord,areaNum
  ;筛选出需要的区域来
  case areaNum of  ;pix
    '1':begin    ;x0 x1  y0 y1
          return,[62,160,83,172] 
        end 
    '2':begin
          return,[24,125,58,136]  
        end
    '3':begin
          return,[45,146,40,111]  
        end
    '4':begin
          return,[51,103,23,70]   
        end
    '5':begin
          return,[39,91,17,61] 
        end
    '6':begin
          return,[13,58,22,68]
        end
    '7':begin
          return,[32,85,27,87]
        end  
    '8':begin
          return,[28,72,29,71]
        end
    '9':begin
          return,[14,77,29,88]
        end
   '10':begin
          return,[18,68,23,76]
        end
   '11':begin
          return,[15,71,15,69]
        end
   '12':begin
          return,[22,123,31,124]
        end
   '13':begin
          return,[19,62,21,59]
        end
   '14':begin
          return,[24,78,23,71]
        end
   '15':begin
          return,[19,72,24,80]
        end
   '16':begin
          return,[33,95,32,125]
        end
   '17':begin
          return,[19,52,18,50]
        end
   '18':begin
          return,[45,91,31,83]
        end
   '19':begin
          return,[36,89,31,81]
        end
   '20':begin
          return,[25,78,22,64]
        end
   '21':begin
          return,[19,72,26,84]
        end 
   '22':begin
          return,[27,71,35,69]
        end 
   '23':begin
          return,[30,85,23,78]
        end 
   '24':begin
          return,[23,79,31,84]
        end 
   '25':begin
          return,[47,97,47,99]
        end 
   '26':begin
          return,[28,82,39,83]
        end 
   '27':begin
          return,[30,87,31,76]
        end
   '28':begin
          return,[26,72,36,79]
        end 
   '29':begin
          return,[48,140,57,121]
        end 
   '30':begin
          return,[34,102,40,96]
        end 
   '31':begin
          return,[25,69,31,73]
        end 
   '32':begin
          return,[29,86,30,74]
        end 
   '33':begin
          return,[24,69,31,72]
        end
   '34':begin
          return,[19,51,25,55] 
        end
   '35':begin
          return,[33,89,33,81]
        end 
   '36':begin
          return,[42,111,26,86]
        end 
   '37':begin
          return,[19,70,25,65]
        end 
   '38':begin
          return,[26,63,30,67]
        end 
   '39':begin
          return,[42,113,39,99]
        end 
   '40':begin
          return,[21,77,30,71]
        end 
   '41':begin
          return,[41,103,34,88]
        end
   '42':begin
          return,[31,65,25,53]
        end 
   '43':begin
          return,[29,71,33,63]
        end 
   '44':begin
          return,[23,70,37,72]
        end 
   '45':begin
          return,[13,59,32,71]
        end 
   '46':begin
          return,[31,70,36,70]
        end 
   '47':begin
          return,[24,72,35,74]
        end  
   '48':begin
          return,[26,74,35,71] 
        end 
   '49':begin
          return,[23,75,28,79]
        end 
   '50':begin
          return,[36,110,33,95]
        end
   '51':begin
          return,[23,76,27,78]
        end 
   '52':begin
          return,[37,112,31,91]
        end 
   '53':begin
          return,[17,65,38,72]
        end 
   '54':begin
          return,[25,65,30,61]
        end
   '55':begin
          return,[22,74,32,71]
        end 
   '56':begin
          return,[22,54,39,68]
        end 
   '57':begin
          return,[40,111,35,105]
        end 
   '58':begin
          return,[28,63,25,62]
        end 
   '59':begin
          return,[40,85,37,84]
        end 
   '60':begin
          return,[58,113,48,117]
        end
   '61':begin
          return,[37,91,40,84]
        end 
   '62':begin
          return,[20,48,25,50]
        end 
   '63':begin
          return,[37,75,27,68]
        end 
   '64':begin
          return,[23,52,14,40]
        end
   '65':begin
          return,[21,66,36,69]
        end 
   '66':begin
          return,[31,69,28,72]
        end 
   '67':begin
          return,[23,78,36,78]
        end 
   '68':begin
          return,[28,89,44,88]
        end 
   '69':begin
          return,[41,100,40,84]
        end
   '70':begin
          return,[32,85,38,80]
        end                 
   else:message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function hmiGetLoopCoord,areaNum
;环底，环顶的坐标
  case areaNum of  ;pix
    '1':begin      ;x0 x1  y0 y1
          return,[ [80,88,114,122] , $  ;环底1（左）
                   [110,118,89,97] , $  ;环底2（右）
                   [96,104,100,108]  ]  ;环顶
        end
    '19':begin
           return,[ [48,52,68,73],   $
                    [58,62,43,48],   $
                    [64,68,50,55]    ]
         end
    '42':begin
          return,[ [32,36,44,48],    $
                   [46,50,32,36],    $
                   [40,44,38,42]     ]
         end
        else:message,'No such choice!'
  endcase 
END
;-----------------------------------------------------------------------------------------------------------------------------

Function hmiGetLoopTimeRange,areaNum
;环底、环顶的时间范围
  case areaNum of 
    '1':begin      ;以AIA为准
          return,['31-Dec-2010 22:35:07.840' ,' 1-Jan-2011 21:05:07.840'] 
        end
    '19':begin
          return,[' 2-Jan-2011 15:00:07.840' ,' 3-Jan-2011 03:15:07.840']
         end
    '42':begin
          return,[' 2-Jan-2011 21:40:07.840' ,' 3-Jan-2011 02:40:07.840']
         end
   else:message,'No such choice!'
  endcase 
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO hmiGetFittingTimeRange,areaNum,emergPosRange=emergPosRange,emergNegRange=emergNegRange, $
                           cancelPosRange=cancelPosRange,cancelNegRange=cancelNegRange
  ;以HMI的时间为准
  case areaNum of  
    '1': begin    
           emergPosRange = ['31-Dec-2010 22:14',' 1-Jan-2011 10:54']
           emergNegRange = ['31-Dec-2010 20:59',' 1-Jan-2011 14:54']
           cancelPosRange = [' 1-Jan-2011 10:54','Last']
           cancelNegRange = [' 1-Jan-2011 14:54','Last']
         end 
    else: message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function hmiBPGetBeginTime,areaNum
  ;BP刚开始出现的时刻, BP 达到峰值的时刻  
  ;HMI的时间
  case areaNum of  ;pix
    '1':begin    
          return,['0', $  ;1-Jan-2011 00:04:10.200
                  ' 1-Jan-2011 21:20:40.100' ]
        end 
    '2':begin
          return,[' 1-Jan-2011 22:26:40.100', $
                  ' 2-Jan-2011 13:36:25.200'  ]
        end
    '3':begin
          return,[' 1-Jan-2011 10:29:40.200', $
                  ' 2-Jan-2011 15:15:25.100'  ]
        end
    '4':begin
          return,[' 2-Jan-2011 18:09:25.100', $
                  ' 2-Jan-2011 23:24:25.100'  ]
        end
    '5':begin
          return,[' 1-Jan-2011 07:03:25.300', $
                  ' 1-Jan-2011 11:25:10.200'  ]
        end
    '6':begin
          return,[' 1-Jan-2011 11:53:40.200', $
                  ' 1-Jan-2011 16:29:40.100'  ]
        end
    '7':begin
          return,[' 1-Jan-2011 14:43:10.200', $
                  ' 2-Jan-2011 07:44:40.300'  ]
        end  
    '8':begin
          return,[' 1-Jan-2011 20:00:25.100', $
                  ' 2-Jan-2011 09:40:10.300'  ]
        end
    '9':begin
          return,[' 2-Jan-2011 21:39:25.100', $
                  ' 3-Jan-2011 12:19:10.200'  ]
        end
   '10':begin
          return,[' 1-Jan-2011 14:58:10.100', $
                  '0' ] ;2-Jan-2011 05:31:10.300
        end
   '11':begin
          return,[' 1-Jan-2011 11:24:25.200', $
                  ' 2-Jan-2011 04:17:40.300'  ]
        end
   '12':begin
          return,[' 2-Jan-2011 04:04:10.300', $
                  ' 2-Jan-2011 18:34:10.100'  ]
        end
   '13':begin
          return,['31-Dec-2010 23:48:25.200', $
                  ' 1-Jan-2011 09:08:40.300'  ]
        end
   '14':begin
          return,[' 1-Jan-2011 16:25:10.100', $
                  ' 2-Jan-2011 00:25:10.200'  ]
        end
   '15':begin
          return,[' 1-Jan-2011 14:58:10.100', $
                  ' 2-Jan-2011 07:44:40.300'  ]
        end
   '16':begin
          return,['0', $ ;1-Jan-2011 20:15:25.100
                  ' 2-Jan-2011 19:40:10.100'  ]             
        end
   '17':begin
          return,[' 2-Jan-2011 11:54:25.200', $
                  ' 2-Jan-2011 21:24:25.100'  ]
        end
   '18':begin
          return,['0', $ ;2-Jan-2011 06:44:40.300
                  ' 3-Jan-2011 00:29:40.200'  ]
        end
   '19':begin
          return,[' 2-Jan-2011 12:54:25.200', $
                  ' 3-Jan-2011 00:49:10.200'  ]
        end
   '20':begin
          return,[' 2-Jan-2011 10:14:40.300', $
                  ' 2-Jan-2011 22:34:10.100'  ]
        end
   '21':begin
          return,['31-Dec-2010 22:10:10.100', $
                  ' 1-Jan-2011 04:56:40.300'  ]            
        end 
   '22':begin
          return,['0', $  ;1-Jan-2011 02:12:25.200 
                  '0'  ]  ;1-Jan-2011 08:46:10.300
        end 
   '23':begin
          return,['0', $  ;2-Jan-2011 11:19:10.200
                  ' 2-Jan-2011 20:39:25.100'  ]
        end 
   '24':begin
          return,['0', $  ;2-Jan-2011 17:09:25.100
                  ' 2-Jan-2011 22:29:40.100'  ]
        end 
   '25':begin
          return,['0', $  ;2-Jan-2011 17:59:40.100
                  ' 2-Jan-2011 21:54:25.100'  ]                  
        end 
   '26':begin
          return,[' 1-Jan-2011 03:08:40.200', $
                  ' 1-Jan-2011 18:54:25.100'  ]
        end 
   '27':begin
          return,[' 1-Jan-2011 11:18:25.200', $
                  ' 1-Jan-2011 19:39:25.100'  ]
        end
   '28':begin
          return,[' 2-Jan-2011 15:28:10.100', $
                  ' 2-Jan-2011 21:55:10.100'  ]
        end 
   '29':begin
          return,[' 1-Jan-2011 23:10:10.100', $
                  ' 2-Jan-2011 14:10:10.200'  ]
        end 
   '30':begin
          return,[' 2-Jan-2011 19:34:10.100', $
                  ' 3-Jan-2011 06:49:10.300'  ]
        end 
   '31':begin
          return,[' 2-Jan-2011 21:35:40.100', $
                  ' 3-Jan-2011 03:30:25.200'  ]
        end 
   '32':begin
          return,[' 3-Jan-2011 00:59:40.200', $
                  ' 3-Jan-2011 12:04:10.200'  ]
        end 
   '33':begin
          return,['31-Dec-2010 21:58:10.100', $
                  ' 1-Jan-2011 10:23:40.200'  ]
        end
   '34':begin
          return,[' 1-Jan-2011 07:48:25.300', $
                  ' 1-Jan-2011 09:13:10.300'  ]
        end
   '35':begin
          return,[' 1-Jan-2011 16:00:25.100', $
                  ' 2-Jan-2011 12:15:25.200'  ]
        end 
   '36':begin
          return,[' 2-Jan-2011 00:25:10.200', $
                  ' 2-Jan-2011 08:35:40.300'  ]
        end 
   '37':begin
          return,['0', $ ;1-Jan-2011 17:35:40.100
                  ' 2-Jan-2011 02:30:25.200'  ]
        end 
   '38':begin
          return,[' 1-Jan-2011 08:48:25.300', $
                  ' 1-Jan-2011 14:58:10.100'  ]
        end 
   '39':begin
          return,['0', $  ;1-Jan-2011 00:43:10.200
                  ' 1-Jan-2011 18:49:10.100'  ]
        end 
   '40':begin
          return,[' 3-Jan-2011 08:24:25.300', $
                  ' 3-Jan-2011 17:34:10.100'  ]
        end 
   '41':begin
          return,['0', $  ;2-Jan-2011 10:49:10.200
                  ' 2-Jan-2011 22:34:10.100'  ]
        end
   '42':begin
          return,[' 2-Jan-2011 15:39:25.100', $
                  ' 3-Jan-2011 00:09:25.200'  ]
        end 
   '43':begin
          return,[' 1-Jan-2011 03:33:25.200', $
                  ' 1-Jan-2011 08:23:40.300'  ]
        end 
   '44':begin
          return,['0', $ ;2-Jan-2011 00:30:25.200
                  ' 2-Jan-2011 11:25:10.200'  ]
        end 
   '45':begin
          return,['31-Dec-2010 17:58:10.100', $
                  ' 1-Jan-2011 11:03:25.200'  ]
        end 
   '46':begin
          return,[' 2-Jan-2011 16:09:25.100', $
                  ' 2-Jan-2011 21:14:40.100'  ]
        end 
   '47':begin
          return,[' 3-Jan-2011 03:59:40.200', $
                  ' 3-Jan-2011 09:24:25.300'  ]
        end  
   '48':begin
          return,[' 1-Jan-2011 09:48:25.300', $
                  ' 1-Jan-2011 14:38:40.200'  ]
        end 
   '49':begin
          return,[' 1-Jan-2011 08:38:40.300', $
                  ' 1-Jan-2011 10:48:25.200'  ]
        end 
   '50':begin
          return,['0', $ ;31-Dec-2010 20:29:40.100
                  ' 1-Jan-2011 07:39:25.300'  ]
        end
   '51':begin
          return,[' 1-Jan-2011 00:38:40.200', $
                  ' 1-Jan-2011 12:33:25.200'  ]
        end 
   '52':begin
          return,['31-Dec-2010 20:29:40.100', $
                  ' 2-Jan-2011 01:10:10.200'  ]
        end 
   '53':begin
          return,[' 1-Jan-2011 14:43:10.200', $
                  '0' ]  ;1-Jan-2011 21:29:40.100
        end 
   '54':begin
          return,[' 1-Jan-2011 23:04:10.100', $
                  ' 2-Jan-2011 09:17:40.300'  ]
        end
   '55':begin
          return,['0', $  ;2-Jan-2011 07:35:40.300
                  ' 2-Jan-2011 11:00:25.200'  ]
        end 
   '56':begin
          return,[' 2-Jan-2011 13:39:25.200', $
                  ' 2-Jan-2011 14:04:10.200'  ]
        end 
   '57':begin
          return,['0', $  ;2-Jan-2011 12:04:10.200
                  ' 2-Jan-2011 23:54:25.200'  ]
        end 
   '58':begin
          return,[' 2-Jan-2011 12:18:25.200', $
                  ' 2-Jan-2011 19:39:25.100'  ]
        end 
   '59':begin
          return,[' 3-Jan-2011 02:09:25.200', $
                  ' 3-Jan-2011 11:04:10.200'  ]
        end 
   '60':begin
          return,[' 2-Jan-2011 18:08:40.100', $
                  ' 3-Jan-2011 08:46:10.300'  ]
        end
   '61':begin
          return,[' 1-Jan-2011 22:55:10.100', $
                  ' 2-Jan-2011 07:10:10.300'  ]
        end 
   '62':begin
          return,[' 1-Jan-2011 10:18:25.300', $
                  ' 1-Jan-2011 12:10:10.200'  ]
        end 
   '63':begin
          return,['31-Dec-2010 15:49:10.100', $
                  ' 1-Jan-2011 05:29:40.300'  ]
        end 
   '64':begin
          return,[' 1-Jan-2011 06:28:10.300', $
                  ' 1-Jan-2011 15:19:10.100'  ]
        end
   '65':begin
          return,[' 1-Jan-2011 09:08:40.300', $
                  ' 1-Jan-2011 17:44:40.100'  ]
        end 
   '66':begin
          return,[' 1-Jan-2011 06:03:25.300', $
                  ' 2-Jan-2011 09:04:10.300'  ]
        end 
   '67':begin
          return,['0', $ ;1-Jan-2011 16:30:25.100
                  ' 1-Jan-2011 23:00:25.100'  ]
        end 
   '68':begin
          return,[' 2-Jan-2011 04:24:25.300', $
                  ' 3-Jan-2011 03:29:40.200'  ]
        end 
   '69':begin
          return,['0', $  ;2-Jan-2011 18:04:10.100
                  ' 2-Jan-2011 23:29:40.200'  ]
        end
   '70':begin
          return,[' 1-Jan-2011 21:15:25.100', $
                  ' 2-Jan-2011 04:20:40.300'  ]
        end
   else:message,'No such choice!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO hmiGetMoreEvtNum,date,areaNum,beginNum=beginNum,refNum=refNum
  ;获得每个事件的起始文件编号和结束文件编号，对应相应的时间
  case date of
    '2010.12.31_2011.01.03_full':begin
                                  case areaNum of               ;hmi->date & time
                                    '1':begin                          
                                          refNum = 720          ;2011-01-01 00:00:45
                                          beginNum = 2959         ;2011-01-02 13:19:35
                                        end
                                    '2':begin
                                          refNum = 1981         ;2011-01-01 21:01:30
                                          beginNum = 5038         ;2011-01-03 23:58:30                          
                                        end
                                    '3':begin ;原'5'
                                          refNum = 1380         ;2011-01-01 11:00:45
                                          beginNum = 4879         ;2011-01-03 21:19:30
                                        end
                                    '4':begin
                                          refNum = 3220         ;2011-01-02 17:40:30
                                          beginNum = 4140         ;2011-01-03 09:00:45
                                        end
                                    '5':begin
                                          refNum = 1249         ;2011-01-01 08:49:30
                                          beginNum = 2170         ;2011-01-02 00:10:30
                                        end
                                    '6':begin
                                          refNum = 1429         ;2011-01-01 11:49:30
                                          beginNum = 2150         ;2011-01-02 23:50:15
                                        end
                                    '7':begin
                                          refNum = 1609         ;2011-01-01 14:49:30
                                          beginNum = 3290         ;2011-01-02 18:50:15
                                        end
                                    '8':begin
                                          refNum = 1940         ;2011-01-01 20:20:15
                                          beginNum = 3160         ;2011-01-02 16:40:30
                                        end
                                    '9':begin
                                          refNum = 3490         ;2011-01-02 22:10:30
                                          beginNum = 5039         ;2011-01-03 23:59:15
                                        end
                                   '10':begin
                                          refNum = 1609         ;2011-01-01 14:49:30
                                          beginNum = 2590         ;2011-01-02 07:10:30
                                        end
                                   '11':begin
                                          refNum = 1780         ;2011-01-01 17:40:30
                                          beginNum = 2910         ;2011-01-02 12:30:45
                                        end
                                   '12':begin
                                          refNum = 2600         ;2011-01-02 07:20:15
                                          beginNum = 3940         ;2011-01-03 05:40:30
                                        end
                                   '13':begin
                                          refNum = 889          ;2011-01-01 02:49:30
                                          beginNum = 1770         ;2011-01-01 17:30:45
                                        end
                                   '14':begin
                                          refNum = 1710         ;2011-01-01 16:30:45
                                          beginNum = 2850         ;2011-01-02 11:30:45
                                        end
                                   '15':begin
                                          refNum = 1609         ;2011-01-01 14:49:30
                                          beginNum = 3370         ;2011-01-02 20:10:30
                                        end
                                   '16':begin
                                          refNum = 1930         ;2011-01-01 20:10:30
                                          beginNum = 4090         ;2011-01-03 08:10:30
                                        end
                                   '17':begin
                                          refNum = 3120         ;2011-01-02 16:00:45
                                          beginNum = 3680         ;2011-01-03 01:20:15
                                        end
                                   '18':begin
                                          refNum = 2600         ;2011-01-02 07:20:15
                                          beginNum = 4150         ;2011-01-03 09:10:30
                                        end
                                   '19':begin
                                          refNum = 3080         ;2011-01-02 15:20:15
                                          beginNum = 4140         ;2011-01-03 09:00:45
                                        end
                                   '20':begin
                                          refNum = 2840         ;2011-01-02 11:20:15
                                          beginNum = 3830         ;2011-01-03 03:50:15
                                        end
                                   '21':begin
                                          refNum = 619          ;2010-12-31 22:19:30
                                          beginNum = 2130         ;2011-01-01 23:30:45
                                        end 
                                   '22':begin
                                          refNum = 849          ;2011-01-01 02:09:45
                                          beginNum = 1339         ;2011-01-01 10:19:30
                                        end 
                                   '23':begin
                                          refNum = 2970         ;2011-01-02 13:30:45
                                          beginNum = 4000         ;2011-01-03 06:40:30
                                        end 
                                   '24':begin
                                          refNum = 3260         ;2011-01-02 18:20:15
                                          beginNum = 4050         ;2011-01-03 07:30:45
                                        end 
                                   '25':begin 
                                          refNum = 3240         ;2011-01-02 18:00:45
                                          beginNum = 4320         ;2011-01-03 12:00:45
                                        end 
                                   '26':begin
                                          refNum = 949          ;2011-01-01 03:49:30
                                          beginNum = 2210         ;2011-01-02 00:50:15
                                        end 
                                   '27':begin 
                                          refNum = 1649         ;2011-01-01 15:29:15
                                          beginNum = 2180         ;2011-01-02 00:20:15
                                        end
                                   '28':begin 
                                          refNum = 3270         ;2011-01-02 18:30:45
                                          beginNum = 3840         ;2011-01-03 04:00:45
                                        end 
                                   '29':begin 
                                          refNum = 2320         ;2011-01-02 02:40:30
                                          beginNum = 3350         ;2011-01-02 19:50:15
                                        end 
                                   '30':begin
                                          refNum = 3380         ;2011-01-02 20:20:15
                                          beginNum = 4620         ;2011-01-03 17:00:45
                                        end 
                                   '31':begin
                                          refNum = 3530         ;2011-01-02 22:50:15
                                          beginNum = 4160         ;2011-01-03 09:20:15
                                        end 
                                   '32':begin 
                                          refNum = 3770         ;2011-01-03 02:50:15
                                          beginNum = 4530         ;2011-01-03 15:30:45
                                        end 
                                   '33':begin 
                                          refNum = 809          ;2011-01-01 01:29:15
                                          beginNum = 1960         ;2011-01-01 20:40:30
                                        end
                                   '34':begin
                                          refNum = 1189         ;2011-01-01 07:49:30
                                          beginNum = 1580         ;2011-01-01 14:29:15
                                        end
                                   '35':begin
                                          refNum = 1840         ;2011-01-01 18:40:30
                                          beginNum = 3700         ;2011-01-03 01:40:30
                                        end 
                                   '36':begin
                                          refNum = 2060         ;2011-01-01 22:20:15
                                          beginNum = 3980         ;2011-01-03 06:20:15
                                        end 
                                   '37':begin
                                          refNum = 1780         ;2011-01-01 17:40:30
                                          beginNum = 2840         ;2011-01-02 11:20:15
                                        end 
                                   '38':begin 
                                          refNum = 1299         ;2011-01-01 09:39:45
                                          beginNum = 2030         ;2011-01-01 21:50:15
                                        end 
                                   '39':begin 
                                          refNum = 1169         ;2011-01-01 07:29:15
                                          beginNum = 3810         ;2011-01-03 03:30:45
                                        end 
                                   '40':begin 
                                          refNum = 4230         ;2011-01-03 10:30:45
                                          beginNum = 5039         ;2011-01-03 23:59:15
                                        end 
                                   '41':begin
                                          refNum = 2840         ;2011-01-02 11:20:15
                                          beginNum = 4620         ;2011-01-03 17:00:45
                                        end
                                   '42':begin
                                          refNum = 3240         ;2011-01-02 18:00:45
                                          beginNum = 4040         ;2011-01-03 07:20:15
                                        end 
                                   '43':begin
                                          refNum = 1019         ;2011-01-01 04:59:15
                                          beginNum = 1750         ;2011-01-01 17:10:30                                    
                                        end 
                                   '44':begin
                                          refNum = 2220         ;2011-01-02 01:00:45
                                          beginNum = 3340         ;2011-01-02 19:40:30                                   
                                        end 
                                   '45':begin
                                          refNum = 729          ;2011-01-01 00:09:45
                                          beginNum = 2120         ;2011-01-01 23:20:15
                                        end 
                                   '46':begin
                                          refNum = 3170         ;2011-01-02 16:50:15
                                          beginNum = 3720         ;2011-01-03 02:00:45                                    
                                        end 
                                   '47':begin
                                          refNum = 4080         ;2011-01-03 08:00:45
                                          beginNum = 4370         ;2011-01-03 12:50:15                                    
                                        end  
                                   '48':begin
                                          refNum = 1209         ;2011-01-01 08:09:45
                                          beginNum = 1850         ;2011-01-01 18:50:15                                    
                                        end 
                                   '49':begin
                                          refNum = 1249         ;2011-01-01 08:49:30
                                          beginNum = 2270         ;2011-01-02 01:50:15                                    
                                        end 
                                   '50':begin
                                          refNum = 529          ;2010-12-31 20:49:30
                                          beginNum = 1940         ;2011-01-01 20:20:15
                                        end
                                   '51':begin
                                          refNum = 839          ;2011-01-01 01:59:15
                                          beginNum = 1780         ;2011-01-01 17:40:30                                    
                                        end 
                                   '52':begin
                                          refNum = 679          ;2010-12-31 23:19:30
                                          beginNum = 3210         ;2011-01-02 17:30:45
                                        end 
                                   '53':begin
                                          refNum = 1619         ;2011-01-01 14:59:15
                                          beginNum = 2260         ;2011-01-02 01:40:30
                                        end 
                                   '54':begin
                                          refNum = 2640         ;2011-01-02 08:00:45
                                          beginNum = 3050         ;2011-01-02 14:50:15                                    
                                        end
                                   '55':begin
                                          refNum = 2650         ;2011-01-02 08:10:30
                                          beginNum = 3000         ;2011-01-02 14:00:45                                       
                                        end 
                                   '56':begin
                                          refNum = 2980         ;2011-01-02 13:40:30
                                          beginNum = 3220         ;2011-01-02 17:40:30                                    
                                        end 
                                   '57':begin
                                          refNum = 2890         ;2011-01-02 12:10:30
                                          beginNum = 4490         ;2011-01-03 14:50:15                                    
                                        end 
                                   '58':begin
                                          refNum = 2910         ;2011-01-02 12:30:45
                                          beginNum = 3690         ;2011-01-03 01:30:45
                                        end 
                                   '59':begin
                                          refNum = 3940         ;2011-01-03 05:40:30
                                          beginNum = 4840         ;2011-01-03 20:40:30                                    
                                        end 
                                   '60':begin
                                          refNum = 3210         ;2011-01-02 17:30:45
                                          beginNum = 4680         ;2011-01-03 18:00:45                                        
                                        end
                                   '61':begin
                                          refNum = 2100         ;2011-01-01 23:00:45
                                          beginNum = 3570         ;2011-01-02 23:30:45                                    
                                        end 
                                   '62':begin
                                          refNum = 1369         ;2011-01-01 10:49:30
                                          beginNum = 1499         ;2011-01-01 12:59:15
                                        end 
                                   '63':begin
                                          refNum = 619          ;2010-12-31 22:19:30
                                          beginNum = 1449         ;2011-01-01 12:09:45                                    
                                        end 
                                   '64':begin
                                          refNum = 1439         ;2011-01-01 11:59:15
                                          beginNum = 1670         ;2011-01-01 15:50:15                                    
                                        end
                                   '65':begin
                                          refNum = 1349         ;2011-01-01 10:29:15
                                          beginNum = 2120         ;2011-01-01 23:20:15                                    
                                        end 
                                   '66':begin
                                          refNum = 1069         ;2011-01-01 05:49:30
                                          beginNum = 2800         ;2011-01-02 10:40:30                                    
                                        end 
                                   '67':begin
                                          refNum = 1770         ;2011-01-01 17:30:45
                                          beginNum = 3010         ;2011-01-02 14:10:30                                    
                                        end 
                                   '68':begin
                                          refNum = 2430         ;2011-01-02 04:30:45
                                          beginNum = 3850         ;2011-01-03 04:10:30                                    
                                        end 
                                   '69':begin
                                          refNum = 3240         ;2011-01-02 18:00:45
                                          beginNum = 3930         ;2011-01-03 05:30:45                                    
                                        end
                                   '70':begin
                                          refNum = 2000         ;2011-01-01 21:20:15
                                          beginNum = 3020         ;2011-01-02 14:20:15                                    
                                        end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                   else:message,'No such areaNum: ' + areaNum
                                  endcase
                                 end
                       else:message,'invalid date!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------




















