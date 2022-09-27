%--------------函数说明-------------  
% 对某一张测试图片进行处理
% 根据训练的PCA和SVM模型找到断点位置
% 并计算欧氏距离偏差
%-----------------------------------  
function [testResult] = OneImgTest(xyRpeExtract,rpeImgExtract,xyAxisReal,exLayers,W,model)
%
%   
imgTest=rpeImgExtract; %获取图片信息
imgTestMean = double(imgTest) - repmat(mean(imgTest),size(imgTest,1),1); %中心化
imgTestPCA = W'*imgTestMean; 
imgTestPCANormaled=normalize(imgTestPCA,'range'); %映射到0-1
numImage=size(imgTestPCA,2); %一张图片抽取的子图数量
testing_label_vector=zeros(1,numImage); %按测试数量随便给定类标
[predicted_label,~,prob_estimates] = libsvmpredict(testing_label_vector', imgTestPCANormaled', model,'-b 1');
index_1=model.Label==1;  %首先找到左断点和右断点标签号所在的位置，以便寻找对应概率矩阵位置
index_3=model.Label==3;

%--在预测分类中找到含有左断点和右断点标签号的对象----------------------%
numRPE=size(xyRpeExtract,1);
indexEstimate_1=find(predicted_label==1);
indexEstimate_1=indexEstimate_1(mod(indexEstimate_1,numRPE)<numRPE*0.5);
indexEstimate_3=find(predicted_label==3);
indexEstimate_3=indexEstimate_3(mod(indexEstimate_3,numRPE)>numRPE*0.5);


%--在找到的对象中找到概率最大的一个----------------------------------------%
[~,indexEstimateProbMax_1]=max(prob_estimates(indexEstimate_1,index_1));  
[~,indexEstimateProbMax_3]=max(prob_estimates(indexEstimate_3,index_3));  
index_best1=indexEstimate_1(indexEstimateProbMax_1); %左断点编号
index_best3=indexEstimate_3(indexEstimateProbMax_3); %右断点编号

if isempty(index_best1)  %处理找不到的情况
    index_best1=1;
end

if isempty(index_best3)  %处理找不到的情况
    index_best3=1;
end

if isempty(index_best3) && isempty(index_best1)  %处理找不到的情况
    index_best1=1;
    index_best3=1;
end

if index_best1==0
    index_best1=1;
end

if index_best3==0
    index_best3=1;
end

%-获取对应的坐标--------------------------------------------------------------%
%fprintf('index_best1:%6.2f\n',index_best1);

%将序列映射回来
new_index_best1=mod(index_best1,numRPE); %取余
if new_index_best1==0
    new_index_best1=numRPE;
end
new_index_best3=mod(index_best3,numRPE);
if new_index_best3==0
    new_index_best3=numRPE;
end

testResult.xyAxisLeft=xyRpeExtract(new_index_best1,:)+[0,-exLayers*0.5+fix(index_best1/numRPE)+1];
testResult.xyAxisRight=xyRpeExtract(new_index_best3,:)+[0,-exLayers*0.5+fix(index_best3/numRPE)+1];

%--计算偏差---------------------------------------------------------------%
testResult.xyReal=xyAxisReal; 
testResult.xyErrorLeft=xyAxisReal(1,:)-testResult.xyAxisLeft;
testResult.xyErrorRight=xyAxisReal(2,:)-testResult.xyAxisRight;

if testResult.xyAxisLeft(1)==xyRpeExtract(1,1)
    testResult.xyErrorLeft(1)=0;
    testResult.xyErrorLeft(2)=0;
end

if testResult.xyAxisLeft(2)==xyRpeExtract(1,2)
    testResult.xyErrorLeft(1)=0;
    testResult.xyErrorLeft(2)=0;
end

if testResult.xyAxisRight(1)==xyRpeExtract(1,1)
    testResult.xyErrorRight(1)=0;
    testResult.xyErrorRight(2)=0;
end

if testResult.xyAxisRight(2)==xyRpeExtract(1,2)
    testResult.xyErrorRight(1)=0;
    testResult.xyErrorRight(2)=0;
end






end

