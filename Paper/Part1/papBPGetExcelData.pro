;+===========================annotation--begin===================================================
; 获得Excel中的数据
;-===========================annotation--begin===================================================

;输入输出路径
dir = 'C:\Users\yanlm\Desktop\Work\'
excelFile = dir + 'hmiBPCases.xlsx'
saveFile1 = dir + 'excelData_all.sav'
saveFile2 = dir + 'excelData_request.sav'

;获得Excel中的数据
;中心坐标
nData = 70
position = intarr(nData,2)
posTmp = reform(ReadExcel(excelFile,"M3:M72"))
for i=0,nData-1 do begin
    arrPos = strsplit(strtrim(posTmp[i],2),' ',/extract)  ;先去除首尾空格在分割开
    position[i,0] = round(float(arrPos[0]))   ;x坐标
    position[i,1] = round(float(arrPos[1]))   ;y坐标
endfor

;开始时间
startTime = reform(ReadExcel(excelFile,"B3:B72")) 

;结束时间
endTime = reform(ReadExcel(excelFile,"C3:C72"))

;寿命
lifetime = float(reform(ReadExcel(excelFile,"D3:D72")))

;正极磁场的类型内容
posTypeValTmp = reform(ReadExcel(excelFile,"G3:G72"))
posTypeVal = papBPType2Num(posTypeValTmp,'Emergence',1.,'Convergence',2.,'Local Combination',3.)

;负极磁场的类型内容
negTypeValTmp = reform(ReadExcel(excelFile,"H3:H72"))
negTypeVal = papBPType2Num(negTypeValTmp,'Emergence',1.,'Convergence',2.,'Local Combination',3.)

;正负极磁场接触时期
cancelStat = fix(reform(ReadExcel(excelFile,"P3:P72")))

;加热机制(磁场模型)
heatMechTmp = reform(ReadExcel(excelFile,"L3:L72"))
heatMech = papBPType2Num(heatMechTmp,'small',1.,'converge',2.,'CME',3.)

;亮点出现时磁场间距离
startMagDis = round(float(reform(ReadExcel(excelFile,"N3:N72")))) 

;亮点峰值时磁场间距离
peakMagDis = round(float(reform(ReadExcel(excelFile,"O3:O72")))) 

save,position,startTime,endTime,lifetime,posTypeVal,negTypeVal,cancelStat,heatMech,startMagDis,peakMagDis,filename=saveFile1


;储存需要数据------------------------------------------------------------------------------------------------------------
requestData = fltarr(70,7)
requestData[*,0] = lifetime
requestData[*,1] = heatMech 
requestData[*,2] = startMagDis 
requestData[*,3] = peakMagDis 
requestData[*,4] = posTypeVal
requestData[*,5] = negTypeVal

;提取相同类型------------------------------------------------------------------------------------------------------------

for i=0,nData-1 do begin
    if (posTypeValTmp[i] eq negTypeValTmp[i]) then begin
        case posTypeValTmp[i] of 
          'Emergence' : begin 
                          requestData[i,6] = 1.
                        end
          'Convergence' : begin
                          requestData[i,6] = 2.
                          end
          'Local Combination' : begin
                          requestData[i,6] = 3.
                                end
          else : message,'posTypeVal is not found!'
        endcase
    endif $
    else begin
        requestData[i,6] = 0.
    endelse
endfor
 
save,requestData,filename=saveFile2

Over
END