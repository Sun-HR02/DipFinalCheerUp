%3.图像平滑
function result = filt(In)
    [height, width, c] = size(In);
    width_window = 15; % 定义双边滤波窗口宽度
    sigma_s = 6; sigma_r = 0.1; % 双边滤波的两个标准差参数
    [X, Y] = meshgrid(-width_window:width_window, -width_window:width_window);
    Gs = exp(- (X .^ 2 + Y .^ 2) / (2 * sigma_s ^ 2)); %计算邻域内的空间权值
    result = zeros(height, width, c);

    for k = 1:c

        for j = 1:height

            for i = 1:width
                temp = In(max(j - width_window, 1):min(j + width_window, height), max(i - width_window, 1):min(i + width_window, width), k);
                Gr = exp(- (temp - In(j, i, k)) .^ 2 / (2 * sigma_r ^ 2)); %计算灰度邻近权值
                % W为空间权值Gs和灰度权值Gr的乘积
                W = Gr .* Gs((max(j - width_window, 1):min(j + width_window, height)) - j + width_window + 1, (max(i - width_window, 1):min(i + width_window, width)) - i + width_window + 1);
                result(j, i, k) = sum(W(:) .* temp(:)) / sum(W(:));
            end

        end

    end

    figure, imshow(result), title('滤波图');
end
