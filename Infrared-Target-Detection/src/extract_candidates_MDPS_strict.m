function [candidates, gamma_map] = extract_candidates_MDPS_strict(rho, max_candidates)
    [rows, cols] = size(rho);
    delta = zeros(rows, cols);
    idx_map = reshape(1:(rows*cols), rows, cols); 

    D_curr = rho;            
    S_curr = zeros(size(rho)); 
    idx_curr = idx_map;

    [c_grid, r_grid] = meshgrid(1:cols, 1:rows);

    while size(D_curr, 1) > 1 || size(D_curr, 2) > 1
        [curr_h, curr_w] = size(D_curr);

        [~, sorted_indices] = sort(D_curr(:), 'descend');

        for k = 1:length(sorted_indices)
            center_linear_idx = sorted_indices(k);

            if D_curr(center_linear_idx) == 0
                continue;
            end

            S_curr(center_linear_idx) = 1;

            [cy, cx] = ind2sub([curr_h, curr_w], center_linear_idx);

            orig_idx_q = idx_curr(cy, cx);
            q_r = r_grid(orig_idx_q);
            q_c = c_grid(orig_idx_q);

            r_start = max(1, cy - 1); r_end = min(curr_h, cy + 1);
            c_start = max(1, cx - 1); c_end = min(curr_w, cx + 1);
            
            for ny = r_start:r_end
                for nx = c_start:c_end

                    if ny == cy && nx == cx, continue; end
                    
                    neighbor_linear_idx = sub2ind([curr_h, curr_w], ny, nx);
                    if S_curr(neighbor_linear_idx) == 0
                        S_curr(neighbor_linear_idx) = 1;
                        D_curr(neighbor_linear_idx) = 0; 
                        orig_idx_p = idx_curr(ny, nx);
                        p_r = r_grid(orig_idx_p);
                        p_c = c_grid(orig_idx_p);
                        dist = sqrt((q_r - p_r)^2 + (q_c - p_c)^2);
                        delta(orig_idx_p) = dist;
                    end
                end
            end
        end
        next_h = floor(curr_h / 2);
        next_w = floor(curr_w / 2);
        
        if next_h == 0 || next_w == 0
            break; 
        end
        
        D_next = zeros(next_h, next_w);
        idx_next = zeros(next_h, next_w); 
        
        for i = 1:next_h
            for j = 1:next_w
                r0 = 2*i - 1; r1 = 2*i;
                c0 = 2*j - 1; c1 = 2*j;
                block_vals = D_curr(r0:r1, c0:c1);
                block_idxs = idx_curr(r0:r1, c0:c1);

                [max_v, max_loc] = max(block_vals(:));
                
                D_next(i, j) = max_v;

                idx_next(i, j) = block_idxs(max_loc);
            end
        end
        S_next = zeros(size(D_next));
        S_next(D_next == 0) = 1; 

        D_curr = D_next;
        S_curr = S_next;
        idx_curr = idx_next;
    end

    [~, max_rho_idx] = max(rho(:));
    max_dist = sqrt(rows^2 + cols^2);
    delta(max_rho_idx) = max_dist;

    gamma_map = rho .* delta;

    candidates = struct('row', {}, 'col', {}, 'rho', {}, 'delta', {}, 'gamma', {}, 'intensity', {});
    
    [gamma_sorted, sort_idx] = sort(gamma_map(:), 'descend');

    count = 0;
    min_dist_check = 10; 
    
    for k = 1:length(gamma_sorted)
        idx = sort_idx(k);
        [r, c] = ind2sub([rows, cols], idx);
        
        is_valid = true;
        for j = 1:count
            d = sqrt((r - candidates(j).row)^2 + (c - candidates(j).col)^2);
            if d < min_dist_check
                is_valid = false;
                break;
            end
        end
        
        if is_valid
            count = count + 1;
            candidates(count).row = r;
            candidates(count).col = c;
            candidates(count).rho = rho(idx);
            candidates(count).delta = delta(idx);
            candidates(count).gamma = gamma_sorted(k);
            candidates(count).intensity = gamma_sorted(k); 
        end
        
        if count >= max_candidates
            break;
        end
    end
end