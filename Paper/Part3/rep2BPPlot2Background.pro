;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    获得每个亮点的一块背景区域后做散点图
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================

@rep2BP.in

arrRatioBg = fltarr(70)
arrRatioEd = fltarr(70)

outDir = MakeDir('../Image/test_Plot2Background/')

for j=1,70 do begin
    areaNum = IToA(j)
    savDir = MakeDir('../Image/test_GetBackground/' + date + '/' + wavelen + '/' + areaNum + '/') 
    
    restore,savDir+areaNum+'-'+wavelen+'_ratioBg_raitoEd.sav',/ve
    
    arrRatioBg[j-1] = ratioBg
    arrRatioEd[j-1] = ratioEd   
endfor

;画散点图    
window,1,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,arrRatioBg,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1,title='BEGIN TIME'
write_png,outDir+'ratioBg.png',tvrd(true=1)    

window,2,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,arrRatioEd,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1,title='END TIME'
write_png,outDir+'ratioEd.png',tvrd(true=1)

Over
END