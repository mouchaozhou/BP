;+===========================annotation--begin===================================================
; This is a main program
;
; :Purpose:
;    拟合磁场变化曲线
;
; :Author: Chaozhou Mou
;-===========================annotation--end======================================================
;PRO main
@hmiBP.in

;输入路径和输入文件(hmiBPGetBoxPhys)
hmiInboxDir = '../Save/PhysInbox/' + date + '/' + wavelen + '/' + areaNum + '/'
hmiInboxFile = '*.sav'

;定义输出路径
fittedMagImgDir = MakeDir('../Figure/FittedMagImg/' + date + '/' + areaNum + '/') ;画出位置
fittedMagParsDir = MakeDir('../Save/FittedMagPars/' + date + '/' + areaNum + '/')  ;拟合后的参数

;恢复sav中存放的数据
hmiBPGetBoxSavData,hmiInboxDir+hmiInboxFile,arrTime=arrTime,bgPosFlux=posFluxBg,bgNegFlux=negFluxBg, $
                   Intensity=Intensity,/normal,/info

;处理一下时间数据，将后面没用的部分截掉
arrTime = strmid(arrTime,0,strlen('11-Nov-2010 16:15'))

;得到要拟合数据的范围
hmiGetFittingTimeRange,areaNum,emergPosRange=emergPosRange,emergNegRange=emergNegRange, $
                       cancelPosRange=cancelPosRange,cancelNegRange=cancelNegRange

;磁浮现
emergPosRangeIndex = [where(arrTime eq emergPosRange[0]),where(arrTime eq emergPosRange[1])]
emergNegRangeIndex = [where(arrTime eq emergNegRange[0]),where(arrTime eq emergNegRange[1])]


;磁对消
if (cancelPosRange[1] ne 'Last') then begin
    cancelPosRangeIndex = [where(arrTime eq cancelPosRange[0]),where(arrTime eq cancelPosRange[1])]
endif $
else begin
    cancelPosRangeIndex = [where(arrTime eq cancelPosRange[0]),n_elements(arrTime)-1]   
endelse

if (cancelNegRange[1] ne 'Last') then begin
    cancelNegRangeIndex = [where(arrTime eq cancelNegRange[0]),where(arrTime eq cancelNegRange[1])]
endif $
else begin
    cancelNegRangeIndex = [where(arrTime eq cancelNegRange[0]),n_elements(arrTime)-1]  
endelse

;正极场
emergPosFluxBg = posFluxBg[emergPosRangeIndex[0]:emergPosRangeIndex[1]]
cancelPosFluxBg = posFluxBg[cancelPosRangeIndex[0]:cancelPosRangeIndex[1]]
emergPosX = (findgen(n_elements(arrTime)))[emergPosRangeIndex[0]:emergPosRangeIndex[1]]
cancelPosX = (findgen(n_elements(arrTime)))[cancelPosRangeIndex[0]:cancelPosRangeIndex[1]]
;线性拟合-正极
emergPosPar = linfit(emergPosX ,emergPosFluxBg)  ;[b,k] y = b + kx
cancelPosPar = linfit(cancelPosX,cancelPosFluxBg)

;负极场
emergNegFluxBg = negFluxBg[emergNegRangeIndex[0]:emergNegRangeIndex[1]]
cancelNegFluxBg = negFluxBg[cancelNegRangeIndex[0]:cancelNegRangeIndex[1]]
emergNegX = (findgen(n_elements(arrTime)))[emergNegRangeIndex[0]:emergNegRangeIndex[1]]
cancelNegX = (findgen(n_elements(arrTime)))[cancelNegRangeIndex[0]:cancelNegRangeIndex[1]]
;线性拟合-负极
emergNegPar = linfit(emergNegX,emergNegFluxBg)
cancelNegPar = linfit(cancelNegX,cancelNegFluxBg)

;画图参数
xsize = 1000
ysize = 600
position = [0.1,0.1,0.9,0.9]

;画正极曲线图
window,1,xsize=xsize,ysize=ysize,retain=2
plot,findgen(n_elements(arrTime)),posFluxBg,xstyle=5,ystyle=5,position=position,title='Positive',/nodata   ;浮现  
oplot,emergPosX,emergPosPar[0]+emergPosX*emergPosPar[1]
oplot,cancelPosX,cancelPosPar[0]+cancelPosX*cancelPosPar[1]  ;对消
utplot,arrTime,posFluxBg,xstyle=1,ystyle=1,/noerase,position=position
write_png,fittedMagImgDir+areaNum+'_pos_fitted.png',tvrd(true=1)

;画负极曲线图
window,2,xsize=xsize,ysize=ysize,retain=2
plot,findgen(n_elements(arrTime)),negFluxBg,xstyle=5,ystyle=5,position=position,title='Negative',/nodata   ;对消
oplot,emergNegX,emergNegPar[0]+emergNegX*emergNegPar[1]
oplot,cancelNegX,cancelNegPar[0]+cancelNegX*cancelNegPar[1]  ;对消
utplot,arrTime,negFluxBg,xstyle=1,ystyle=1,/noerase,position=position
write_png,fittedMagImgDir+areaNum+'_neg_fitted.png',tvrd(true=1)

;写入文件
dbg,emergPosPar,/str
dbg,emergNegPar,/str
openw,lun,fittedMagParsDir+areaNum+'_fittedMagPars.txt',/get_lun
printf,lun,'Emergence:  b   k'
printf,lun,'Positive'
printf,lun,emergPosPar
printf,lun,'Negative'
printf,lun,emergNegPar
printf,lun,'============================================'
printf,lun,'Cancellation:  b   k'
printf,lun,'Positive'
printf,lun,cancelPosPar
printf,lun,'Negative'
printf,lun,cancelNegPar
free_lun,lun

Over
END              