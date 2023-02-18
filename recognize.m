
% 第一种
I=imread('Img.jpg');
imshow(I)

%用图像处理方法可以较好地辨别随机噪声和周期噪声

[m,n]=size(I);
H=zeros(2*m-1,2*n-1);
U=zeros(2*m-1,2*n-1);
H(1:m,1:n)=I;
U(1:m,1:n)=I;

%用ftrans2函数进行傅里叶变换

F=ftrans2(U);
G=abs(F);

%求相关系数
n=mean(mean(I));
Corr=G-(n*n);
imagesc(Corr);

%根据相关系数来判断图像中有随机噪声和周期噪声

if (Corr~=0)
    disp('Yes,there have random noise and cyclic noise')
else
    disp('No')
end


% ------------------------------------------------------------------ 分割线 ----------------------------------------------
% 第二种
I = imread('noisy_image.png');
imshow(I);

Igray = rgb2gray(I); %将图像转换为灰度图

%计算随机噪声估计，先计算无噪声原图灰度能量
e0 = sum(sum(Igray.^2));

%计算去噪后图像灰度能量
Igray_denoise = wiener2(Igray);
edenoise = sum(sum(Igray_denoise.^2));

%计算随机噪声估计
noise_random_est = sqrt((1/prod(size(Igray)))*(e0-edenoise));

%计算周期性噪声的估计
i_fft = fft2(double(Igray));
i_ps = fftshift(abs(i_fft).^2);
i_noise = i_ps - max(i_ps(:));
noise_periodic_est = sum(sqrt(sum(i_noise.^2)))/length(i_noise(:));

fprintf('The estimated noise type is:');
if noise_random_est > noise_periodic_est
    fprintf('random');
else
    fprintf('periodic');
end