function LHI = compute_LHI(img)

    h_smooth = fspecial('average', [5 5]);
    img_smooth = imfilter(img, h_smooth, 'replicate');

    h_local = ones(3,3);
    h_local(2,2) = 0;
    h_local = h_local / 8;
    
    mean_neighbors = imfilter(img_smooth, h_local, 'replicate');

    LHI = img_smooth - mean_neighbors;
    LHI(LHI < 0) = 0;
end