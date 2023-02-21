%3.ͼ��ƽ��
function result = filt(In)
    [height, width, c] = size(In);
    width_window = 15; % ����˫���˲����ڿ��
    sigma_s = 6; sigma_r = 0.1; % ˫���˲���������׼�����
    [X, Y] = meshgrid(-width_window:width_window, -width_window:width_window);
    Gs = exp(- (X .^ 2 + Y .^ 2) / (2 * sigma_s ^ 2)); %���������ڵĿռ�Ȩֵ
    result = zeros(height, width, c);

    for k = 1:c

        for j = 1:height

            for i = 1:width
                temp = In(max(j - width_window, 1):min(j + width_window, height), max(i - width_window, 1):min(i + width_window, width), k);
                Gr = exp(- (temp - In(j, i, k)) .^ 2 / (2 * sigma_r ^ 2)); %����Ҷ��ڽ�Ȩֵ
                % WΪ�ռ�ȨֵGs�ͻҶ�ȨֵGr�ĳ˻�
                W = Gr .* Gs((max(j - width_window, 1):min(j + width_window, height)) - j + width_window + 1, (max(i - width_window, 1):min(i + width_window, width)) - i + width_window + 1);
                result(j, i, k) = sum(W(:) .* temp(:)) / sum(W(:));
            end

        end

    end

    figure, imshow(result), title('�˲�ͼ');
end
