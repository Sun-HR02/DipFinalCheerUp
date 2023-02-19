clc
clear all;
close all;

% ����ԭͼ��
filename='lena.jpg';
original=imread(filename);

% ����ˮӡͼ��
filename='2.png';
watermarkImg=imread(filename);
watermarkImg=double(watermarkImg);
watermarkImg=round(watermarkImg./256);
watermarkImg=uint8(watermarkImg);

% ȷ��ԭͼ��Ĵ�С
Mo=size(original,1);
No=size(original,2);
% ȷ��ˮӡͼ��Ĵ�С
Mw=size(watermarkImg,1);
Nw=size(watermarkImg,2);
% ��ˮӡ��չΪԭͼ���С
for ii = 1:Mo
    for jj = 1:No
        watermark(ii,jj)=watermarkImg(mod(ii, Mw)+1,mod(jj, Nw)+1); % ƽ����ȫͼ
    end
end

% �滻�����Чλ
result=original; %���ͼ��,������ͼ�������޸�
for ii = 1:Mo
   for jj = 1:No
       result(ii, jj)=bitset(result(ii, jj), 1, watermark(ii ,jj)); % ��һ�е�����,�޸�Ƕ��λ(8λ�еĵ�1λ)
   end 
end
imwrite(result,'lsb_watermarked.bmp','bmp');

subplot(1,2,1);imshow(original);title('ԭʼͼ��');
subplot(1,2,2);imshow(result);title('Ƕ��ˮӡ��ͼ��');






