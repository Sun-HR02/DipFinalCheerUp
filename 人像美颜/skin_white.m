%4.Ƥ�����״���
function result = skin_white(image_sharp)
    result = rgb2ycbcr(image_sharp); %��ͼƬ��RGBֵת����YCbCrֵ %
    YY = result(:, :, 1);
    Cb = result(:, :, 2);
    Cr = result(:, :, 3);
    [x y z] = size(image_sharp);
    tst = zeros(x, y);
    skin_white = mean(mean(Cb));
    Mr = mean(mean(Cr));
    %����Cb��Cr�ľ�����%
    Tb = Cb - skin_white;
    Tr = Cr - Mr;
    Db = sum(sum((Tb) .* (Tb))) / (x * y);
    Dr = sum(sum((Tr) .* (Tr))) / (x * y);
    %���ݷ�ֵ��Ҫ����ȡ��near-white��������ص�%
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
    iy = sort(Ciny, 'descend'); %����ȡ�������ص������ֵ��ĵ㵽С�ĵ��������� %
    nn = round(cnt / 10);
    Ciny2(1:nn) = iy(1:nn); %��ȡ��near-white������10 %������ֵ�ϴ�����ص����ο��׵� %
    %��ȡ���ο��׵��RGB���ŵ���ֵ%
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
    %����ο��׵��RGB�ľ�ֵ%
    Rav = mean(mean(R));
    Gav = mean(mean(G));
    Bav = mean(mean(B));
    Ymax = double(max(max(YY))) * 0.15; %�����ͼƬ�����ȵ����ֵ %
    %�����RGB���ŵ�������%
    Rgain = Ymax / Rav;
    Ggain = Ymax / Gav;
    Bgain = Ymax / Bav;
    %ͨ���������ͼƬ��RGB���ŵ�%
    image_sharp(:, :, 1) = image_sharp(:, :, 1) * Rgain;
    image_sharp(:, :, 2) = image_sharp(:, :, 2) * Ggain;
    image_sharp(:, :, 3) = image_sharp(:, :, 3) * Bgain;
    figure, imshow(result), title('Ƥ������ͼ');
end
