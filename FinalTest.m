%--------------函数说明-------------  
% 利用训练的PCA和SVM模型进行所有测试图片的断点标识，
% 并计算欧氏距离的偏差
%-----------------------------------  
function [testResult] = FinalTest(testData,W,model)
%
%
for index=1:5  
operate = ['numImg=size(testData.data' num2str(index) ',2);']; %获取图片数量
eval(operate); %赋值执行语句
    for i=1:numImg
        operate = ['Lmed=testData.data' num2str(index)  '(:,i);'];
        eval(operate); %获取需要检测的图片

        %获取图片对应帧号
        operate = ['testImgFrameNum=testData.data' num2str(index)  'Label(' num2str(i) ');'];
        eval(operate);  

        %获取测试图片真实点坐标
        operate = ['testImgMarkers=testData.markers' num2str(index)  '.markers;'];
        eval(operate); 
        xyAxisReal=testImgMarkers(find(testImgMarkers(:,2)==testImgFrameNum),:);
        xyAxisReal=xyAxisReal(:,[1,3]);  %存储真实坐标

        %从图片抽取测试片
        [ONExRPEExtract,ONEyRPEExtract,ONErpeImgExtract,exLayers,xRPE,yRPE]=OneTestImgExtract(Lmed);

        %整理输出
        xyRpeExtract=[ONExRPEExtract,ONEyRPEExtract];

        %测试
        [oneImgTestResult] = OneImgTest(xyRpeExtract,ONErpeImgExtract,xyAxisReal,exLayers,W,model);
        
        operate = ['testResult.data' num2str(index)  '.image' num2str(i) '.testResult=oneImgTestResult;'];
        eval(operate);  %结果 
        
        xyErrorLeft=oneImgTestResult.xyErrorLeft';
        xyErrorRight=oneImgTestResult.xyErrorRight';
        operate = ['testResult.data' num2str(index) '.testErrorLeft(:,' num2str(i) ')=xyErrorLeft;'];
        eval(operate);  %结果 

        operate = ['testResult.data' num2str(index) '.testErrorRight(:,' num2str(i) ')=xyErrorRight;'];
        eval(operate);  %结果
        
        %{
        Lorg=reshape(Lmed,[1024,200]);
        Lorg=double(Lorg)/255; %归一化
        Lmed=medfilt2(Lorg,[5 5]);%中值滤波
        Lmed=mat2gray(Lmed);
        figure; imshow(Lmed); hold on;
        plot(xRPE,yRPE,'-r','LineWidth',2); %绘制拟合曲线图，需要时开启
        scatter(oneImgTestResult.xyAxisLeft(1),oneImgTestResult.xyAxisLeft(2),'filled','r');
        scatter(oneImgTestResult.xyAxisRight(1),oneImgTestResult.xyAxisRight(2),'filled','r');
        scatter(oneImgTestResult.xyReal(1,1),oneImgTestResult.xyReal(1,2),'filled','b');
        scatter(oneImgTestResult.xyReal(2,1),oneImgTestResult.xyReal(2,2),'filled','b');
        %}
    end
end

%保存并关闭所有图像,需要时开启
% while(get(gcf,'number')>1)
%    f=getframe(gcf);
%    imwrite(f.cdata,['./RpeImage/',num2str(get(gcf,'number')),'.png']);
%    close;
% end

%{
for index=1:5  
    operate = ['numImg=size(testData.data' num2str(index) ',2);']; %获取图片数量
    eval(operate); %赋值执行语句
    
    for i=1:numImg
        operate = ['testRpeImgExtract=testDataExtracted.data' num2str(index)  '.image' num2str(i) ';'];
        eval(operate);  %被测图片的抽取信息
        
        operate = ['testImgMarkers=testData.markers' num2str(index)  '.markers;'];
        eval(operate);  %获取图片金标准
        
        operate = ['testImgFrameNum=testData.data' num2str(index)  'Label(' num2str(i) ')'];
        eval(operate);  %获取图片对应帧号
        
        [oneImgTestResult]=OneImgTest(testRpeImgExtract,testImgMarkers,testImgFrameNum,W,model); %结果
        
        operate = ['testResult.data' num2str(index)  '.image' num2str(i) '.testResult=oneImgTestResult;'];
        eval(operate);  %结果 
        
        xyErrorLeft=oneImgTestResult.xyErrorLeft';
        xyErrorRight=oneImgTestResult.xyErrorRight';
        operate = ['testResult.data' num2str(index) '.testErrorLeft(:,' num2str(i) ')=xyErrorLeft;'];
        eval(operate);  %结果 

        operate = ['testResult.data' num2str(index) '.testErrorRight(:,' num2str(i) ')=xyErrorRight;'];
        eval(operate);  %结果 
    end
end
%}
end

