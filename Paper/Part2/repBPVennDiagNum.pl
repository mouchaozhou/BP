sub classify { my($typeVal) = @_; 
	if ($typeVal eq "Emergence") {
		return "A";
	}
	
	if ($typeVal eq "Convergence") {
		return "B";
	}
	
	if ($typeVal eq "Local Combination") {
		return "C";
	}

	return "null";
}
#-------------------------------------------------------------------------------------------------------------------------'

#main
#==========================================================================================================================
#	统计磁场形成的种类对应的个数
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;

# 读入指定excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

# 取出第一个表
my $sheet = ${$excel->{Worksheet}}[0];

# 定义个数统计变量
my $nAA = 0;
my $nAB = 0;
my $nAC = 0;
my $nBB = 0;
my $nBC = 0;
my $nCC = 0;

# 遍历每一行
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}) {
	# 获得正极磁场的类型内容
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));	
	# 正极磁场进行分类
	$posTypeVal = classify($posTypeVal);
	
	# 获得负极磁场的类型内容
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));	
	# 负极磁场进行分类
	$negTypeVal = classify($negTypeVal);
	
	# 统计个数
	my $type = $posTypeVal.$negTypeVal;
	
	if ($type eq 'AA') {
		$nAA++;
	} elsif (($type eq 'AB') || ($type eq 'BA')) {
		$nAB++;
	} elsif (($type eq 'AC') || ($type eq 'CA')) {
		$nAC++;
	} elsif ($type eq 'BB') {
		$nBB++;
	} elsif (($type eq 'BC') || ($type eq 'CB')) {
		$nBC++;
	} elsif ($type eq 'CC') {
		$nCC++;
	} else {
		print "Must be a fucking mistake!";
	}
}

print "The number of AA is $nAA\n";
print "The number of AB is $nAB\n";	
print "The number of AC is $nAC\n";
print "The number of BB is $nBB\n";	
print "The number of BC is $nBC\n";
print "The number of CC is $nCC\n";
my $nA = $nAA + $nAB + $nAC;
print "Total of A is $nA\n";
my $nB = $nAB + $nBB + $nBC;
print "Toatl of B is $nB\n";
my $nC = $nAC + $nBC + $nCC;
print "Toatl of C is $nC\n";	


