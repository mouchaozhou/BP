%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  画磁场浮现时间与亮点出现时间的差值柱状图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
inFile = '..\..\HMI_BP\Program\hmiBPCases.xlsx';
outFile = '..\Image\DiffTime\papBPDiffTime.eps';

% NUM: 所有数字 TXT: 所有字符串
[NUM,TXT] = xlsread(inFile); 

% 取出磁场浮现时间与亮点出现时间的差值
diffTimeTmp = TXT(3:end,18);

% 创建结果数组
diffTime = [];

% 取出结果中的数字 
for i = 1 : length(diffTimeTmp)
    if ~strcmp(diffTimeTmp{i},'null') && ~strcmp(diffTimeTmp{i},'diff') 
        diffTime = [diffTime,str2double(diffTimeTmp{i})];
    end
end


fprintf('The length of diffTime is %f\n',length(diffTime));
fprintf('The max diffTime is %f\n',max(diffTime));
fprintf('The min diffTime is %f\n',min(diffTime));
fprintf('The average of diffTime is %f\n',mean(diffTime));

% 直方图范围
dis = 0.2 : 0.4 : 3.0; 

arrHist = hist(diffTime,dis);
arr = [0:0.4:3.2];
for i=1:length(arrHist)
    fprintf('%f -- %f : %f\n',arr(i),arr(i+1),arrHist(i));
end

% 打开一个窗口
figure;
% 作直方图 
hist(diffTime,dis);
xlabel('Time difference (h)','fontsize',13);
ylabel('BP numbers (count)','fontsize',13);
% 设置轴的范围
axis([0,3.2,0,10]);
% 设置轴的label
set(gca,'XTick',0:0.4:3.2);
% 设置颜色
h = findobj(gca,'Type','patch');
set(h,'FaceColor','g','EdgeColor','k');  % k是黑色
% 输出eps文件
print(gcf,'-dps',outFile);
