sub classify{ my($num,$content) = @_; 
	#没有匹配到就是-1
	my $earlyStage_tmp = -1; #前期
	my $middleStage_tmp = -1; #中期
	my $lateStage_tmp = -1; #后期
	my $none_tmp = -1; #无
	
	#开始匹配
	if($content =~ /前期/){
		$earlyStage_tmp = $num;		
	}elsif($content =~ /中期/){
		$middleStage_tmp = $num;
	}elsif($content =~ /后期/){
		$lateStage_tmp = $num;
	}elsif($content =~ /无/){
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
		$lifetime = $sheet->{Cells}[$_+1][3]->{Val};  #寿命
		$posMag = $sheet->{Cells}[$_+1][6]->{Val};    #正极磁场类型
		$negMag = $sheet->{Cells}[$_+1][7]->{Val};    #负极磁场类型
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
	print "$str的个数为: $nArr\n";
	print "====================================================\n";
}
#-------------------------------------------------------------------------------------------------------------------------'
#-------------------------------------------------------------------------------------------------------------------------'


#main
#取出excel中主正负极接触时期
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
my @earlyStage; #前期
my @middleStage; #中期
my @lateStage; #后期
my @none; #无

foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	#事件编号
    my $num = $sheet->{Cells}[$row][0]->{Val};
	
	#获得主正负极接触时期内容
    my $content = $sheet->{Cells}[$row][10]->{Val};
	$content = encode("gbk",decode("utf8",$content));
	
	#分类统计
	my($earlyStage,$middleStage,$lateStage,$none) = classify($num,$content);

	#存入相应数组(正极)
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

#创建哈希表，计算对应的BP寿命
my $earlyStage_lifetime = getLifetime(\@earlyStage,$sheet);
my %earlyStage_lifetime = %$earlyStage_lifetime;

my $middleStage_lifetime = getLifetime(\@middleStage,$sheet);
my %middleStage_lifetime = %$middleStage_lifetime;

my $lateStage_lifetime = getLifetime(\@lateStage,$sheet);
my %lateStage_lifetime = %$lateStage_lifetime;

my $none_lifetime = getLifetime(\@none,$sheet);
my %none_lifetime = %$none_lifetime;



showInfo(\%earlyStage_lifetime,"前期");
showInfo(\%middleStage_lifetime,"中期");
showInfo(\%lateStage_lifetime,"后期");
showInfo(\%none_lifetime,"无");

