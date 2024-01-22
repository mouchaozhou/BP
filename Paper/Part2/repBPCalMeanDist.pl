# ��������ĺ���
sub round{ my($data, $index) = @_; #$indexΪ����С������λ��
   my $tmp = 10**$index;
   return int($data * $tmp + 0.5) / $tmp;
}
#-------------------------------------------------------------------------------------------------------------------------'


#main
#==========================================================================================================================
#	���������е�ƽ������
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;
use Statistics::Basic qw(:all);

# ��������
my (@emgBegDis, @emgPekDis);
my (@covBegDis, @covPekDis);
my (@locBegDis, @locPekDis);

# ����ָ��excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

# ȡ����һ����
my $sheet = ${$excel->{Worksheet}}[0];

# ����ÿһ��
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	# ��������ų�����������
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8", $posTypeVal));	
	
	# ��ø����ų�����������
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8", $negTypeVal));	
	
	# ����������ʱ�ų������
	my $startMagDis = $sheet->{Cells}[$row][13]->{Val};
	$startMagDis = round($startMagDis);
	
	# ��������ֵʱ�ų������
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

# �������ĸ���
my $nEmg = @emgBegDis;
print "Emergence: $nEmg\n";
my $nCov = @covBegDis;
print "Convergence: $nCov\n";
my $nLoc = @locBegDis;
print "Local Combination: $nLoc\n";

# ����ƽ��ֵ�ͷ���
# Emergence
print "Mean emergence begin distance: ".mean(@emgBegDis)."��".stddev(@emgBegDis)."\n";
print "Mean emergence peak  distance: ".mean(@emgPekDis)."��".stddev(@emgPekDis)."\n";
# Convergence
print "Mean convergence begin distance: ".mean(@covBegDis)."��".stddev(@covBegDis)."\n";
print "Mean convergence peak  distance: ".mean(@covPekDis)."��".stddev(@covPekDis)."\n";
# Local Combination
print "Mean Local Combination begin distance: ".mean(@locBegDis)."��".stddev(@locBegDis)."\n";
print "Mean Local Combination peak  distance: ".mean(@locPekDis)."��".stddev(@locPekDis)."\n";

