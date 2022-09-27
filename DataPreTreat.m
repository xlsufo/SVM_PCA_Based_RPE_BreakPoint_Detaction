%--------------函数说明-------------  
% 整合样本
% 训练集中左断点正样本图片数量为493，负样本图片数量为450
% 右断点正样本图片数量496，负样本图片数量为421
% 图片大小为81*81
%    
% 测试集为5组图片，数量为52，74，48，74，74，图片大小为1024*200
%    
%-----------------------------------  
function [trainData,testData] = DataPreTreat()

%% 加载测试集标记
testData.markers1=load('./TestImg/markers1.mat');
testData.markers2=load('./TestImg/markers2.mat');
testData.markers3=load('./TestImg/markers3.mat');
testData.markers4=load('./TestImg/markers4.mat');
testData.markers5=load('./TestImg/markers5.mat');


%% 对所有的图片数据进行前处理
numLeftPosi=493;
numLeftNega=450;
numLeft=numLeftPosi+numLeftNega;
numRightPosi=496;
numRightNega=421;
numRight=numRightPosi+numRightNega;
trainImglength=81*81;
numTest=[52,74,48,74,74];
testImglength=200*1024;

trainData.numLeftPosi=numLeftPosi;
trainData.numLeftNega=numLeftNega
trainData.numLeft=numLeft;
trainData.numRightPosi=numRightPosi;
trainData.numRightNega=numRightNega;
trainData.numRight=numRight;
trainData.trainImglength=trainImglength;
testData.numTest=numTest;
testData.testImglength=testImglength;

trainData.left=zeros(trainImglength,numLeft); %初始化数据
trainData.right=zeros(trainImglength,numRight); %初始化数据
 %根据循环改变名称，初始化测试数据
for i=1:5
    name_string = ['testData.data' num2str(i) '=zeros(testImglength,numTest(i));'];
    eval(name_string);
end

% 读取训练样本
for i=1:4
    % 图像路径
    imgPath =['./TrainImg/',num2str(i),'/'];
    imgDir  = dir([imgPath, '/*.bmp']); % 遍历所有bmp格式文件
    for j = 1:length(imgDir)          % 遍历结构体就可以一一处理图片了
    [img,map] = imread([imgPath imgDir(j).name]); %读取每张图片
    img=ind2gray(img,map); %序列转为灰度
    %img=double(img)/255; %归一化
    %imgMed=medfilt2(img,[5 5]);%中值滤波
    imgMed=img;
    %imgMed=mat2gray(imgMed);
    switch i
        case 1
            trainData.left(:,j)=imgMed(:); %转为列向量存储
            trainData.leftLabel(1,j)=1; %添加标签
        case 2
            trainData.right(:,j)=imgMed(:); %转为列向量存储
            trainData.rightLabel(1,j)=1; %添加标签
        case 3
            trainData.left(:,numLeftPosi+j)=imgMed(:); %转为列向量存储
            trainData.leftLabel(1,numLeftPosi+j)=0; %添加标签
        case 4
            trainData.right(:,numRightPosi+j)=imgMed(:); %转为列向量存储
            trainData.rightLabel(1,numRightPosi+j)=0; %添加标签
    end

    end
end
     
%测试集数据获取
for i=1:5
    % 图像路径
    imgPath =['./TestImg/' num2str(i) '/'];
    imgDir  = dir([imgPath, '/*.bmp']); % 遍历所有bmp格式文件
    picIndex=zeros(1,length(imgDir)); %初始化图片序列存储
    for index=1:length(imgDir)  
        stingImgDirName=erase(imgDir(index).name,'.bmp');
        picIndex(index)=str2double(stingImgDirName); %提取图片名序列
    end
    %获取测试集名称表
    run_string = ['testData.data' num2str(i) 'Label' '=picIndex;'];
    eval(run_string);
    
    %初始化图片存储
    run_string = ['testData.data' num2str(i) '=zeros(200*1024,length(imgDir));'];
    eval(run_string);
    
    for j = 1:length(imgDir)          % 遍历结构体就可以一一处理图片了
        [img,map] = imread([imgPath imgDir(j).name]); %读取每张图片
        img=ind2gray(img,map); %序列转为灰度
        %img=double(img)/255; %归一化
        %imgMed=medfilt2(img,[5 5]);%中值滤波
        imgMed=img;
        %imgMed=mat2gray(imgMed);
        %转为列向量存储
        run_string = ['testData.data' num2str(i) '(:,j)' '=imgMed(:);'];
        eval(run_string);
    end
end

end

