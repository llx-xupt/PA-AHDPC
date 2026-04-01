function [final_scores, results_vis] = process_candidates_ahdpc(candidates, img, TLLCM_final, local_win_radius)
    epsilon = 0.1; 
    
    num_candidates = length(candidates);
    final_scores = zeros(num_candidates, 1);
    results_vis = cell(num_candidates, 1);
    
    for i = 1:num_candidates
        r_c = candidates(i).row;
        c_c = candidates(i).col;
        
        r_start = max(1, r_c - local_win_radius);
        r_end = min(size(img, 1), r_c + local_win_radius);
        c_start = max(1, c_c - local_win_radius);
        c_end = min(size(img, 2), c_c + local_win_radius);
        
        patch = double(img(r_start:r_end, c_start:c_end));
        [p_h, p_w] = size(patch);
        num_pixels_local = p_h * p_w;
        feat_int = patch(:);
        min_I = min(feat_int); max_I = max(feat_int);
        if max_I - min_I < eps, max_I = min_I + 1; end
        norm_int = (feat_int - min_I) / (max_I - min_I); 
        
        [grid_xx, grid_yy] = meshgrid(1:p_w, 1:p_h);

        rel_r = r_c - r_start + 1;
        rel_c = c_c - c_start + 1;
        feat_dist = sqrt((grid_xx - rel_c).^2 + (grid_yy - rel_r).^2);
        norm_dist = feat_dist(:) / (max(feat_dist(:)) + eps); 
        
        X_euclid = [norm_int, norm_dist]; 
        
        X_norm =  X_euclid ./ (max(vecnorm(X_euclid, 2, 2)) * epsilon + eps);
        X_norms = vecnorm(X_norm, 2, 2);
        X_hyp = zeros(size(X_norm));
        for k = 1:num_pixels_local
            if X_norms(k) < eps
                X_hyp(k,:) = zeros(1, size(X_norm, 2));
            else
                X_hyp(k,:) = tanh(X_norms(k)) * (X_norm(k,:) / X_norms(k));
            end
        end
        
        X_tangent = map_to_tangent_space(X_hyp);
        dist_mat = compute_adaptive_hyperbolic_distance(X_hyp, X_tangent);
        
        patch_prior = TLLCM_final(r_start:r_end, c_start:c_end); 
        feat_prior = patch_prior(:);

        [labels, ~] = run_ahdpc_clustering(dist_mat, num_pixels_local, feat_prior);

        
        center_linear_idx = sub2ind([p_h, p_w], rel_r, rel_c);
        target_label = labels(center_linear_idx);
        
        core_mask = reshape(labels == target_label, p_h, p_w);

        lgd_score = compute_LGD_strictly_paper(patch, core_mask, rel_r, rel_c);
        
        final_scores(i) = lgd_score;
        res.patch = patch;
        res.mask = core_mask; 
        results_vis{i} = res;
    end
end