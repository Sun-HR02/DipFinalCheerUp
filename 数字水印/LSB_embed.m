clc
clear all;
close all;

% 读入原图像
filename='lena.jpg';
original=imread(filename);

% 读入水印图像
filename='2.png';
watermarkImg=imread(filename);
watermarkImg=double(watermarkImg);
watermarkImg=round(watermarkImg./256);
watermarkImg=uint8(watermarkImg);

% 确定原图像的大小
Mo=size(original,1);
No=size(original,2);
% 确定水印图像的大小
Mw=size(watermarkImg,1);
Nw=size(watermarkImg,2);
% 将水印扩展为原图像大小
for ii = 1:Mo
    for jj = 1:No
        watermark(ii,jj)=watermarkImg(mod(ii, Mw)+1,mod(jj, Nw)+1); % 平铺满全图
    end
end

% 替换最低有效位
result=original; %结果图像,在这张图像上做修改
for ii = 1:Mo
   for jj = 1:No
       result(ii, jj)=bitset(result(ii, jj), 1, watermark(ii ,jj)); % 这一行的数字,修改嵌入位(8位中的第1位)
   end 
end
imwrite(result,'lsb_watermarked.bmp','bmp');

subplot(1,2,1);imshow(original);title('原始图像');
subplot(1,2,2);imshow(result);title('嵌入水印后图像');






