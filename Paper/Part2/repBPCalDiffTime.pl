sub Time2Sec{ my($strTime) = @_; 
	if ($strTime eq "null") {
		return "null";
	} elsif ($strTime eq "diff") {
		return "diff";
	} else {
		return HTTP::Date::str2time($strTime, '+0800'); 
	}
}
#-------------------------------------------------------------------------------------------------------------------------'

# main
#==========================================================================================================================
#	计算磁场浮现时间与亮点出现时间的差值
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;
use HTTP::Date;

system 'cls';

#输出到文件	
my $file = "repBPDiffTime.tmp";	
open FH,'>',$file;

# 读入指定excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

# 取出第一个表
my $sheet = ${$excel->{Worksheet}}[0];

#遍历每一行
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}) {
	# Mag 浮现时间(秒数)
	my $magStSec = Time2Sec($sheet->{Cells}[$row][16]->{Val});
	
	# BP 出现时间(秒数)
	if ($magStSec eq "null") {
		print FH "null\n";
	} elsif ($magStSec eq "diff") {
		print FH "diff\n";
	} else {
		my $bpStSec = Time2Sec($sheet->{Cells}[$row][1]->{Val});
		my $dtHour = ($bpStSec - $magStSec) / 3600 ;
		print FH sprintf("%0.1f", $dtHour)."\n";
	}	
}

close FH;