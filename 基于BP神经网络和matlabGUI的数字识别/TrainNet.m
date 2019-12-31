function TrainNet()

load('MNIST_data_matlab-master\MNIST_for_BP.mat');
%��ȡ�ĸ��ļ�

global netdata database
%����������

%����������
sam_sum = 60000;
input = 784;
output = 10;
hid = 20;
w1 = randn([input,hid]);
baocun = w1;
w2 = randn([hid,output]);
bias1 = zeros(hid,1);
bias2 = zeros(output,1);
rate1 = 0.005;
rate2 = 0.005;                %����ѧϰ��

%�����������������ʱ�洢����
temp1 = zeros(hid,1);
net = temp1;
temp2 = zeros(output,1);
z = temp2;

%sigmoid���� f = 1/(e^-x + 1)   ��Ϊ f' = f*(1-f)
fprintf("\n\n����ʶ������ѵ����ʼ\n");
fprintf("�������������СΪ%d*1,����������СΪ%d*1\n\n", input, output);
for num = 1:100
    num
for i = 1:sam_sum
    
    label = zeros(10,1);
    label(train_lab(i)+1,1) = 1;

    %forward
    %�˴�ѡ��784*1��train_ima���������Ҫ��(:,1)
    temp1 = train_ima(:,i)'*w1 + bias1';
    net = sigmoid(temp1);
    %�˴�ѡ��hid*1�����ز����
    temp2 = net*w2 + bias2';
    z = sigmoid(temp2);
    z = z';net = net';
    %backward
    error = label - z;
    deltaZ = error.*z.*(1-z);
    deltaNet = net.*(1-net).*(w2*deltaZ);
    for j = 1:output
        w2(:,j) = w2(:,j) + rate2*deltaZ(j).*net;
    end
    for j = 1:hid
        w1(:,j) = w1(:,j) + rate1*deltaNet(j).*train_ima(:,i);
    end
    bias2 = bias2 + rate2*deltaZ;
    bias1 = bias1 + rate1*deltaNet;
   

end
end
netdata.bias1 = bias1;
netdata.bias2 = bias2;
netdata.w1 = w1;
netdata.w2 = w2;
database.train_ima = train_ima;
database.train_lab = train_lab;
database.test_ima = test_ima;
database.test_lab = test_lab;
fprintf("\n����ѵ�����\n���ݼ���С%d����ѵ��%d��\n", i, num);
test(); %���ò��Լ�����

save figureNetData.mat netdata database
%��������

end










