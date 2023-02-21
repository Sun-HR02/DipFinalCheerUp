%5.图像锐化
function result = sharp(In)
    H = [0 -1 0; -1 4 -1; 0 -1 0]; %Laplacian锐化模板
    result(:, :, :) = imfilter(In(:, :, :), H);
    result = result / 3 + In;
    figure, imshow(result), title('Laplacia锐化图像');
end
