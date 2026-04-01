function [detection_map, candidates, final_scores, confirmed_targets] = infrared_target_detection(img, lambda_input)

    max_candidates = 20;       
    local_win_radius = 8;      
    lambda_thr = 2.0;          
    
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    img = double(img);
    
    rho_LHI = compute_LHI(img);

    detect_params = [0, 3]; 
    TLLCM_map = compute_TLLCM_vectorized(img, detect_params);
    
    tllcm_norm = (TLLCM_map - min(TLLCM_map(:))) / (max(TLLCM_map(:)) - min(TLLCM_map(:)) + eps);
    
    rho_combined = rho_LHI .* (1 + 2 * tllcm_norm); 
   
    border_width = 10; 
    [h, w] = size(rho_combined);

    rho_combined(1:border_width, :) = 0;
    rho_combined(end-border_width+1:end, :) = 0;

    rho_combined(:, 1:border_width) = 0;
    rho_combined(:, end-border_width+1:end) = 0;

    [candidates, ~] = extract_candidates_MDPS_strict(rho_combined, max_candidates);
    
    num_candidates = length(candidates);
    if num_candidates == 0
        detection_map = rho_combined;
        final_scores = [];
        confirmed_targets = [];
        return;
    end
    
    
    [final_scores, ~] = process_candidates_ahdpc(candidates, img, tllcm_norm, local_win_radius);

    if ~isempty(candidates)

        gamma_vals = [candidates.gamma]';

        if max(gamma_vals) - min(gamma_vals) > eps
            gamma_norm = (gamma_vals - min(gamma_vals)) / (max(gamma_vals) - min(gamma_vals));
        else
            gamma_norm = ones(size(gamma_vals));
        end
        
        max_lgd = max(final_scores);
        if max_lgd > eps
            lgd_norm = final_scores / max_lgd;
        else
            lgd_norm = final_scores; % 全是0的情况
        end

        w_gamma = 0.6; 
        w_lgd = 0.4;
        
        fused_scores = w_gamma * gamma_norm + w_lgd * lgd_norm;

        final_scores = fused_scores;
    end
    
    valid_scores = final_scores(final_scores > 0);
    
    if isempty(valid_scores)
        T = 0;
        confirmed_idx = [];
    else

        mu = mean(valid_scores);
        sigma = std(valid_scores);
        T_stat = mu + 1.0 * sigma; 

        max_score = max(valid_scores);
        T_ratio = max_score * 0.4; 

        T = min(T_stat, T_ratio);
        
        confirmed_idx = find(final_scores > T);
    end

    if isempty(confirmed_idx) && ~isempty(valid_scores)
         [~, max_idx] = max(final_scores);
         confirmed_idx = max_idx;
    end

    detection_map = rho_combined; 

    if isempty(confirmed_idx)
        confirmed_targets = [];
    else

        confirmed_targets = candidates(confirmed_idx);

        for k = 1:length(confirmed_idx)
            orig_idx = confirmed_idx(k);
            confirmed_targets(k).final_score = final_scores(orig_idx);
        end
    end
    
end