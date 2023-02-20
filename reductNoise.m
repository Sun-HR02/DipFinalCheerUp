clc;clear;

filename = 'dog';
originalFilename= strcat(filename,'.bmp');
noiseFilename= strcat(filename,'Noise','.bmp') ;

O = imread(originalFilename); % 读入噪声图像
J = imread(noiseFilename); % 读入噪声图像
subplot(151),imshow(O),title("原图像");
subplot(152),imshow(J),title("噪声图像");

f2=fftshift(fft2(J));
f3=log(abs(f2));
subplot(153),imshow(mat2gray(f3)),title("噪声图像频谱");

% 中值滤波
filtered = medfilt2(J);

% 高斯低通
f1=double(filtered);
d0=90;
[m,n]=size(f1);
n1=floor(m/2);
n2=floor(n/2);
f4=fftshift(fft2(double(f1)));
for u=1:m
    for v=1:n
        D=sqrt((u-n1)^2+(v-n2)^2);
        H=1*exp(-1/2*(D^2/d0^2));
        G(u,v)=H*f4(u,v);
    end
end
G=ifftshift(G);
g=uint8(real(ifft2(G)));
subplot(154),imshow(g),title("去噪后图像");
g1=fftshift(fft2(double(g)));
g2=log(abs(g1));
subplot(155),imshow(mat2gray(g2)),title("去噪后频谱");
