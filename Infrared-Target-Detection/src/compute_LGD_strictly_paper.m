function I_LGD = compute_LGD_strictly_paper(patch, core_mask, center_r, center_c)
    [h, w] = size(patch);
    [rows_in_k, cols_in_k] = find(core_mask);
    
    if isempty(rows_in_k)
        I_LGD = 0;
        return;
    end
    
    m = 5;
    K = 3; 
    T = 2;  
 
    max_mgde = 0;
    
    for idx = 1:length(rows_in_k)
        p_r = rows_in_k(idx);
        p_c = cols_in_k(idx);
        g_p = patch(p_r, p_c);
        s_vec = zeros(m, 1);
   
        for j = 1:m
            r_min_out = max(1, p_r - j); r_max_out = min(h, p_r + j);
            c_min_out = max(1, p_c - j); c_max_out = min(w, p_c + j);
            
            if j > 1
                r_min_in = max(1, p_r - (j-1)); r_max_in = min(h, p_r + (j-1));
                c_min_in = max(1, p_c - (j-1)); c_max_in = min(w, p_c + (j-1));
            else
                r_min_in = p_r; r_max_in = p_r; c_min_in = p_c; c_max_in = p_c;
            end
            
            patch_sub = patch(r_min_out:r_max_out, c_min_out:c_max_out);
            mask_ring = true(size(patch_sub));
            rel_r1 = r_min_in - r_min_out + 1; rel_r2 = r_max_in - r_min_out + 1;
            rel_c1 = c_min_in - c_min_out + 1; rel_c2 = c_max_in - c_min_out + 1;
            mask_ring(rel_r1:rel_r2, rel_c1:rel_c2) = false;
            ring_pixels = patch_sub(mask_ring);
            
            if isempty(ring_pixels)
                s_j = 0;
            else
                sorted_vals = sort(ring_pixels, 'descend');
                actual_K = min(K, length(sorted_vals));
                g_ring_max_mean = mean(sorted_vals(1:actual_K));
                s_j = g_p - g_ring_max_mean;
            end
            s_vec(j) = s_j;
        end

        valid_layers = sum(s_vec > T);

        if valid_layers >= 3
            positive_diffs = max(0, s_vec); 
            MGDE_p = sum(positive_diffs.^2);
        else
            MGDE_p = 0;
        end
        
        if MGDE_p > max_mgde
            max_mgde = MGDE_p;
        end
    end
    
    I_LGD = max_mgde;
end