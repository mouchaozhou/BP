%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BP�տ�ʼ����ʱ��AIA�ﵽ��ֵʱ���������Եľ���ֱ��ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\MagDistance\papBPMagDistance.eps';


% NUM: �������� TXT: �����ַ���
[NUM,TXT] = xlsread(inFile); 
% ȡ��BP�ճ���ʱ�ų��ľ���
beginMagDis = str2double(TXT(3:end,14));
% ȡ��BP�����ֵʱ�ų��ľ��� 
maxMagDis = str2double(TXT(3:end,15));

fprintf('The max beginMagDis is %f\n',max(beginMagDis));
fprintf('The min beginMagDis is %f\n',min(beginMagDis));
fprintf('=============================================================\n');
fprintf('The max maxMagDis is %f\n',max(maxMagDis));
fprintf('The min maxMagDis is %f\n',min(maxMagDis));
fprintf('=============================================================\n');

% ��ƽ��ֵ
fprintf('The mean beginMagDis is %f\n',mean(beginMagDis));
fprintf('The mean maxMagDis is %f\n',mean(maxMagDis));

% �Ȼ�beginMagDistance
figure('Position',[600,300,1000,500]);
subplot(1,2,1); %(�У��У�����ʾ��ͼ�ı�ţ�
% ֱ��ͼ��Χ
dis = 1.0 : 2.0 : 31.0; 
% ��ֱ��ͼ 
hist(beginMagDis,dis);
text(22,16,'Beginning','fontsize',13); 
xlabel('Distance (arcsec)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% ������ķ�Χ
axis([0,32,0,18]);
% �������label
set(gca,'XTick',0:2:32);
% ������ɫ
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','k');


% �ٻ�maxMagDistance
% ֱ��ͼ��Χ
subplot(1,2,2);
dis = 1.0 : 2.0 : 27.0; 
% ��ֱ��ͼ 
hist(maxMagDis,dis)
text(22,16,'Peak','fontsize',13); 
xlabel('Distance (arcsec)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% ������ķ�Χ
axis([0,28,0,18]);
% �������label
set(gca,'XTick',0:2:28);
% ������ɫ
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','k');
% ���eps�ļ�
% ����paperpositionΪauto,ʹͼ������������Ļ��ʾ��һ��
set(gcf,'PaperPositionMode','auto');
set(gcf,'Position',[5,5,900,400]);

% �洢ͼ��
print(gcf,'-dps',outFile);