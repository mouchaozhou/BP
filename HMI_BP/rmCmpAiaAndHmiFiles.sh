#!/bin/sh
read -p "Please enter the areaNum: " areaNum 

#变量初始化时不用加$号，且=号不能有空格
Date=2010.12.31_2011.01.03_full
waveLen=211

rm -r -f ../Save/AfterCmp/$Date/$waveLen/$areaNum
rm -r -f ../Figure/WithContourOfAia/$Date/$waveLen/$areaNum
rm -r -f ../../AIA_BP/Save/AfterCmp/$Date/$waveLen/$areaNum

echo "Done!" 

exit 0