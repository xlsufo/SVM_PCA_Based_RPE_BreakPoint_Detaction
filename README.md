# Logistic&Softmax Regression

## 环境要求
- macOS or Linux or Windows
- matlab（本项目使用的为MATLAB R2021a）
## 依赖包
无
## 数据来源
本项目的数据来源为：Project2
## 使用说明
### 文件分布
主要文件分布如下图所示：
```
rootPath:.
│  DataPreTreat.m
│  FinalTest.m
│  libsvmpredict.mexw64
│  libsvmread.mexw64
│  libsvmtrain.mexw64
│  libsvmwrite.mexw64
│  main.m
│  MyPCA.m
│  OCT_RPE_line.m
│  OneImgTest.m
│  OneTestImgExtract.m
│  ShowEigenImg.m
│  SVMcgForClass.m
│  
├─Picture
├─RpeImage
├─TestImg
├─TrainImg

```
- DataPreTreat是数据前处理函数
- FinalTest是最终测试函数
- libsvmpredict、libsvmread、libsvmtrain、libsvmwrite是使用的libsvm库函数
- main是主函数入口
- MyPCA是编写的PCA函数
- OCT_RPE_line是对测试图片的RPE层识别函数
- OneImgTest是对某一张图片的测试函数
- OneTestImgExtract是对某一张图片进行区域预划分和测试样本抽取
- ShowEigenImg是显示特征图像的函数
- SVMcgForClass是SVM参数优化函数
- Picture是存储最终结果文件的文件夹
- RpeImage是存储识别了RPE层的图片文件夹
- TestImg是测试图片存储文件夹
- TrainImg是训练图片存储文件夹

### 运行说明
- 直接运行main文件即可