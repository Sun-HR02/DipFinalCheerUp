J = imread('lena2.jpg'); % 读入噪声图像

% 中值滤波
filtered = medfilt2(J);

% 高斯低通
f1=double(filtered);
f2=fftshift(fft2(f1));
f3=log(abs(f2));
subplot(131),imshow(mat2gray(f3)),title("噪声频谱");
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
subplot(132),imshow(g),title("最终去噪");
g1=fftshift(fft2(double(g)));
g2=log(abs(g1));
subplot(133),imshow(mat2gray(g2)),title("最终去噪频谱");
