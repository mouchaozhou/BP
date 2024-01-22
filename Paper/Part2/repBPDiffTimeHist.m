%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ���ų�����ʱ�����������ʱ��Ĳ�ֵ��״ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\DiffTime\papBPDiffTime.eps';

% NUM: �������� TXT: �����ַ���
[NUM,TXT] = xlsread(inFile); 

% ȡ���ų�����ʱ�����������ʱ��Ĳ�ֵ
diffTimeTmp = TXT(3:end,18);

% �����������
diffTime = [];

% ȡ������е����� 
for i = 1 : length(diffTimeTmp)
    if ~strcmp(diffTimeTmp{i},'null') && ~strcmp(diffTimeTmp{i},'diff') 
        diffTime = [diffTime,str2double(diffTimeTmp{i})];
    end
end


fprintf('The length of diffTime is %f\n',length(diffTime));
fprintf('The max diffTime is %f\n',max(diffTime));
fprintf('The min diffTime is %f\n',min(diffTime));
fprintf('The average of diffTime is %f\n',mean(diffTime));

% ֱ��ͼ��Χ
dis = 0.2 : 0.4 : 3.0; 

arrHist = hist(diffTime,dis);
arr = [0:0.4:3.2];
for i=1:length(arrHist)
    fprintf('%f -- %f : %f\n',arr(i),arr(i+1),arrHist(i));
end

% ��һ������
figure;
% ��ֱ��ͼ 
hist(diffTime,dis);
xlabel('Time difference (h)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% ������ķ�Χ
axis([0,3.2,0,10]);
% �������label
set(gca,'XTick',0:0.4:3.2);
% ������ɫ
h = findobj(gca,'Type','patch');
set(h,'FaceColor','g','EdgeColor','k');  % k�Ǻ�ɫ
% ���eps�ļ�
print(gcf,'-dps',outFile);
