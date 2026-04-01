addpath('src'); 
addpath('test_images');

img = imread("test_images/test3.png"); 

if size(img, 3) == 3
    img = rgb2gray(img);
end

[~, ~, ~, confirmed_targets] = infrared_target_detection(img, 2.0);

binary_result = false(size(img));

if ~isempty(confirmed_targets)
    for i = 1:length(confirmed_targets)
        r = confirmed_targets(i).row;
        c = confirmed_targets(i).col;

        r_start = max(1, r - 1); r_end = min(size(img, 1), r + 1);
        c_start = max(1, c - 1); c_end = min(size(img, 2), c + 1);
        binary_result(r_start:r_end, c_start:c_end) = true;
    end
end

figure;
imshow(binary_result);