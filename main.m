clc;clear;

%% 数据前处理
[trainData,testData]=DataPreTreat();
imgTrainOrig=[trainData.left trainData.right];
%重建标签 0，1，0，3   左空，左断点，右空，右断点
imgTrainLabelOrig=[trainData.leftLabel trainData.rightLabel+2];
imgTrainLabelOrig(imgTrainLabelOrig==2)=0;
imgTrainLabelOrig=double(imgTrainLabelOrig);%转为double型

%--将原始训练集分为训练集和验证集--------------------------------------------%
randIndex = randperm(size(imgTrainOrig,2));  %生成随机种子
imgTrain=imgTrainOrig(:,randIndex);    %根据随机种子重排列
imgTrainLabel=imgTrainLabelOrig(:,randIndex);       
%抽取验证集
imgValidation=imgTrain(:,end-199:end);
imgValidationLabel=imgTrainLabel(:,end-199:end);
%重新抽取训练集
imgTrain=imgTrain(:,1:end-200);
imgTrainLabel=double(imgTrainLabel(:,1:end-200));
%% 对训练集和验证集合进行PCA
E=80; %选取80%能量的特征值
[imgTrainPCA,W] = MyPCA(imgTrain,E); %PCA得到新的特征图像以及变换矩阵W
ShowEigenImg(W); %显示所有特征图像

%--求取验证集PCA映射-----------------------------------%
imgValidationMean = double(imgValidation) - repmat(mean(imgValidation),size(imgValidation,1),1);
imgValidationPCA = W'*imgValidationMean;

%% SVM训练及验证
%--归一化图像-----------------------------------------------%
imgTrainNewNormaled=normalize(imgTrainPCA,'range'); %映射到0-1
imgValidationNormaled=normalize(imgValidationPCA,'range');

%--寻找最优c和g-------------------------------------------------------%
%[bestCVaccuracy,bestc,bestg]=SVMcgForClass(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
%

[bestCVaccuracy,bestc,bestg]=SVMcgForClass(imgTrainLabel', imgTrainNewNormaled',-2,4,-4,4,3,0.5,0.5,0.9);
%bestc=2;
%bestg=2;
cmd = ['-c ',num2str(bestc), ' -g ',num2str(bestg),' -b 1'];
model = libsvmtrain(imgTrainLabel', imgTrainNewNormaled',cmd); %以最优参数训练
[predict_label, accuracy, dec_values]=libsvmpredict(imgValidationLabel',imgValidationNormaled',model,'-b 1');

%save('shouxie_model','model'); %保存svm模型  

%clearvars -except testData W model; %去除除此以外的变量，节约内存 
%% 测试集预处理
%testDataExtracted=TestDataExtract(testData);%针对每个测试图片，截取可能的81*81图片组

%% 最终测试
[testResult]=FinalTest(testData,W,model); %得到最终的结果
%testPlot(testData, testResult); %绘制断点图像

for i=1:5
    operate = [' meanLeftX(i)=mean(abs(testResult.data' num2str(i) '.testErrorLeft(1,:)));'];
    eval(operate); 
    
    operate = [' meanLeftY(i)=mean(abs(testResult.data' num2str(i) '.testErrorLeft(2,:)));'];
    eval(operate); 
    
    operate = [' meanRightX(i)=mean(abs(testResult.data' num2str(i) '.testErrorRight(1,:)));'];
    eval(operate); 
    
    operate = [' meanRightY(i)=mean(abs(testResult.data' num2str(i) '.testErrorRight(2,:)));'];
    eval(operate); 
    
    operate = [' varLeftX(i)=std(abs(testResult.data' num2str(i) '.testErrorLeft(1,:)));'];
    eval(operate); 
    
    operate = [' varLeftY(i)=std(abs(testResult.data' num2str(i) '.testErrorLeft(2,:)));'];
    eval(operate); 
    
    operate = [' varRightX(i)=std(abs(testResult.data' num2str(i) '.testErrorRight(1,:)));'];
    eval(operate); 
    
    operate = [' varRightY(i)=std(abs(testResult.data' num2str(i) '.testErrorRight(2,:)));'];
    eval(operate); 
    
    
end
figure();  
bar(meanLeftX,'c');  
hold on;  
errorbar(meanLeftX,varLeftX,'k','LineStyle','none');
xlabel('眼睛编号');
ylabel('左断点列值误差均值±标准差（像素）');

figure();  
bar(meanLeftY,'c');  
hold on;  
errorbar(meanLeftY,varLeftY,'k','LineStyle','none');
xlabel('眼睛编号');
ylabel('左断点行值误差均值±标准差（像素）');

figure();  
bar(meanRightX,'c');  
hold on;  
errorbar(meanRightX,varLeftX,'k','LineStyle','none');
xlabel('眼睛编号');
ylabel('右断点列值误差均值±标准差（像素）');

figure();  
bar(meanRightY,'c');  
hold on;  
errorbar(meanRightY,varLeftY,'k','LineStyle','none');
xlabel('眼睛编号');
ylabel('右断点行值误差均值±标准差（像素）');

for i=1:7
    print(figure(i),'-dpng','-r600',strcat('./Result/',num2str(i) ,'.png'));
    close;
end
