clc
clear all;
close all;

%ˮӡͼ����ȡ
filename='lsb_watermarked.bmp';
watermarked_image=imread(filename);
Mw =size(watermarked_image,1);
Nw =size(watermarked_image,2);

%����ԭˮӡ
filename='2.png';
original_watermark=imread(filename);

% ��ȡ��ˮӡ
for ii = 1:Mw
   for jj = 1:Nw
       watermark_extracted(ii, jj)=bitget(watermarked_image(ii, jj),1); %ȡ����һλƽ���ͼ��
   end
end
watermark_extracted=256*double(watermark_extracted);

%%ԭˮӡ������������
Mo=size(original_watermark,1);	        %ˮӡ������
No=size(original_watermark,2);	        %ˮӡ������
%��֤��Сһ��
for ii = 1:Mo-1
    for jj = 1:No-1
        watermark(ii+1,jj+1)=watermark_extracted(ii,jj);
    end
end
watermark(1,1)=watermark_extracted(Mo,No);

subplot(1,2,1);imshow(original_watermark);title('ԭˮӡ');
subplot(1,2,2);imshow(watermark);title('��ȡ��ˮӡ');
