clc;clear;

filename = 'dog';
originalFilename= strcat(filename,'.bmp');
noiseFilename= strcat(filename,'Noise','.bmp') ;

O = imread(originalFilename); % 读入噪声图像
J = imread(noiseFilename); % 读入噪声图像
subplot(151),imshow(O),title("原图像");
subplot(152),imshow(J),title("噪声图像");

j1=fftshift(fft2(J));
j2=log(abs(j1));
subplot(153),imshow(mat2gray(j2)),title("噪声图像频谱");

% 中值滤波
filtered = medfilt2(J);

% 高斯低通
G = gussain(filtered);
G=ifftshift(G);
g=uint8(real(ifft2(G)));
subplot(154),imshow(g),title("去噪后图像");
g1=fftshift(fft2(double(g)));
g2=log(abs(g1));
subplot(155),imshow(mat2gray(g2)),title("去噪后频谱");
