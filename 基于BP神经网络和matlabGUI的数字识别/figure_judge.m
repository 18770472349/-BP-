function weight = figure_judge(im28_28)
global netdata
im2828_1 = reshape(im28_28', 28*28, 1);
if isempty(netdata)
  load 'figureNetData.mat' netdata;
end
temp1 = im2828_1'*netdata.w1 + netdata.bias1';
net = sigmoid(temp1);
%此处选用hid*1的隐藏层矩阵
temp2 = net*netdata.w2 + netdata.bias2';
z = sigmoid(temp2);
% weight = z;
[maxn,inx] = max(z);
% inx = inx -1
% maxn
weight = [inx-1, maxn];

end
