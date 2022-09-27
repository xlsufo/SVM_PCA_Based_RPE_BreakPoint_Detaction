%--------------函数说明-------------  
%-----主成分分析算法
%-----输入：样本集合矩阵：img
%           降维的维数 ：k
%-----输出：img_new,img_mean,W
%-----------------------------------  
function [img_new,W] = MyPCA(img,E)
%用法：  [img_new,img_mean,W] = PCA(train_face,E);
%reshape函数：改变句矩阵的大小，矩阵的总元素个数不能变
img = double(img);
[m,n] = size(img);  %取大小

%中心化
img_mean = mean(img); %求每列平均值
img_mean_all = repmat(img_mean,m,1);%复制m行平均值至整个矩阵
imgZ = img - img_mean_all;

%%求取协方差矩阵，利用奇异值分解简化计算
covMat = imgZ'*imgZ;
[COEFF, latent, explained] = pcacov(covMat);  %COEFF特征矩阵  latent特征值 explained特征值占比

% 选择构成E=95%能量的特征值，获取其序列
i = 1;
proportion = 0;
while(proportion < E)
    proportion = proportion + explained(i);
    i = i+1;
end
selectIndex = i - 1;

%利用奇异值分解原理求取最终的特征图像
U_Sum = imgZ*COEFF;    % N*M阶
col_of_latent=size(latent,1);  %获取
for i=1:col_of_latent
    U(:,i)=U_Sum(:,i)/sqrt(latent(i,:));
end
W = U(:,1:selectIndex);           % N*p阶
img_new=W'*imgZ;       %低维度下的各个图像的数据

% T=Z*Z';  %协方差矩阵（非原始所求矩阵的协方差)
% [V,D] = eigs(T,k);%计算T中最大的前k个特征值与特征向量
% V=Z'*V;         %协方差矩阵的特征向量
% for i=1:k       %特征向量单位化
%     l=norm(V(:,i));
%     V(:,i)=V(:,i)/l;  
% end
% img_new = Z*V;  %低维度下的各个脸的数据

end
