clc
clear all;
close all;

%水印图像提取
filename='lsb_watermarked.bmp';
watermarked_image=imread(filename);
Mw =size(watermarked_image,1);
Nw =size(watermarked_image,2);

%读入原水印
filename='2.png';
original_watermark=imread(filename);

% 提取出水印
for ii = 1:Mw
   for jj = 1:Nw
       watermark_extracted(ii, jj)=bitget(watermarked_image(ii, jj),1); %取出第一位平面的图像
   end
end
watermark_extracted=256*double(watermark_extracted);

%%原水印的行数与列数
Mo=size(original_watermark,1);	        %水印的行数
No=size(original_watermark,2);	        %水印的列数
%保证大小一致
for ii = 1:Mo-1
    for jj = 1:No-1
        watermark(ii+1,jj+1)=watermark_extracted(ii,jj);
    end
end
watermark(1,1)=watermark_extracted(Mo,No);

subplot(1,2,1);imshow(original_watermark);title('原水印');
subplot(1,2,2);imshow(watermark);title('提取出水印');
