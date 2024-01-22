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

#��������ĺ���
sub round{ my($data, $index) = @_; #$indexΪ����С������λ��
   my $tmp = 10**$index;
   return int($data * $tmp + 0.5) / $tmp;
}

#main
#==========================================================================================================================
#	����Latex�еı��
#==========================================================================================================================
use strict;
use warnings;
use Spreadsheet::XLSX;
use Encode;

#������ļ�(���㸴�Ƶ�Latex)	
my $file = "papBPBuildTable.tmp";	
open FH,'>',$file;

#Ԥ��д��һЩ����
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

#����ָ��excel
my $excel = Spreadsheet::XLSX->new('hmiBPCases.xlsx');

#ȡ����һ����
my $sheet = ${$excel->{Worksheet}}[0];

#����ÿһ��
foreach my $row ($sheet->{MinRow}+2 .. $sheet->{MaxRow}){
	#�¼����
    my $num = $sheet->{Cells}[$row][0]->{Val};
	
	#��ʼʱ��
	my $startTime = $sheet->{Cells}[$row][1]->{Val};
	$startTime = formatDate($startTime);
	
	#����ʱ��
	my $endTime = $sheet->{Cells}[$row][2]->{Val};
	$endTime = formatDate($endTime);
	
	#����
	my $lifetime = $sheet->{Cells}[$row][3]->{Val};
	
	#��������ų�����������
    my $posTypeVal = $sheet->{Cells}[$row][6]->{Val};
	$posTypeVal = encode("gbk",decode("utf8",$posTypeVal));	
	#�����ų����з���
	$posTypeVal = classify($posTypeVal);
	
	#��ø����ų�����������
	my $negTypeVal = $sheet->{Cells}[$row][7]->{Val};
	$negTypeVal = encode("gbk",decode("utf8",$negTypeVal));	
	#�����ų����з���
	$negTypeVal = classify($negTypeVal);
	
	#�������������һ����B��convergence�����ͣ���ô��һ���������B���ͣ��������A+B��A+C
	if($posTypeVal eq "B"){
		if($negTypeVal ne "B"){
			$negTypeVal = $negTypeVal."+B";
		}
	}else{
		if($negTypeVal eq "B"){
			$posTypeVal = $posTypeVal."+B";
		}
	}
	
	#��ü��Ȼ���(�ų�ģ��)
	my $heatMech = $sheet->{Cells}[$row][11]->{Val};
	$heatMech = encode("gbk",decode("utf8",$heatMech));
	#���Ȼ��ƽ��з���
	$heatMech = classifyHeatMech($heatMech);
		
	#�����������
	my $position = $sheet->{Cells}[$row][12]->{Val};
	$position =~ s/^\s+|\s+$//g;  #ȥ����ͷ�ͽ�β�Ŀո�
	my @arrPos = split(/\s+/,$position); #Ĭ����/\s+/Ϊģʽ
	#x����
	if($arrPos[0] < 0){
		$arrPos[0] = '$-$'.abs(round($arrPos[0]));  #���ŵĴ���
	}else{
		$arrPos[0] = round($arrPos[0],0); 
	}
	#y����
	if($arrPos[1] < 0){
		$arrPos[1] = '$-$'.abs(round($arrPos[1]));
	}else{
		$arrPos[1] = round($arrPos[1],0);
	}
	$position = join(", ",@arrPos);  #������

	#����������ʱ�ų������
	my $startMagDis = $sheet->{Cells}[$row][13]->{Val};
	$startMagDis = round($startMagDis);
	
	#��������ֵʱ�ų������
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

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	