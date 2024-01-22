%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  画对消（磁场模型）类型柱状图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\CancelStat\papBPCancelState.eps';

% NUM: 所有数字 TXT: 所有字符串
[NUM,TXT] = xlsread(inFile); 

% 取出亮点的对消类型
cancelStateTmp = TXT(3:end,12); 

% 求出数组元素个数
n = length(cancelStateTmp);

% 创建数组
cancelState = zeros(1,n);

% 转换
for i = 1 : n
	switch cancelStateTmp{i}  % cell 数组取出元素的方法
	case 'small'
		cancelState(i) = 1;
	case 'converge'
		cancelState(i) = 2;
	case 'CME' 
		cancelState(i) = 3;
	otherwise
		disp('Wrong cancelState!');
	end
end

% 计算百分比
% 直方图范围
dis = 1.0 : 1.0 : 3.0; 
arrHist = double(hist(cancelState,dis));
% perSma = arrHist(1) / sum(arrHist) * 100.; % 45.7
% perCon = arrHist(2) / sum(arrHist) * 100.; % 50
% perCME = arrHist(3) / sum(arrHist) * 100.; % 4.3
perSma = '45.7%';
perCon = '50.0%';
perCME = '4.3%';

% 作柱状图 
figure;
hBar = bar(arrHist,0.4);
title('Cancellation');
xlabel('Cancellation types');
ylabel('BP numbers');
% 设置y轴的范围
ylim([0,40]);
%设置x轴
set(gca,'XTickLabel',{'I','II','III'}) 
% 设置颜色
hChi = get(hBar,'children');
set(hChi,'FaceVertexCData',[4;2;5]);
% 添加字符
text(0.9,33,perSma);
text(1.9,36,perCon);
text(2.9,4,perCME);
% 输出eps文件
print(gcf,'-dps',outFile);