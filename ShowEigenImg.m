function ShowEigenImg(img)
%SHOWEIGENFACE 此处显示有关此函数的摘要
%   此处显示详细说明
numImg=size(img,2);
figure
for i=1:numImg
subplot(6,ceil(numImg/6),i),imshow(mat2gray(reshape(img(:,i),81,81)));
end

end