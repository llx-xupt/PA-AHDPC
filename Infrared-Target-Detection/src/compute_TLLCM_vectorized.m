function TLLCM_final = compute_TLLCM_vectorized(img, detect_params)

    [rows, cols] = size(img);
    img = double(img);

    H = fspecial('gaussian', [3 3], 0.8); 
    I_core = imfilter(img, H, 'replicate');
    
    TLLCM_final = zeros(rows, cols);

    for s_idx = 1:size(detect_params, 1)
        gap = detect_params(s_idx, 1);
        cell_sz = detect_params(s_idx, 2);
       
        K = 9; 
        accum_val = zeros(rows, cols);
        domain = true(cell_sz);
        total_pixels = cell_sz * cell_sz;
        real_K = min(K, total_pixels);
        
        for i = 1:real_K
            rank = total_pixels - i + 1;
            accum_val = accum_val + ordfilt2(img, rank, domain, 'symmetric');
        end
        I_mean_base = accum_val / real_K;

        offset = cell_sz + gap;

        temp = zeros(rows, cols, 8);
        
        shifts_cfg = [
             offset,  offset;
             offset,       0;
             offset, -offset;
                  0, -offset;
            -offset, -offset;
            -offset,       0;
            -offset,  offset;
                  0,  offset 
        ];
        
        for dir = 1:8
            dy = shifts_cfg(dir, 1);
            dx = shifts_cfg(dir, 2);

            temp(:, :, dir) = shift_matrix_replicate(I_mean_base, dy, dx);
        end
        I_mean_out = max(temp, [], 3);
        out = ((I_core.^2) ./ (I_mean_out + eps)) - I_core;
        out(out < 0) = 0;
        TLLCM_final = max(TLLCM_final, out);
    end
end