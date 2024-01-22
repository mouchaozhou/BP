sub classify{ my($typeVal) = @_; 
	if($typeVal eq "Emergence"){
		return "A";
	}
	
	if($typeVal eq "Convergence"){
		return "B";
	}
	
	if($typeVal eq "Local Combination"){
		return "C";
	}


	return "null";
}
#-------------------------------------------------------------------------------------------------------------------------'

sub classifyHeatMech{ my($typeVal) = @_; 
	if($typeVal =~ /small/){
		return "\\I";
	}
	
	if($typeVal =~ /converge/){
		return "\\II";
	}
	
	if($typeVal =~ /CME/){
		return "\\III";
	}

	return "null";
}
#-------------------------------------------------------------------------------------------------------------------------'

sub formatDate{ my($time) = @_;
	return substr($time,5,11);	
}
#-------------------------------------------------------------------------------------------------------------------------'

#四舍五入的函数
sub round{ my($data, $index) = @_; #$index为保留小数点后的位数
   my $tmp = 10**$index;
   return int($data * $tmp + 0.5) / $tmp;
}

#main
#==========================================================================================================================
#	创建Latex中的表格
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;

#输出到文件(方便复制到Latex)	
my $file = "papBPBuildTable.tmp";	
open FH,'>',$file;

#预先写入一些内容
print FH '\\newpage'."\n";
print FH '\\begin{onecolumn}'."\n";
print FH '\\begin{scriptsize}'."\n";
print FH '\\begin{longtable}{|c|c|c|c|c|c|c|c|c|c|}'."\n";
print FH '\\caption{The studied BPs, formations of their associated MBFs, and magnetic cancellations associated with heating.}'."\n";
print FH '\\label{tab_analysis}\\\\'."\n";
print FH '\\hline'."\n";
print FH '&Location&&&&\\multicolumn{2}{c|}{Bipolar}&&\\multicolumn{2}{c|}{Distance of main polarities}\\\\'."\n";
print FH 'No. &(x,y)& Start Time & End time &Duration&\\multicolumn{2}{c|}{formation\\tablenotemark{\\spadesuit}}&Cancel-&\\multicolumn{2}{c|}{(arcsec)}\\\\'."\n";
print FH '\\cline{6-7}'."\n";
print FH '\\cline{9-10}'."\n";
print FH '&[arcsec]&&&(hours)& Positive & Negative &lation\\tablenotemark{\\clubsuit}& Beginning\\tablenotemark{\\ast}& Peak\\tablenotemark{\\star}\\\\'."\n";
print FH '\\hline'."\n";
print FH '\\endfirsthead'."\n";
print FH "\n";
print FH '\\multicolumn{10}{c}'."\n";
print FH '{{\\bfseries \\tablename\\ \\thetable{} -- continued from previous page}}\\\\'."\n";
print FH '\\hline'."\n";
print FH '&Location&&&&\\multicolumn{2}{c|}{Bipolar}&&\\multicolumn{2}{c|}{Distance of main polarities}\\\\'."\n";
print FH 'No. &(x,y)& Start Time & End time &Duration&\\multicolumn{2}{c|}{formation\\tablenotemark{\\spadesuit}}&Cancel-&\\multicolumn{2}{c|}{(arcsec)}\\\\'."\n";
print FH '\\cline{6-7}'."\n";
print FH '\\cline{9-10}'."\n";
print FH '&[arcsec]&&&(hours)& Positive & Negative &lation\\tablenotemark{\\clubsuit}& Beginning\\tablenotemark{\\ast}& Peak\\tablenotemark{\\star}\\\\'."\n";
print FH '\\hline'."\n";
print FH '\\endhead'."\n";
print FH "\n";
print FH '\\hline \\multicolumn{10}{r}{{Continued on next page}}'."\n";
print FH '\\endfoot'."\n";
print FH "\n";
print FH '\\hline \\hline'."\n";
print FH '\\endlastfoot'."\n";

#读入指定excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

#取出第一个表
my $sheet = ${$excel->{Worksheet}}[0];

