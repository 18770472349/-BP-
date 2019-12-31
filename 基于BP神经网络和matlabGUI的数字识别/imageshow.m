%% 运行代码区
global database
if isempty(database)
  load 'figureNetData.mat' database;
end
%读取文件


plotsize = [20, 20];
imagegap = 2;
imsize = [sqrt(max(size(database.test_ima(:,1)))), sqrt(max(size(database.test_ima(:,1))))];

imbuf = ... %imagebuffer
  ones(imsize(1)*plotsize(1)+plotsize(1)*imagegap-imagegap,...
     imsize(2)*plotsize(2)+plotsize(2)*imagegap-imagegap)*255;

try
  close('figure10')
catch
%   disp('figure10 不存在')
end
hf = figure(10);

set(hf, 'Name', 'figure10', 'NumberTitle', 'off');





for i = 1:plotsize(1)
  for j = 1:plotsize(2)

    singledata = database.train_ima(:,i*plotsize(2)-plotsize(2)+j);
%     singledata = database.test_ima(:,i*plotsize(2)-plotsize(2)+j);
    
    start_point = [(i-1)*(imagegap+imsize(1))+1, (j-1)*(imagegap+imsize(2))+1];
    imbuf(start_point(1):(start_point(1)+imsize(1)-1), start_point(2):(start_point(2)+imsize(2)-1))...
      =reshape(singledata,imsize)';
    
  end
end
imshow(imbuf);



%% 草稿测试区


% start_point(1):start_point(1)+imsize(1)-1
% start_point(2):start_point(2)+imsize(2)-1
% 
% 
% sumnum = 10;
% 
% truenum = reshape(database.test_lab(1:sumnum), 1, max(size(database.test_lab(1:sumnum))))
% mynum = [1 1 1 1 1 1]
% outnum = reshape(out_lab(1:sumnum), 1, max(size(out_lab(1:sumnum))))
% 
% reshape(database.test_lab(1:10), 1, max(size(database.test_lab(1:10))))
% 
% 
% 
% 
% imshow(database.test_ima(:,1:10:10000))
% 
% 
% singledata = database.test_ima(:,1);
% len = max(size(singledata));
% 
% imshow(reshape(singledata,[sqrt(len), sqrt(len)]));
% 
% reshape(1:10,[2,5])
% reshape(1:10,2,5)



