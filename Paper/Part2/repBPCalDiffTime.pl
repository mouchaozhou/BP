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
#	����ų�����ʱ�����������ʱ��Ĳ�ֵ
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;
use HTTP::Date;

system 'cls';

#������ļ�	
my $file = "repBPDiffTime.tmp";	
open FH,'>',$file;

# ����ָ��excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

# ȡ����һ����
my $sheet = ${$excel->{Worksheet}}[0];

#����ÿһ��
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}) {
	# Mag ����ʱ��(����)
	my $magStSec = Time2Sec($sheet->{Cells}[$row][16]->{Val});
	
	# BP ����ʱ��(����)
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