#Windows

sub classify{ my($num,$typeVal) = @_; 
	#û��ƥ�䵽����-1
    my $lcEmerg_tmp = -1;
	my $migrate_tmp = -1;
	my $lcConve_tmp = -1;
	my $lcConde_tmp = -1;
	
	#��ʼƥ��
	if($typeVal =~ /�ֲ�����/){
		$lcEmerg_tmp = $num;
	}
	
	if($typeVal =~ /Ǩ��/){
		$migrate_tmp = $num;
	}
	
	if($typeVal =~ /�ֵض���/){
		$lcConve_tmp = $num;
	}
	
	if($typeVal =~ /�ֲ�����/){
		$lcConde_tmp = $num;
	}

	return($lcEmerg_tmp,$migrate_tmp,$lcConve_tmp,$lcConde_tmp);
}
#-------------------------------------------------------------------------------------------------------------------------'

sub showInfo{ my($lcEmerg,$migrate,$lcConve,$lcConde,$polarity) = @_;
    my @lcEmerg = @$lcEmerg;
	my @migrate = @$migrate;
	my @lcConve = @$lcConve;
	my @lcConde = @$lcConde;
	#��������Ϣ
	print "�ֲ�����($polarity): @lcEmerg\n";
	print "Ǩ��($polarity): @migrate\n";
	print "�ֵض���($polarity): @lcConve\n";
	print "�ֲ�����($polarity): @lcConde\n";
	print "================================================================================\n";

	#��������Ԫ�ظ���
	my $nLcEmerg = @lcEmerg;
	my $nMigrate = @migrate;
	my $nLcConve = @lcConve;
	my $nLcConde = @lcConde;
	print "�ֲ�����($polarity)����: $nLcEmerg\n";
	print "Ǩ��($polarity)����: $nMigrate\n";
	print "�ֵض���($polarity)����: $nLcConve\n";
	print "�ֲ�����($polarity)����: $nLcConde\n";
	print "================================================================================\n";
}
#-------------------------------------------------------------------------------------------------------------------------'

#main
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
my @migrate_pos;
my @lcConve_pos;
my @lcConde_pos;

my @lcEmerg_neg;
my @migrate_neg;
my @lcConve_neg;
my @lcConde_neg;

#����ÿһ��
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
    my $num = $sheet->{Cells}[$row][0]->{Val};

	#��������ų�����������
    my $posTypeVal = $sheet->{Cells}[$row][4]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));
	
	#����ͳ��(����)
	my($lcEmerg_tmp,$migrate_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$posTypeVal);

	#������Ӧ����(����)
	if($lcEmerg_tmp != -1){
		push(@lcEmerg_pos,$lcEmerg_tmp);
	}
	
	if($migrate_tmp != -1){
		push(@migrate_pos,$migrate_tmp);
	}
	
	if($lcConve_tmp != -1){
		push(@lcConve_pos,$lcConve_tmp);
	}
	
	if($lcConde_tmp != -1){
		push(@lcConde_pos,$lcConde_tmp);
	}
	
	#��ø����ų�����������
	my $negTypeVal = $sheet->{Cells}[$row][5]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));
	
	#����ͳ��(����)
	($lcEmerg_tmp,$migrate_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$negTypeVal);
	
	#������Ӧ����(����)
	if($lcEmerg_tmp != -1){
		push(@lcEmerg_neg,$lcEmerg_tmp);
	}
	
	if($migrate_tmp != -1){
		push(@migrate_neg,$migrate_tmp);
	}
	
	if($lcConve_tmp != -1){
		push(@lcConve_neg,$lcConve_tmp);
	}
	
	if($lcConde_tmp != -1){
		push(@lcConde_neg,$lcConde_tmp);
	}
}

#��������Ϣ
showInfo(\@lcEmerg_pos,\@migrate_pos,\@lcConve_pos,\@lcConde_pos,"����");
showInfo(\@lcEmerg_neg,\@migrate_neg,\@lcConve_neg,\@lcConde_neg,"����");

#������ļ�(����IDL����)	
my $file = "papBPMagTypes.tmp";	
open FH,'>',$file;
print FH ";�ֲ�����(����)\n";
print FH "lcEmerg_pos = [".join(",",@lcEmerg_pos)."]\n";
print FH ";Ǩ��(����)\n";
print FH "migrate_pos = [".join(",",@migrate_pos)."]\n";
print FH ";�ֵض���(����)\n";
print FH "lcConve_pos = [".join(",",@lcConve_pos)."]\n";
print FH ";�ֲ�����(����)\n";
print FH "lcConde_pos = [".join(",",@lcConde_pos)."]\n";
print FH "\n";
print FH ";�ֲ�����(����)\n";
print FH "lcEmerg_neg = [".join(",",@lcEmerg_neg)."]\n";
print FH ";Ǩ��(����)\n";
print FH "migrate_neg = [".join(",",@migrate_neg)."]\n";
print FH ";�ֵض���(����)\n";
print FH "lcConve_neg = [".join(",",@lcConve_neg)."]\n";
print FH ";�ֲ�����(����)\n";
print FH "lcConde_neg = [".join(",",@lcConde_neg)."]\n";
close FH;

