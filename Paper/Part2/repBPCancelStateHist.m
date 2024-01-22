%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ���������ų�ģ�ͣ�������״ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\CancelStat\papBPCancelState.eps';

% NUM: �������� TXT: �����ַ���
[NUM,TXT] = xlsread(inFile); 

% ȡ������Ķ�������
cancelStateTmp = TXT(3:end,12); 

% �������Ԫ�ظ���
n = length(cancelStateTmp);

% ��������
cancelState = zeros(1,n);

% ת��
for i = 1 : n
	switch cancelStateTmp{i}  % cell ����ȡ��Ԫ�صķ���
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

% ����ٷֱ�
% ֱ��ͼ��Χ
dis = 1.0 : 1.0 : 3.0; 
arrHist = double(hist(cancelState,dis));
% perSma = arrHist(1) / sum(arrHist) * 100.; % 45.7
% perCon = arrHist(2) / sum(arrHist) * 100.; % 50
% perCME = arrHist(3) / sum(arrHist) * 100.; % 4.3
perSma = '45.7%';
perCon = '50.0%';
perCME = '4.3%';

% ����״ͼ 
figure;
hBar = bar(arrHist,0.4);
title('Cancellation');
xlabel('Cancellation types');
ylabel('BP numbers');
% ����y��ķ�Χ
ylim([0,40]);
%����x��
set(gca,'XTickLabel',{'I','II','III'}) 
% ������ɫ
hChi = get(hBar,'children');
set(hChi,'FaceVertexCData',[4;2;5]);
% ����ַ�
text(0.9,33,perSma);
text(1.9,36,perCon);
text(2.9,4,perCME);
% ���eps�ļ�
print(gcf,'-dps',outFile);