%--------------函数说明-------------  
% 对一张图片进行RPE边界识别
% 输出根据RPE线确定的待分类的81*81的图片矩阵
% 输出对应的图片中心点坐标
% 每一列为一张图片
%-----------------------------------  
function [xRPEExtract,yRPEExtract,oneRpeImgExtract, exLayers,xRPE,yRPE] = OneTestImgExtract(Lmed)
Lorg=reshape(Lmed,[1024,200]);
Lorg=double(Lorg)/255; %归一化
Lmed=medfilt2(Lorg,[5 5]);%中值滤波
Lmed=mat2gray(Lmed);
[xRPE,yRPE,xRPEz,yRPEz]=OCT_RPE_line(Lmed);
% figure; imshow(Lmed); hold on;
% plot(xRPE,yRPE,'-r*','LineWidth',);
% plot(xRPE,yRPE,'-r','LineWidth',2); %绘制拟合曲线图，需要时开启
%plot(xRPEz,yRPEz,'-g*','LineWidth',2);
%RpeDetect(testData.data1);
extractLimit=(60:140); %提取的x轴像素范围
xRPEExtract=xRPE(extractLimit); %以100为中心，提取左右40个像素点范围内的对象
yRPEExtract=yRPE(xRPEExtract);
numRPE=size(xRPEExtract,1); %RPE层的输出点数
exLayers=160; %将RPE层增加扩充的厚度，总厚度需+1
oneRpeImgExtract=zeros(81*81,numRPE*(exLayers+1));  %预定义输出

%根据提取的点，获取以点为中心的81*81大小的图像，用以对比
for j=1:exLayers+1
    for i=1:numRPE
            image=Lmed(yRPEExtract(i)-exLayers*0.5+j-40:yRPEExtract(i)-exLayers*0.5+j+40,xRPEExtract(i)-40:xRPEExtract(i)+40);        
            oneRpeImgExtract(:,(j-1)*numRPE+i)=reshape(image,[81*81,1]);   %将图片转为列向量
    end
end
end

