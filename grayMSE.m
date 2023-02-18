function msevalue = grayMSE(image1,image2)
% image1和image2大小相等
row=size(image1,1); % 图像的长
col=size(image1,2); % 图像的宽
image1=double(image1);
image2=double(image2);
msevalue=sum(sum((image1-image2).^2))/(row*col);
end
