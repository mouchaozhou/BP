sub classify{ my($num,$content) = @_; 
	#û��ƥ�䵽����-1
	my $earlyStage_tmp = -1; #ǰ��
	my $middleStage_tmp = -1; #����
	my $lateStage_tmp = -1; #����
	my $none_tmp = -1; #��
	
	#��ʼƥ��
	if($content =~ /ǰ��/){
		$earlyStage_tmp = $num;		
	}elsif($content =~ /����/){
		$middleStage_tmp = $num;
	}elsif($content =~ /����/){
		$lateStage_tmp = $num;
	}elsif($content =~ /��/){
		$none_tmp = $num;
	}
	
	return($earlyStage_tmp,$middleStage_tmp,$lateStage_tmp,$none_tmp);
}
#-------------------------------------------------------------------------------------------------------------------------'

sub getLifetime{ my($array,$sheet) = @_;
	my @array = @$array;
	my %hash;
	my $lifetime, $posMag, $negMag;
	foreach(@array){
		$lifetime = $sheet->{Cells}[$_+1][3]->{Val};  #����
		$posMag = $sheet->{Cells}[$_+1][6]->{Val};    #�����ų�����
		$negMag = $sheet->{Cells}[$_+1][7]->{Val};    #�����ų�����
		$hash{$_} = "$lifetime h  	$posMag  	$negMag";
	}
	return \%hash;	
}
#-------------------------------------------------------------------------------------------------------------------------'

sub showInfo{  my($hash,$str) = @_;
	my %hash = %$hash;
	my @array = keys(%hash);
	my $nArr = @array;
	#print "$str: @array\n";
	
	my $key;
	foreach $key(sort(keys(%hash))){
		$value = $hash{$key};
		print "$key => $value\n";
	}
	print "$str�ĸ���Ϊ: $nArr\n";
	print "====================================================\n";
}
#-------------------------------------------------------------------------------------------------------------------------'
#-------------------------------------------------------------------------------------------------------------------------'


#main
#ȡ��excel�����������Ӵ�ʱ��
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
my @earlyStage; #ǰ��
my @middleStage; #����
my @lateStage; #����
my @none; #��

foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	#�¼����
    my $num = $sheet->{Cells}[$row][0]->{Val};
	
	#������������Ӵ�ʱ������
    my $content = $sheet->{Cells}[$row][10]->{Val};
	$content = encode("gbk",decode("utf8",$content));
	
	#����ͳ��
	my($earlyStage,$middleStage,$lateStage,$none) = classify($num,$content);

	#������Ӧ����(����)
	if($earlyStage != -1){
		push(@earlyStage,$earlyStage);
	}
	
	if($middleStage != -1){
		push(@middleStage,$middleStage);
	}
		
	if($lateStage != -1){
		push(@lateStage,$lateStage);
	}
	
	if($none != -1){
		push(@none,$none);
	}
}

#������ϣ�������Ӧ��BP����
my $earlyStage_lifetime = getLifetime(\@earlyStage,$sheet);
my %earlyStage_lifetime = %$earlyStage_lifetime;

my $middleStage_lifetime = getLifetime(\@middleStage,$sheet);
my %middleStage_lifetime = %$middleStage_lifetime;

my $lateStage_lifetime = getLifetime(\@lateStage,$sheet);
my %lateStage_lifetime = %$lateStage_lifetime;

my $none_lifetime = getLifetime(\@none,$sheet);
my %none_lifetime = %$none_lifetime;



showInfo(\%earlyStage_lifetime,"ǰ��");
showInfo(\%middleStage_lifetime,"����");
showInfo(\%lateStage_lifetime,"����");
showInfo(\%none_lifetime,"��");

