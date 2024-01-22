;+===========================annotation--begin===================================================
; :Prototype:
;    aiaBP_db
; :Purpose:
;    提供各种具体的数据参数
;    
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
Function aiaGetDate,dateNum
  case dateNum of
    1: return,date = '2010.12.31_2011.01.03_full'   ;BH - Black Hole.
    else: message,'No such dateNum!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function aiaCropPar,date,areaNum
  ;获得截图参数arcsec  
  case date of
    '2010.12.31_2011.01.03_full':begin                            ;[x0, x1, y0, y1]  ;arcsec
                                  if (areaNum eq '1') then return,[-600,-485,280,395]   ;CH-4
                                  if (areaNum eq '2') then return,[-340,-240,440,540]   ;CH-4
                                  if (areaNum eq '3') then return,[260,360,-170,-70]    ;QA-3
                                  if (areaNum eq '4') then return,[90,170,-210,-130]    ;QA-1
                                  if (areaNum eq '5') then return,[30,90,-160,-110]     ;QA-1
                                  if (areaNum eq '6') then return,[-60,-10,-230,-180]   ;QA-1
                                  if (areaNum eq '7') then return,[140,200,-260,-200]   ;QA-1
                                  if (areaNum eq '8') then return,[-140,-80,-240,-180]  ;QA-1
                                  if (areaNum eq '9') then return,[110,170,-140,-80]    ;QA-1
                                  if (areaNum eq '10') then return,[-120,-60,-100,-40]  ;QA-1
                                  if (areaNum eq '11') then return,[70,120,-190,-140]   ;QA-1
                                  if (areaNum eq '12') then return,[160,250,-140,-50]   ;QA-1
                                  if (areaNum eq '13') then return,[-85,-35,-475,-425]  ;QA-2
                                  if (areaNum eq '14') then return,[310,370,-420,-360]  ;QA-2
                                  if (areaNum eq '15') then return,[150,210,-255,-195]  ;QA-2
                                  if (areaNum eq '16') then return,[115,195,-370,-290]  ;QA-2
                                  if (areaNum eq '17') then return,[235,275,-390,-350]  ;QA-2
                                  if (areaNum eq '18') then return,[240,310,-355,-285]  ;QA-2
                                  if (areaNum eq '19') then return,[450,510,-380,-300]  ;QA-2
                                  if (areaNum eq '20') then return,[240,300,-390,-330]  ;QA-2
                                  if (areaNum eq '21') then return,[260,320,-130,-70]   ;QA-3
                                  if (areaNum eq '22') then return,[310,370,-110,-50]   ;QA-3
                                  if (areaNum eq '23') then return,[630,690,-200,-140]  ;QA-3
                                  if (areaNum eq '24') then return,[600,660,-210,-150]  ;QA-3
                                  if (areaNum eq '25') then return,[730,810,5,85]       ;QA-3
                                  if (areaNum eq '26') then return,[130,190,-175,-115]  ;QA-3
                                  if (areaNum eq '27') then return,[410,470,-195,-135]  ;QA-3
                                  if (areaNum eq '28') then return,[710,770,-30,30]     ;QA-3
                                  if (areaNum eq '29') then return,[470,570,-20,80]     ;QA-3
                                  if (areaNum eq '30') then return,[470,550,-90,-10]    ;QA-3
                                  if (areaNum eq '31') then return,[480,540,-160,-100]  ;QA-3
                                  if (areaNum eq '32') then return,[610,680,-100,-30]   ;QA-3
                                  if (areaNum eq '33') then return,[70,130,-200,-140]   ;QA-3
                                  if (areaNum eq '34') then return,[-380,-340,490,530]  ;CH-4
                                  if (areaNum eq '35') then return,[-300,-230,310,380]  ;CH.B-4  ;B means boundary 
                                  if (areaNum eq '36') then return,[-275,-195,340,420]  ;CH.B-4
                                  if (areaNum eq '37') then return,[-230,-170,350,410]  ;CH.B-4
                                  if (areaNum eq '38') then return,[-535,-485,450,500]  ;CH-4
                                  if (areaNum eq '39') then return,[-380,-300,360,440]  ;CH.B-4
                                  if (areaNum eq '40') then return,[-155,-95,375,435]   ;CH-4
                                  if (areaNum eq '41') then return,[-400,-320,295,375]  ;CH.B-4
                                  if (areaNum eq '42') then return,[-345,-295,345,395]  ;CH.B-4
                                  if (areaNum eq '43') then return,[-660,-600,310,370]  ;CH-4
                                  if (areaNum eq '44') then return,[-500,-440,510,570]  ;CH.B-4
                                  if (areaNum eq '45') then return,[-580,-520,290,350]  ;CH-4
                                  if (areaNum eq '46') then return,[-180,-120,400,460]  ;CH.B-4
                                  if (areaNum eq '47') then return,[-30,30,550,610]     ;CH-4
                                  if (areaNum eq '48') then return,[-485,-425,115,175]  ;QA-5
                                  if (areaNum eq '49') then return,[-515,-455,95,155]   ;QA-5       
                                  if (areaNum eq '50') then return,[-425,-335,160,250]  ;QA-5
                                  if (areaNum eq '51') then return,[-375,-315,265,325]  ;QA-5
                                  if (areaNum eq '52') then return,[-500,-400,195,275]  ;QA-5
                                  if (areaNum eq '53') then return,[-460,-400,175,235]  ;QA-5
                                  if (areaNum eq '54') then return,[-375,-325,155,205]  ;QA-5
                                  if (areaNum eq '55') then return,[-320,-260,60,120]   ;QA-5
                                  if (areaNum eq '56') then return,[-220,-170,185,235]  ;QA-5
                                  if (areaNum eq '57') then return,[-280,-200,270,350]  ;QA-5
                                  if (areaNum eq '58') then return,[-200,-150,140,190]  ;QA-5
                                  if (areaNum eq '59') then return,[-50,20,270,340]     ;QA-5
                                  if (areaNum eq '60') then return,[-125,-35,215,305]   ;QA-5
                                  if (areaNum eq '61') then return,[-290,-220,280,350]  ;QA-5
                                  if (areaNum eq '62') then return,[-500,-460,190,230]  ;QA-5
                                  if (areaNum eq '63') then return,[-470,-400,260,330]  ;QA-5
                                  if (areaNum eq '64') then return,[-490,-450,220,260]  ;QA-5
                                  if (areaNum eq '65') then return,[-280,-220,200,260]  ;QA-5
                                  if (areaNum eq '66') then return,[-80,-20,770,830]    ;QA-6
                                  if (areaNum eq '67') then return,[-217,-147,620,690]  ;BH-6
                                  if (areaNum eq '68') then return,[10,80,670,740]      ;BH-6
                                  if (areaNum eq '69') then return,[-20,60,650,730]     ;BH-6
                                  if (areaNum eq '70') then return,[-180,-110,580,650]  ;BH-6
                                  message,"Wrong areaNum!"                                                                                                    
                                 end
                       else:message,'invalid date!'
  endcase
END
;-----------------------------------------------------------------------------------------------------------------------------

Function aiaGetFindBPsPar,nArea=nArea,all=all
  ;获得找BPs的时候所选出来的坐标
  ;不需要手动截取时调用该函数
  area1 = [-468.834,-49.1520,-264.476,41.8588]
  area2 = [-279.78829,124.77051,-491.07939, -193.13759]
  area3 = [-45.371041,321.37853,-195.34768,123.93029]
  area4 = [-775.08925,-374.31137,308.77543,590.24417]
  area5 = [-782.65110,-366.74953,23.105665,325.57953]
  area6 = [-461.27261,-71.837505,590.24417,871.71291]
  area7 = [-276.00737,128.55143,-783.49132,-497.82155]

  if (keyword_set(all)) then $
      return,[ [area1], $  
               [area2], $
               [area3], $ 
               [area4], $
               [area5], $
               [area6], $
               [area7] $ 
              ]
              
  case nArea of
    '1': return,area1
    '2': return,area2
    '3': return,area3
    '4': return,area4
    '5': return,area5
    '6': return,area6
    '7': return,area7
    else: message,'No such nArea: ' + nArea
  endcase      
END
;-----------------------------------------------------------------------------------------------------------------------------