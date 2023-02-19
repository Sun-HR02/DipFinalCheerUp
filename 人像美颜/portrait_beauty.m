%1.主程序
clear,clc,close all;
image=im2double(imread('image1.jpg'));
figure,imshow(image),title('原图');
image_filt=filt(image);                 %滤波

image_filter=filter(image);            %初步过滤

image_skin_filter=skin_detection_filter(image_filter);           %%YCgCr空间范围肤色检测

image_mix=mix(image,image_filt,image_skin_filter);%图像融合
image_sharp=sharp(image_mix);               %图像锐化

image_skinwhitening=skin_white(image_sharp);

%2.皮肤区域分割
%2.1基于RGB空间的非肤色像素初步过滤
function result=filter(In)
    result=In;
    [heimage_ght,width,c] = size(In); 
    image_r=In(:,:,1); image_g=In(:,:,2);iamge_b=In(:,:,3);
    for j=1:heimage_ght
        for i=1:width
            if (image_r(j,i)<160/255 && image_g(j,i)<160/255 && iamge_b(j,i)<160) && (image_r(j,i)>image_g(j,i) && image_g(j,i)>iamge_b(j,i))
                result(j,i,:)=0;
            end
            if image_r(j,i)+image_g(j,i)>500/255
                result(j,i,:)=0;
            end
            if image_r(j,i)<70/255 && image_g(j,i)<40/255 && iamge_b(j,i)<20/255
                result(j,i,:)=0;
            end
        end
    end
 
    figure,imshow(result);title('初步过滤图'); 
end

%2.2基于YCgCr空间范围肤色分割
function result=skin_detection_filter(In)
    IR=In(:,:,1); IG=In(:,:,2);IB=In(:,:,3);       
    [height,width,c] = size(In);
    result=zeros(height,width);
    for i=1:width
        for j=1:height  
           R=IR(j,i); G=IG(j,i); B=IB(j,i);       
           Cg=(-81.085)*R+(112)*G+(-30.915)*B+128;  
           Cr=(112)*R+(-93.786)*G+(-18.214)*B+128;         
           if Cg>=85 && Cg<=135 && Cr>=-Cg+260 && Cr<=-Cg+280       
               result(j,i)=1;          
           end
        end
    end
    result=medfilt2(result,[3 3]);
    
end

%3.图像平滑
function result=filt(In)
    [height,width,c] = size(In); 
    width_window=15;       % 定义双边滤波窗口宽度  
    sigma_s=6; sigma_r=0.1; % 双边滤波的两个标准差参数  
    [X,Y] = meshgrid(-width_window:width_window,-width_window:width_window); 
    Gs = exp(-(X.^2+Y.^2)/(2*sigma_s^2));%计算邻域内的空间权值    
    result=zeros(height,width,c); 
    for k=1:c
        for j=1:height    
            for i=1:width  
                temp=In(max(j-width_window,1):min(j+width_window,height),max(i-width_window,1):min(i+width_window,width),k);
                Gr = exp(-(temp-In(j,i,k)).^2/(2*sigma_r^2));%计算灰度邻近权值        
                % W为空间权值Gs和灰度权值Gr的乘积       
                W = Gr.*Gs((max(j-width_window,1):min(j+width_window,height))-j+width_window+1,(max(i-width_window,1):min(i+width_window,width))-i+width_window+1);      
                result(j,i,k)=sum(W(:).*temp(:))/sum(W(:));            
            end
        end  
    end
    figure,imshow(result),title('滤波图');

end

%4.皮肤亮白处理
function result=skin_white(image_sharp)
result=rgb2ycbcr(image_sharp);%将图片的RGB值转换成YCbCr值%
YY=result(:,:,1);
Cb=result(:,:,2);
Cr=result(:,:,3);
[x y z]=size(image_sharp);
tst=zeros(x,y);
skin_white=mean(mean(Cb));
Mr=mean(mean(Cr));
%计算Cb、Cr的均方差%
Tb = Cb-skin_white;
Tr = Cr-Mr;
Db=sum(sum((Tb).*(Tb)))/(x*y);
Dr=sum(sum((Tr).*(Tr)))/(x*y);
%根据阀值的要求提取出near-white区域的像素点%
cnt=1;    
for i=1:x
    for j=1:y
        b1=Cb(i,j)-(skin_white+Db*sign(skin_white));
        b2=Cr(i,j)-(1.5*Mr+Dr*sign(Mr));
        if (b1<abs(1.5*Db) && b2<abs(1.5*Dr))
           Ciny(cnt)=YY(i,j);
           tst(i,j)=YY(i,j);
           cnt=cnt+1;
        end
    end
end
cnt=cnt-1;
iy=sort(Ciny,'descend');%将提取出的像素点从亮度值大的点到小的点依次排列%
nn=round(cnt/10);
Ciny2(1:nn)=iy(1:nn);%提取出near-white区域中10%的亮度值较大的像素点做参考白点%
%提取出参考白点的RGB三信道的值% 
mn=min(Ciny2);
for i=1:x
    for j=1:y
        if tst(i,j)<mn
           tst(i,j)=0;
        else
           tst(i,j)=1;
        end
    end
end
R=image_sharp(:,:,1);
G=image_sharp(:,:,2);
B=image_sharp(:,:,3);

R=double(R).*tst;
G=double(G).*tst;
B=double(B).*tst;

%计算参考白点的RGB的均值%
Rav=mean(mean(R));
Gav=mean(mean(G));
Bav=mean(mean(B));

Ymax=double(max(max(YY)))*0.15;%计算出图片的亮度的最大值%
 
%计算出RGB三信道的增益% 
Rgain=Ymax/Rav;
Ggain=Ymax/Gav;
Bgain=Ymax/Bav;

%通过增益调整图片的RGB三信道%
image_sharp(:,:,1)=image_sharp(:,:,1)*Rgain;
image_sharp(:,:,2)=image_sharp(:,:,2)*Ggain;
image_sharp(:,:,3)=image_sharp(:,:,3)*Bgain;

    figure,imshow(result),title('皮肤美化图');
end

%5.图像锐化
function result=sharp(In)
    H=[0 -1 0;-1 4 -1;0 -1 0]; %Laplacian锐化模板
    result(:,:,:)=imfilter(In(:,:,:),H); 
    result=result/3+In;
    figure,imshow(result),title('Laplacia锐化图像');
end

%6.图像融合
function result=mix(image,image_filt,image_skin_filter)
    Skin=zeros(size(image));
    Skin(:,:,1)=image_skin_filter;   
    Skin(:,:,2)=image_skin_filter;  
    Skin(:,:,3)=image_skin_filter;
    result=image_filt.*Skin+double(image).*(1-Skin);
    
    figure,imshow(result);title('图像融合效果图');
end
