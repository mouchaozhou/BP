@hmiBP.in

;hmiBPFindBox的辅助程序

Say,'areaNum: ',areaNum

hmiGetEvtNum,date,areaNum,beginNum=beginNum,refNum=refNum,endNum=endNum

bNum = refNum - beginNum
eNum = endNum - beginNum
Say,'The number ranges from',bNum,'    to',eNum
Say,'The mean number is: ',(bNum+eNum)/2
Say,'The 3/4 value is: ',(bNum+3*eNum)/4
END