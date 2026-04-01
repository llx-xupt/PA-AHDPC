function [labels, centers] = run_ahdpc_clustering(dist_mat, num_pixels, feat_tllcm)

    n_pairs = num_pixels * (num_pixels - 1) / 2;
    min_neigh = 0.01; max_neigh = 0.05;
    
    d_min = min(dist_mat(dist_mat > 0));
    d_max_val = max(dist_mat(:));
    if isempty(d_min), d_min = 0; end
    if isempty(d_max_val), d_max_val = 1; end
    
    lower = d_min; upper = d_max_val;
    d_c = (lower + upper) / 2;
    
    for iter = 1:50
        n_neighs = sum(sum(triu(dist_mat < d_c, 1))) / n_pairs;
        if n_neighs < min_neigh, lower = d_c;
        elseif n_neighs > max_neigh, upper = d_c;
        else, break; end
        d_c = (lower + upper) / 2;
    end
    if d_c == 0, d_c = eps; end

    Rho_geo = sum(exp(-(dist_mat ./ d_c).^2), 2); 

    if nargin > 2 && ~isempty(feat_tllcm)
        norm_tllcm = (feat_tllcm - min(feat_tllcm)) / (max(feat_tllcm) - min(feat_tllcm) + eps);

        Rho = Rho_geo .* (1 + norm_tllcm); 
    else
        Rho = Rho_geo;
    end
    
    [~, ord_idx] = sort(Rho, 'descend');
    Delta = zeros(num_pixels, 1);
    Delta(ord_idx(1)) = max(dist_mat(:)); 
    
    for k = 2:num_pixels
        idx_curr = ord_idx(k);
        idx_higher = ord_idx(1:k-1);
        min_dist = min(dist_mat(idx_curr, idx_higher));
        Delta(idx_curr) = min_dist;
    end

    Gamma = Rho .* Delta;
    [~, centers_sorted] = sort(Gamma, 'descend');
    
    center_1 = centers_sorted(1); 

    remaining_indices = 1:num_pixels;
    remaining_indices(center_1) = [];

    dists_to_c1 = dist_mat(remaining_indices, center_1);

    [~, far_idx] = max(dists_to_c1);
    center_2 = remaining_indices(far_idx);
    
    centers = [center_1, center_2];

    labels = zeros(num_pixels, 1);
    labels(center_1) = 1; labels(center_2) = 2;

    for k = 1:num_pixels
        if k == center_1 || k == center_2, continue; end
        
        d1 = dist_mat(k, center_1);
        d2 = dist_mat(k, center_2);
        
        if d1 < d2
            labels(k) = 1;
        else
            labels(k) = 2;
        end
    end

end