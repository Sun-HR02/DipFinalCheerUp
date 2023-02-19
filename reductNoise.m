J = imread('lena1.jpg');

% 平均值滤波
Kaverage = filter2(fspecial('average',3),J)/255;
figure
imshow(Kaverage)

% 中值滤波
Kmedian = medfilt2(J);
imshowpair(Kaverage,Kmedian,'montage')