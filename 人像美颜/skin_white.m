%4.皮肤亮白处理
function result = skin_white(image_sharp)
    result = rgb2ycbcr(image_sharp); %将图片的RGB值转换成YCbCr值 %
    YY = result(:, :, 1);
    Cb = result(:, :, 2);
    Cr = result(:, :, 3);
    [x y z] = size(image_sharp);
    tst = zeros(x, y);
    skin_white = mean(mean(Cb));
    Mr = mean(mean(Cr));
    %计算Cb、Cr的均方差%
    Tb = Cb - skin_white;
    Tr = Cr - Mr;
    Db = sum(sum((Tb) .* (Tb))) / (x * y);
    Dr = sum(sum((Tr) .* (Tr))) / (x * y);
    %根据阀值的要求提取出near-white区域的像素点%
    cnt = 1;

    for i = 1:x

        for j = 1:y
            b1 = Cb(i, j) - (skin_white + Db * sign(skin_white));
            b2 = Cr(i, j) - (1.5 * Mr + Dr * sign(Mr));

            if (b1 < abs(1.5 * Db) && b2 < abs(1.5 * Dr))
                Ciny(cnt) = YY(i, j);
                tst(i, j) = YY(i, j);
                cnt = cnt + 1;
            end

        end

    end

    cnt = cnt - 1;
    iy = sort(Ciny, 'descend'); %将提取出的像素点从亮度值大的点到小的点依次排列 %
    nn = round(cnt / 10);
    Ciny2(1:nn) = iy(1:nn); %提取出near-white区域中10 %的亮度值较大的像素点做参考白点 %
    %提取出参考白点的RGB三信道的值%
    mn = min(Ciny2);

    for i = 1:x

        for j = 1:y

            if tst(i, j) < mn
                tst(i, j) = 0;
            else
                tst(i, j) = 1;
            end

        end

    end

    R = image_sharp(:, :, 1);
    G = image_sharp(:, :, 2);
    B = image_sharp(:, :, 3);
    R = double(R) .* tst;
    G = double(G) .* tst;
    B = double(B) .* tst;
    %计算参考白点的RGB的均值%
    Rav = mean(mean(R));
    Gav = mean(mean(G));
    Bav = mean(mean(B));
    Ymax = double(max(max(YY))) * 0.15; %计算出图片的亮度的最大值 %
    %计算出RGB三信道的增益%
    Rgain = Ymax / Rav;
    Ggain = Ymax / Gav;
    Bgain = Ymax / Bav;
    %通过增益调整图片的RGB三信道%
    image_sharp(:, :, 1) = image_sharp(:, :, 1) * Rgain;
    image_sharp(:, :, 2) = image_sharp(:, :, 2) * Ggain;
    image_sharp(:, :, 3) = image_sharp(:, :, 3) * Bgain;
    figure, imshow(result), title('皮肤美化图');
end
