#Windows

sub classify{ my($num,$typeVal) = @_; 
	#没有匹配到就是-1
    my $lcEmerg_tmp = -1;
	my $migrate_tmp = -1;
	my $lcConve_tmp = -1;
	my $lcConde_tmp = -1;
	
	#开始匹配
	if($typeVal =~ /局部浮现/){
		$lcEmerg_tmp = $num;
	}
	
	if($typeVal =~ /迁移/){
		$migrate_tmp = $num;
	}
	
	if($typeVal =~ /局地对流/){
		$lcConve_tmp = $num;
	}
	
	if($typeVal =~ /局部凝聚/){
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
	#输出相关信息
	print "局部浮现($polarity): @lcEmerg\n";
	print "迁移($polarity): @migrate\n";
	print "局地对流($polarity): @lcConve\n";
	print "局部凝聚($polarity): @lcConde\n";
	print "================================================================================\n";

	#计算数组元素个数
	my $nLcEmerg = @lcEmerg;
	my $nMigrate = @migrate;
	my $nLcConve = @lcConve;
	my $nLcConde = @lcConde;
	print "局部浮现($polarity)个数: $nLcEmerg\n";
	print "迁移($polarity)个数: $nMigrate\n";
	print "局地对流($polarity)个数: $nLcConve\n";
	print "局部凝聚($polarity)个数: $nLcConde\n";
	print "================================================================================\n";
}
#-------------------------------------------------------------------------------------------------------------------------'

#main
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
my @migrate_pos;
my @lcConve_pos;
my @lcConde_pos;

my @lcEmerg_neg;
my @migrate_neg;
my @lcConve_neg;
my @lcConde_neg;

#遍历每一行
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
    my $num = $sheet->{Cells}[$row][0]->{Val};

	#获得正极磁场的类型内容
    my $posTypeVal = $sheet->{Cells}[$row][4]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));
	
	#分类统计(正极)
	my($lcEmerg_tmp,$migrate_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$posTypeVal);

	#存入相应数组(正极)
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
	
	#获得负极磁场的类型内容
	my $negTypeVal = $sheet->{Cells}[$row][5]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));
	
	#分类统计(负极)
	($lcEmerg_tmp,$migrate_tmp,$lcConve_tmp,$lcConde_tmp) = classify($num,$negTypeVal);
	
	#存入相应数组(负极)
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

#输出相关信息
showInfo(\@lcEmerg_pos,\@migrate_pos,\@lcConve_pos,\@lcConde_pos,"正极");
showInfo(\@lcEmerg_neg,\@migrate_neg,\@lcConve_neg,\@lcConde_neg,"负极");

#输出到文件(方便IDL处理)	
my $file = "papBPMagTypes.tmp";	
open FH,'>',$file;
print FH ";局部浮现(正极)\n";
print FH "lcEmerg_pos = [".join(",",@lcEmerg_pos)."]\n";
print FH ";迁移(正极)\n";
print FH "migrate_pos = [".join(",",@migrate_pos)."]\n";
print FH ";局地对流(正极)\n";
print FH "lcConve_pos = [".join(",",@lcConve_pos)."]\n";
print FH ";局部凝聚(正极)\n";
print FH "lcConde_pos = [".join(",",@lcConde_pos)."]\n";
print FH "\n";
print FH ";局部浮现(负极)\n";
print FH "lcEmerg_neg = [".join(",",@lcEmerg_neg)."]\n";
print FH ";迁移(负极)\n";
print FH "migrate_neg = [".join(",",@migrate_neg)."]\n";
print FH ";局地对流(负极)\n";
print FH "lcConve_neg = [".join(",",@lcConve_neg)."]\n";
print FH ";局部凝聚(负极)\n";
print FH "lcConde_neg = [".join(",",@lcConde_neg)."]\n";
close FH;

