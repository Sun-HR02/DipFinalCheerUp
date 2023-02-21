%1.主程序
clear,clc,close all;
image = im2double(imread('image3.png'));
figure, imshow(image), title('原图');
image_filt = filt(image); %滤波

image_filter = filter(image); %初步过滤

image_skin_filter = skin_detection_filter(image_filter); % %YCgCr空间范围肤色检测

image_mix = mix(image, image_filt, image_skin_filter); %图像融合
image_sharp = sharp(image_mix); %图像锐化

image_skinwhitening = skin_white(image_sharp);
