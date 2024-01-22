##############################################################
#   画对消（磁场模型）类型饼状图
##############################################################

require(grDevices)

nSma <- 33
nCon <- 34
nCME <- 3

# open the file ".eps" for graphics output
# width, height : the width and height of the graphics region in inches. Default to 0.
postscript(file="..\\Image\\CancelStat\\papBPCancelState.eps", width=6, height=6, 
           horizontal = FALSE)

# 画饼状图
pie(c(nSma, nCon, nCME), labels=c(NA, NA, NA), 
    col=c("cyan", "red", "yellow"), radius = 1.0)

# 标注百分比文字 
text(0.1, 0.5, "I: 47.1%")
text(-0.1, -0.5, "II: 48.6%")
text(0.7, -0.085, "III: 4.3%")

# turn off the postscript device
dev.off()


