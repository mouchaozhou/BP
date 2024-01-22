%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BP刚开始出现时和AIA达到峰值时两个主极性的距离直方图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\MagDistance\papBPMagDistance.eps';


% NUM: 所有数字 TXT: 所有字符串
[NUM,TXT] = xlsread(inFile); 
% 取出BP刚出现时磁场的距离
beginMagDis = str2double(TXT(3:end,14));
% 取出BP到达峰值时磁场的距离 
maxMagDis = str2double(TXT(3:end,15));

fprintf('The max beginMagDis is %f\n',max(beginMagDis));
fprintf('The min beginMagDis is %f\n',min(beginMagDis));
fprintf('=============================================================\n');
fprintf('The max maxMagDis is %f\n',max(maxMagDis));
fprintf('The min maxMagDis is %f\n',min(maxMagDis));
fprintf('=============================================================\n');

% 求平均值
fprintf('The mean beginMagDis is %f\n',mean(beginMagDis));
fprintf('The mean maxMagDis is %f\n',mean(maxMagDis));

% 先画beginMagDistance
figure('Position',[600,300,1000,500]);
subplot(1,2,1); %(行，列，该显示的图的编号）
% 直方图范围
dis = 1.0 : 2.0 : 31.0; 
% 作直方图 
hist(beginMagDis,dis);
text(22,16,'Beginning','fontsize',13); 
xlabel('Distance (arcsec)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% 设置轴的范围
axis([0,32,0,18]);
% 设置轴的label
set(gca,'XTick',0:2:32);
% 设置颜色
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','k');


% 再画maxMagDistance
% 直方图范围
subplot(1,2,2);
dis = 1.0 : 2.0 : 27.0; 
% 作直方图 
hist(maxMagDis,dis)
text(22,16,'Peak','fontsize',13); 
xlabel('Distance (arcsec)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% 设置轴的范围
axis([0,28,0,18]);
% 设置轴的label
set(gca,'XTick',0:2:28);
% 设置颜色
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','k');
% 输出eps文件
% 设置paperposition为auto,使图像比例输出与屏幕显示的一致
set(gcf,'PaperPositionMode','auto');
set(gcf,'Position',[5,5,900,400]);

% 存储图像
print(gcf,'-dps',outFile);