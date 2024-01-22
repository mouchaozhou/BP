;计算持续时间
st = 52  ;起始编号
ed = 70  ;结束编号
more = 1 ;是否需要输出nArea
for i=st,ed do begin
    hmiGetEvtNum,'2010.12.31_2011.01.03_full',IToA(i),refNum=refNum,endNum=endNum
    if (more) then begin
        print,'============================================================'
        print,'nArea(' + IToA(i) + '):  '
    endif
    print,(endNum-refNum)/60.,format='(f5.2)'
endfor
END