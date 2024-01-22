sub classify{ my($num,$typeVal) = @_; 
	#û��ƥ�䵽����-1
    my $lcEmerg_tmp = -1;
	my $lcConve_tmp = -1;
	my $lcConde_tmp = -1;
	
	#��ʼƥ��
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
	#��������Ϣ
	print "Emergence($polarity): @lcEmerg\n";
	print "Convergence($polarity): @lcConve\n";
	print "Local Combination($polarity): @lcConde\n";
	print "================================================================================\n";

	#�������
	my $nLcEmerg = @lcEmerg;
	my $nLcConve = @lcConve;
	my $nLcConde = @lcConde;
	print "Emergence($polarity)����: $nLcEmerg\n";
	print "Convergence($polarity)����: $nLcConve\n";
	print "Local Combination($polarity)����: $nLcConde\n";
	print "================================================================================\n";
}
#-------------------------------------------------------------------------------------------------------------------------'

#main
#==========================================================================================================================
#	ȡ��excel�дų�������(�µķ���)
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;

system 'cls';

#����ָ��excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

#ȡ����һ����
my $sheet = ${$excel->{Worksheet}}[0];

#��������
my @lcEmerg_pos;
my @lcConve_pos;
my @lcConde_pos;

my @lcEmerg_neg;
my @lcConve_neg;
my @lcConde_neg;

#����ÿһ��
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	#�¼����
    my $num = $sheet->{Cells}[$row][0]->{Val};

	#��������ų�����������
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));
	
	#����ͳ��(����)
	my($lcEmerg_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$posTypeVal);

	#������Ӧ����(����)
	if($lcEmerg_tmp != -1){
		push(@lcEmerg_pos,$lcEmerg_tmp);
	}
	
	if($lcConve_tmp != -1){
		push(@lcConve_pos,$lcConve_tmp);
	}
	
	if($lcConde_tmp != -1){
		push(@lcConde_pos,$lcConde_tmp);
	}
	
	#��ø����ų�����������
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));
	
	#����ͳ��(����)
	($lcEmerg_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$negTypeVal);
	
	#������Ӧ����(����)
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

#��������Ϣ
showInfo(\@lcEmerg_pos,\@lcConve_pos,\@lcConde_pos,"����");
showInfo(\@lcEmerg_neg,\@lcConve_neg,\@lcConde_neg,"����");

#������ļ�(����IDL����)	
my $file = "papBPMagNewTypes.tmp";	
open FH,'>',$file;
print FH ";Emergence(����)\n";
print FH "lcEmerg_pos = [".join(",",@lcEmerg_pos)."]\n";
print FH ";Convergence(����)\n";
print FH "lcConve_pos = [".join(",",@lcConve_pos)."]\n";
print FH ";Local Combination(����)\n";
print FH "lcConde_pos = [".join(",",@lcConde_pos)."]\n";
print FH "\n";
print FH ";Emergence(����)\n";
print FH "lcEmerg_neg = [".join(",",@lcEmerg_neg)."]\n";
print FH ";Convergence(����)\n";
print FH "lcConve_neg = [".join(",",@lcConve_neg)."]\n";
print FH ";Local Combination(����)\n";
print FH "lcConde_neg = [".join(",",@lcConde_neg)."]\n";
close FH;