;+===========================annotation--begin===================================================
; 做一下老版本lifetime起始结束时刻与峰值比值的散点图
; 统计一下比值大于1/e的起始结束位置的个数
;-===========================annotation--begin===================================================

device,decomposed=1
;输入文件
ratioFile = '../Image/test_TryDefLifeTime/ratio.txt'
;输出目录
figDir = MakeDir('../Image/test_ChkLifetime/')

line = ''
;读入文件
openr,lun,ratioFile,/get_lun

ratioBg = fltarr(70)
ratioEd = fltarr(70)

for i=0,69 do begin
    ;读入数据  
    readf,lun,line
    ;拆分字符串（默认为空格）
    arrLine = strsplit(line,/extract)
    ;存放数据
    ratioBg[i] = float(arrLine[2])
    ratioEd[i] = float(arrLine[4])
    
    ;判断起始时刻的比值是否大于1/e
    if (ratioBg[i] ge 1./!e) then begin
        Push,ratioBgGe1e,ratioBg[i]
        Push,ratioBgNum,i+1
    endif
    ;判断起始时刻的比值是否大于1/e
    if (ratioBg[i] ge 0.5) then begin
        Push,ratioBgGe05,ratioBg[i]
    endif
    
    ;判断结束时刻的比值是否大于1/e
    if (ratioEd[i] ge 1./!e) then begin
        Push,ratioEdGe1e,ratioEd[i]
        Push,ratioEdNum,i+1
    endif
    
    if (ratioEd[i] ge 0.5) then begin
        Push,ratioEdGe05,ratioEd[i]
    endif  
endfor
;关闭文件
free_lun,lun

;画图
window,0,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,ratioBg,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1, $
     title='ratioBg > 1/e : '+IToA(n_elements(ratioBgGe1e))+'          ratioBg > 0.5 : '+IToA(n_elements(ratioBgGe05))
oplot,[0,70],[1./!e,1./!e],color=GetColour('Blue')
oplot,[0,70],[0.5,0.5],color=GetColour('Yellow')
write_png,figDir+'ratioBg.png',tvrd(true=1)

window,1,xsize=1200,ysize=600,retain=2
plot,indgen(70)+1,ratioEd,/xstyle,/ystyle,position=[0.1,0.1,0.9,0.9],psym=1, $
     title='ratioEd > 1/e : '+IToA(n_elements(ratioEdGe1e))+'          ratioEd > 0.5 : '+IToA(n_elements(ratioEdGe05))
oplot,[0,70],[1./!e,1./!e],color=GetColour('Blue')
oplot,[0,70],[0.5,0.5],color=GetColour('Yellow')
write_png,figDir+'ratioEd.png',tvrd(true=1)

undefine,ratioBgGe1e
undefine,ratioBgGe05
undefine,ratioBgNum
undefine,ratioEdGe1e
undefine,ratioEdGe05
undefine,ratioEdNum   
     
Over
END