%6.ͼ���ں�
function result = mix(image, image_filt, image_skin_filter)
    Skin = zeros(size(image));
    Skin(:, :, 1) = image_skin_filter;
    Skin(:, :, 2) = image_skin_filter;
    Skin(:, :, 3) = image_skin_filter;
    result = image_filt .* Skin + double(image) .* (1 - Skin);

    figure, imshow(result); title('ͼ���ں�Ч��ͼ');
end