#遍历每一行
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	#事件编号
    my $num = $sheet->{Cells}[$row][0]->{Val};
	
	#开始时间
	my $startTime = $sheet->{Cells}[$row][1]->{Val};
	$startTime = formatDate($startTime);
	
	#结束时间
	my $endTime = $sheet->{Cells}[$row][2]->{Val};
	$endTime = formatDate($endTime);
	
	#寿命
	my $lifetime = $sheet->{Cells}[$row][3]->{Val};
	
	#获得正极磁场的类型内容
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));	
	#正极磁场进行分类
	$posTypeVal = classify($posTypeVal);
	
	#获得负极磁场的类型内容
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));	
	#负极磁场进行分类
	$negTypeVal = classify($negTypeVal);
	
	#如果正极负极有一个是B（convergence）类型，那么另一种如果不是B类型，则必须是A+B或A+C
	if($posTypeVal eq "B"){
		if($negTypeVal ne "B"){
			$negTypeVal = $negTypeVal."+B";
		}
	}else{
		if($negTypeVal eq "B"){
			$posTypeVal = $posTypeVal."+B";
		}
	}
	
	#获得加热机制(磁场模型)
	my $heatMech = $sheet->{Cells}[$row][11]->{Val};
	$heatMech = encode("gbk",decode("utf8",$heatMech));
	#加热机制进行分类
	$heatMech = classifyHeatMech($heatMech);
		
	#获得中心坐标
	my $position = $sheet->{Cells}[$row][12]->{Val};
	$position =~ s/^\s+|\s+$//g;  #去除开头和结尾的空格
	my @arrPos = split(/\s+/,$position); #默认以/\s+/为模式
	#x坐标
	if($arrPos[0] < 0){
		$arrPos[0] = '$-$'.abs(round($arrPos[0]));  #负号的处理
	}else{
		$arrPos[0] = round($arrPos[0],0); 
	}
	#y坐标
	if($arrPos[1] < 0){
		$arrPos[1] = '$-$'.abs(round($arrPos[1]));
	}else{
		$arrPos[1] = round($arrPos[1],0);
	}
	$position = join(", ",@arrPos);  #合起来

	#获得亮点出现时磁场间距离
	my $startMagDis = $sheet->{Cells}[$row][13]->{Val};
	$startMagDis = round($startMagDis);
	
	#获得亮点峰值时磁场间距离
	my $peakMagDis = $sheet->{Cells}[$row][14]->{Val};
	$peakMagDis = round($peakMagDis);
	
	if($posTypeVal eq "null" || $negTypeVal eq "null"){
		next;
	}
	
	print FH "$num & $position & $startTime & $endTime & $lifetime & $posTypeVal & $negTypeVal & $heatMech & $startMagDis & $peakMagDis\\\\"."\n";
	print FH '\\hline'."\n";
}


print FH '\\multicolumn{10}{|c|}{$\\spadesuit$ Formation of an MBF. A: emergence; B: convergence; C: local coalescence}\\\\'."\n";
print FH '\\multicolumn{10}{|c|}{$\\clubsuit$ Magnetic cancellation associated with BP heating occurs:}\\\\'."\n";
print FH '\\multicolumn{10}{|c|}{\\I: between the MBF and small weak fields;}\\\\'."\n";
print FH '\\multicolumn{10}{|c|}{ \\II: within the main polarities of an MBF moving from far distance;}\\\\'."\n";
print FH '\\multicolumn{10}{|c|}{ \\III: within the main polarities of an MBF emerging in the same location.}\\\\'."\n";
print FH '\\multicolumn{10}{|c|}{$\\ast$ Beginning: when a BP starts to be seen in AIA\\,193\\,\\AA.}\\\\'."\n";
print FH '\\multicolumn{10}{|c|}{$\\star$ Peak: when a BP at its emission peak is seen in AIA\\,193\\,\\AA.}'."\n";
print FH '\\end{longtable}'."\n";
print FH '\\end{scriptsize}'."\n";
print FH '\\end{onecolumn}'."\n";
close FH;

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	