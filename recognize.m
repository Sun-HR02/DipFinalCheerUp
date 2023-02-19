I = imread('lena1.jpg');
imshow(I);

Igray = im2gray(I); %将图像转换为灰度图

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