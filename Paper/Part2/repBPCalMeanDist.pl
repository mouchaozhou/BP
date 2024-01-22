# 四舍五入的函数
sub round{ my($data, $index) = @_; #$index为保留小数点后的位数
   my $tmp = 10**$index;
   return int($data * $tmp + 0.5) / $tmp;
}
#-------------------------------------------------------------------------------------------------------------------------'


#main
#==========================================================================================================================
#	计算文献中的平均距离
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;
use Statistics::Basic qw(:all);

# 声明数组
my (@emgBegDis, @emgPekDis);
my (@covBegDis, @covPekDis);
my (@locBegDis, @locPekDis);

# 读入指定excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

# 取出第一个表
my $sheet = ${$excel->{Worksheet}}[0];

# 遍历每一行
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	# 获得正极磁场的类型内容
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8", $posTypeVal));	
	
	# 获得负极磁场的类型内容
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8", $negTypeVal));	
	
	# 获得亮点出现时磁场间距离
	my $startMagDis = $sheet->{Cells}[$row][13]->{Val};
	$startMagDis = round($startMagDis);
	
	# 获得亮点峰值时磁场间距离
	my $peakMagDis = $sheet->{Cells}[$row][14]->{Val};
	$peakMagDis = round($peakMagDis);
	
	if (($posTypeVal =~ /Emergence/) && ($negTypeVal =~ /Emergence/)) {
		push(@emgBegDis, $startMagDis);
		push(@emgPekDis, $peakMagDis);
	} elsif (($posTypeVal =~ /Convergence/) && ($negTypeVal =~ /Convergence/)) {
		push(@covBegDis, $startMagDis);
		push(@covPekDis, $peakMagDis);
	} elsif (($posTypeVal =~ /Local Combination/) && ($negTypeVal =~ /Local Combination/)) {
		push(@locBegDis, $startMagDis);
		push(@locPekDis, $peakMagDis);
	}
}

# 输出数组的个数
my $nEmg = @emgBegDis;
print "Emergence: $nEmg\n";
my $nCov = @covBegDis;
print "Convergence: $nCov\n";
my $nLoc = @locBegDis;
print "Local Combination: $nLoc\n";

# 计算平均值和方差
# Emergence
print "Mean emergence begin distance: ".mean(@emgBegDis)."±".stddev(@emgBegDis)."\n";
print "Mean emergence peak  distance: ".mean(@emgPekDis)."±".stddev(@emgPekDis)."\n";
# Convergence
print "Mean convergence begin distance: ".mean(@covBegDis)."±".stddev(@covBegDis)."\n";
print "Mean convergence peak  distance: ".mean(@covPekDis)."±".stddev(@covPekDis)."\n";
# Local Combination
print "Mean Local Combination begin distance: ".mean(@locBegDis)."±".stddev(@locBegDis)."\n";
print "Mean Local Combination peak  distance: ".mean(@locPekDis)."±".stddev(@locPekDis)."\n";

