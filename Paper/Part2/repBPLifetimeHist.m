%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ������ֱ��ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\Lifetime\papBPLifetime.eps';

% NUM: �������� TXT: �����ַ���
[NUM,TXT] = xlsread(inFile); 
% ȡ�����������
lifetime = str2double(TXT(3:end,4)); 

% �����׼��
fprintf('The std of lifetime is %f\n',std(lifetime));

fprintf('The max lifetime is %f\n',max(lifetime));
fprintf('The min lifetime is %f\n',min(lifetime));
fprintf('The average lifetime is %f\n',mean(lifetime));

% ֱ��ͼ��Χ
dis = 3.0 : 6.0 : 57.0; 

arrHist = hist(lifetime,dis);
arr = [0 : 6 : 60];
for i=1:length(arrHist)
    fprintf('%f -- %f : %f\n',arr(i),arr(i+1),arrHist(i));
end
% ��һ������
figure;
% ��ֱ��ͼ 
hist(lifetime,dis);
xlabel('Lifetime (h)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% ������ķ�Χ
axis([0,60,0,25]);
% �������label
set(gca,'XTick',0:6:60);
% ������ɫ
h = findobj(gca,'Type','patch');
set(h,'FaceColor','y','EdgeColor','k');  % k�Ǻ�ɫ
% ���eps�ļ�
print(gcf,'-dps',outFile);