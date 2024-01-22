%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  画寿命直方图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\Lifetime\papBPLifetime.eps';

% NUM: 所有数字 TXT: 所有字符串
[NUM,TXT] = xlsread(inFile); 
% 取出亮点的寿命
lifetime = str2double(TXT(3:end,4)); 

% 计算标准差
fprintf('The std of lifetime is %f\n',std(lifetime));

fprintf('The max lifetime is %f\n',max(lifetime));
fprintf('The min lifetime is %f\n',min(lifetime));
fprintf('The average lifetime is %f\n',mean(lifetime));

% 直方图范围
dis = 3.0 : 6.0 : 57.0; 

arrHist = hist(lifetime,dis);
arr = [0 : 6 : 60];
for i=1:length(arrHist)
    fprintf('%f -- %f : %f\n',arr(i),arr(i+1),arrHist(i));
end
% 打开一个窗口
figure;
% 作直方图 
hist(lifetime,dis);
xlabel('Lifetime (h)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% 设置轴的范围
axis([0,60,0,25]);
% 设置轴的label
set(gca,'XTick',0:6:60);
% 设置颜色
h = findobj(gca,'Type','patch');
set(h,'FaceColor','y','EdgeColor','k');  % k是黑色
% 输出eps文件
print(gcf,'-dps',outFile);