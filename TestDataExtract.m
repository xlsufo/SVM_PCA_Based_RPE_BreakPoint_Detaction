%--------------函数说明-------------  
% 对5组眼睛分别进行备选图片的挑选
%        
%    
%-----------------------------------  
function [testDataExtracted] = TestDataExtract(testData)

for index=1:5  
    operate = ['numImg=size(testData.data' num2str(index) ',2);']; %获取图片数量
    eval(operate); %赋值执行语句
    for i=1:numImg
        operate = ['Lmed=testData.data' num2str(index)  '(:,i);'];
        eval(operate);
        [ONExRPEExtract,ONEyRPEExtract,ONErpeImgExtract]=OneTestImgExtract(Lmed);
         operate=['testDataExtracted.data' num2str(index) '.image' num2str(i) '.xyRPEExtract=[ONExRPEExtract,ONEyRPEExtract];'];
         eval(operate);
         operate=['testDataExtracted.data' num2str(index) '.image' num2str(i) '.rpeImgExtract=ONErpeImgExtract;'];
         eval(operate);
    end
end
%保存并关闭所有图像,需要时开启
% while(get(gcf,'number')>1)
%    f=getframe(gcf);
%    imwrite(f.cdata,['./RpeImage/',num2str(get(gcf,'number')),'.png']);
%    close;
% end

end

