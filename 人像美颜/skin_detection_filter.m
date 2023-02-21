%2.2基于YCgCr空间范围肤色分割
function result = skin_detection_filter(In)
    IR = In(:, :, 1); IG = In(:, :, 2); IB = In(:, :, 3);
    [height, width, c] = size(In);
    result = zeros(height, width);

    for i = 1:width

        for j = 1:height
            R = IR(j, i); G = IG(j, i); B = IB(j, i);
            Cg = (-81.085) * R + (112) * G + (-30.915) * B + 128;
            Cr = (112) * R + (-93.786) * G + (-18.214) * B + 128;

            if Cg >= 85 && Cg <= 135 && Cr >= -Cg + 260 && Cr <= -Cg + 280
                result(j, i) = 1;
            end

        end

    end

    result = medfilt2(result, [3 3]);
end
