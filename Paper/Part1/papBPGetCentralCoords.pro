;+===========================annotation--begin===================================================
; 获得亮点的中心坐标（角秒）
;-===========================annotation--begin===================================================

@papBP.in

for i=1,70 do begin
    ;print,IToA(i)
    needArea = aiaCropPar(date,IToA(i))
    xCen = (needArea[0] + needArea[1]) * 0.5
    yCen = (needArea[2] + needArea[3]) * 0.5
    print,xCen,' ',yCen,format='(f6.1,a2,f6.1)'
    ;print,xCen,yCen
    ;print,'=========================================='
endfor

END