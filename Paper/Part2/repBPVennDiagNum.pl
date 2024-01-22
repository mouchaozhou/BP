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
#	ͳ�ƴų��γɵ������Ӧ�ĸ���
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;

# ����ָ��excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

# ȡ����һ����
my $sheet = ${$excel->{Worksheet}}[0];

# �������ͳ�Ʊ���
my $nAA = 0;
my $nAB = 0;
my $nAC = 0;
my $nBB = 0;
my $nBC = 0;
my $nCC = 0;

# ����ÿһ��
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}) {
	# ��������ų�����������
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));	
	# �����ų����з���
	$posTypeVal = classify($posTypeVal);
	
	# ��ø����ų�����������
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));	
	# �����ų����з���
	$negTypeVal = classify($negTypeVal);
	
	# ͳ�Ƹ���
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


