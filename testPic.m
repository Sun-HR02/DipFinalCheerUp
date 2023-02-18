clc
clear

% 生成两个带噪声的图片
I1 = imnoise(imread('lena.jpg'),'gaussian'); % 生成随机噪声
I2 = imnoise(imread('lena.jpg'),'salt & pepper',0.1); % 生成周期噪声

imwrite(I1,'lena1.jpg','jpg');
