%5.ͼ����
function result = sharp(In)
    H = [0 -1 0; -1 4 -1; 0 -1 0]; %Laplacian��ģ��
    result(:, :, :) = imfilter(In(:, :, :), H);
    result = result / 3 + In;
    figure, imshow(result), title('Laplacia��ͼ��');
end
