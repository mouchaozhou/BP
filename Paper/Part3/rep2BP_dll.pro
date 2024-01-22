Function rep2BPFormatTime,timeStr
  ;将PDF中的时间格式化为arrTime中的
  ;2011-01-01 00:04:10 --> 1-Jan-2011 00:04:10
  
  ;拆分为年月日和时分秒
  arrTime = strsplit(timeStr,/extract)
  
  ;拆分年月日
  YMD = strsplit(arrTime[0],'-',/extract)
  year = YMD[0]
  monthTmp = YMD[1]
  dayTmp = YMD[2]
   
  ;处理月份
  case monthTmp of
    '12' : month = 'Dec'
    '01' : month = 'Jan'
    else : message,'No such month'
  endcase
  
  ;处理日期
  case dayTmp of 
    '31' : day = '31'
    '01' : day = ' 1'
    '02' : day = ' 2'
    '03' : day = ' 3'
    else : message,'No such day'
  endcase 
  
  ;重新拼装
  return,day+'-'+month+'-'+year+' '+arrTime[1]
END
;-----------------------------------------------------------------------------------------------------------------------------

Function rep2BPStrmidTime,timeStr
  ;只截取需要的时间部分
  return,strmid(timeStr,0,strlen('31-Dec-2010 00:04:10'))
END
;-----------------------------------------------------------------------------------------------------------------------------

PRO rep2BPGetBeginAndEndTimeIndex,arrBPNum,bpPeakIndex, $
    bgTimeIndex=bgTimeIndex,edTimeIndex=edTimeIndex
    ;获得1/e和背景算出来的起始结束时间的index
;    dbg,bpPeakIndex
;    dbg,arrBPNum
;    dbg,where(arrBPNum le bpPeakIndex)   
    lePeakIndex = where(arrBPNum le bpPeakIndex)
    ;;;
    ; where中数组和数组比较，会返回0
    ; ex: a = [0,1,2,3,4,5,6,7]
    ; IDL> print,a[where(a le [4])]
    ;      0
    ;;;
;    dbg,lePeakIndex
    gePeakIndex = where(arrBPNum gt bpPeakIndex)
    
    if (Arr0(lePeakIndex) ne -1) then begin
        bgTimeIndex = max(arrBPNum[lePeakIndex]) 
;        dbg,arrBPNum[lePeakIndex]
;        dbg,bgTimeIndex
    endif $
    else begin
        bgTimeIndex = -1
    endelse
    
    if (Arr0(gePeakIndex) ne -1) then begin
        edTimeIndex = min(arrBPNum[gePeakIndex]) 
    endif $
    else begin
        edTimeIndex = -1
    endelse
END
;-----------------------------------------------------------------------------------------------------------------------------    