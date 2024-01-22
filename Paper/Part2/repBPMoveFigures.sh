#!/bin/sh

dir2=/space1/moucz2/BP/Paper/Document/myPaper_v4/Figure
rm $dir2/papBPCancelState.eps
rm $dir2/papBPCancelState-eps-converted-to.pdf
rm $dir2/papBPDiffTime.eps
rm $dir2/papBPDiffTime-eps-converted-to.pdf
rm $dir2/papBPLifetime.eps
rm $dir2/papBPLifetime-eps-converted-to.pdf
rm $dir2/papBPMagDistance.eps
rm $dir2/papBPMagDistance-eps-converted-to.pdf
echo "Remove old files done!"

dir=/space1/moucz2/BP/Paper/Image

cp $dir/CancelStat/papBPCancelState.eps $dir2
cp $dir/DiffTime/papBPDiffTime.eps $dir2
cp $dir/Lifetime/papBPLifetime.eps $dir2
cp $dir/MagDistance/papBPMagDistance.eps $dir2
echo "Copy new files done!"