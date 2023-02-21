%2.皮肤区域分割
%2.1基于RGB空间的非肤色像素初步过滤
function result = filter(In)
    result = In;
    [heimage_ght, width, c] = size(In);
    image_r = In(:, :, 1); image_g = In(:, :, 2); iamge_b = In(:, :, 3);

    for j = 1:heimage_ght

        for i = 1:width

            if (image_r(j, i) < 160/255 && image_g(j, i) < 160/255 && iamge_b(j, i) < 160) && (image_r(j, i) > image_g(j, i) && image_g(j, i) > iamge_b(j, i))
                result(j, i, :) = 0;
            end

            if image_r(j, i) + image_g(j, i) > 500/255
                result(j, i, :) = 0;
            end

            if image_r(j, i) < 70/255 && image_g(j, i) < 40/255 && iamge_b(j, i) < 20/255
                result(j, i, :) = 0;
            end

        end

    end

    figure, imshow(result); title('初步过滤图');
end
