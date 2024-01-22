sub classify{ my($num,$typeVal) = @_; 
	#没有匹配到就是-1
    my $lcEmerg_tmp = -1;
	my $lcConve_tmp = -1;
	my $lcConde_tmp = -1;
	
	#开始匹配
	if($typeVal =~ /Emergence/){
		$lcEmerg_tmp = $num;
	}
	
	if($typeVal =~ /Convergence/){
		$lcConve_tmp = $num;
	}
	
	if($typeVal =~ /Local Combination/){
		$lcConde_tmp = $num;
	}

	return($lcEmerg_tmp,$lcConve_tmp,$lcConde_tmp);
}
#-------------------------------------------------------------------------------------------------------------------------'

sub showInfo{ my($lcEmerg,$lcConve,$lcConde,$polarity) = @_;
    my @lcEmerg = @$lcEmerg;
	my @lcConve = @$lcConve;
	my @lcConde = @$lcConde;
	#输出相关信息
	print "Emergence($polarity): @lcEmerg\n";
	print "Convergence($polarity): @lcConve\n";
	print "Local Combination($polarity): @lcConde\n";
	print "================================================================================\n";

	#计算个数
	my $nLcEmerg = @lcEmerg;
	my $nLcConve = @lcConve;
	my $nLcConde = @lcConde;
	print "Emergence($polarity)个数: $nLcEmerg\n";
	print "Convergence($polarity)个数: $nLcConve\n";
	print "Local Combination($polarity)个数: $nLcConde\n";
	print "================================================================================\n";
}
#-------------------------------------------------------------------------------------------------------------------------'

#main
#==========================================================================================================================
#	取出excel中磁场的类型(新的分类)
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;

system 'cls';

#读入指定excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

#取出第一个表
my $sheet = ${$excel->{Worksheet}}[0];

#创建数组
my @lcEmerg_pos;
my @lcConve_pos;
my @lcConde_pos;

my @lcEmerg_neg;
my @lcConve_neg;
my @lcConde_neg;

#遍历每一行
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	#事件编号
    my $num = $sheet->{Cells}[$row][0]->{Val};

	#获得正极磁场的类型内容
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));
	
	#分类统计(正极)
	my($lcEmerg_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$posTypeVal);

	#存入相应数组(正极)
	if($lcEmerg_tmp != -1){
		push(@lcEmerg_pos,$lcEmerg_tmp);
	}
	
	if($lcConve_tmp != -1){
		push(@lcConve_pos,$lcConve_tmp);
	}
	
	if($lcConde_tmp != -1){
		push(@lcConde_pos,$lcConde_tmp);
	}
	
	#获得负极磁场的类型内容
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));
	
	#分类统计(负极)
	($lcEmerg_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$negTypeVal);
	
	#存入相应数组(负极)
	if($lcEmerg_tmp != -1){
		push(@lcEmerg_neg,$lcEmerg_tmp);
	}
	
	if($lcConve_tmp != -1){
		push(@lcConve_neg,$lcConve_tmp);
	}
	
	if($lcConde_tmp != -1){
		push(@lcConde_neg,$lcConde_tmp);
	}
}

#输出相关信息
showInfo(\@lcEmerg_pos,\@lcConve_pos,\@lcConde_pos,"正极");
showInfo(\@lcEmerg_neg,\@lcConve_neg,\@lcConde_neg,"负极");

#输出到文件(方便IDL处理)	
my $file = "papBPMagNewTypes.tmp";	
open FH,'>',$file;
print FH ";Emergence(正极)\n";
print FH "lcEmerg_pos = [".join(",",@lcEmerg_pos)."]\n";
print FH ";Convergence(正极)\n";
print FH "lcConve_pos = [".join(",",@lcConve_pos)."]\n";
print FH ";Local Combination(正极)\n";
print FH "lcConde_pos = [".join(",",@lcConde_pos)."]\n";
print FH "\n";
print FH ";Emergence(负极)\n";
print FH "lcEmerg_neg = [".join(",",@lcEmerg_neg)."]\n";
print FH ";Convergence(负极)\n";
print FH "lcConve_neg = [".join(",",@lcConve_neg)."]\n";
print FH ";Local Combination(负极)\n";
print FH "lcConde_neg = [".join(",",@lcConde_neg)."]\n";
close FH;