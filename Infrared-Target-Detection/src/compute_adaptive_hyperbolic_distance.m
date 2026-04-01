function dist_mat = compute_adaptive_hyperbolic_distance(U, V)
    [n, d] = size(U);
    dist_mat = zeros(n, n);
    
    mu = mean(V, 1); 
    A = V - mu;      
    Sigma_g = (A' * A) / (n - 1); 
    tr_Sigma = trace(Sigma_g);    
    
    tr_max = d; 
    v_norms = vecnorm(V, 2, 2);
    v_max = max(v_norms);
    
    pdist_V = pdist2(V, V);
    d_max = max(pdist_V(:));
    
    dist_to_mu = vecnorm(V - mu, 2, 2);
    v_A_max = max(dist_to_mu);
    
    for i = 1:n
        for j = i:n
            if i == j, dist_mat(i, j) = 0; continue; end
            
            term1 = tr_Sigma / (tr_max + eps);
            term2 = (v_norms(i) + v_norms(j)) / (2 * v_max + eps);
            term3 = pdist_V(i, j) / (d_max + eps);
            term4 = (dist_to_mu(i) + dist_to_mu(j)) / (2 * v_A_max + eps);
            
            alpha = 0.25 * (term1 + term2 + term3 + term4);
            
            u_i = U(i, :); u_j = U(j, :);
            diff_sq = sum((u_i - u_j).^2);
            u_norm_sq_i = sum(u_i.^2); u_norm_sq_j = sum(u_j.^2);
            
            delta = 2 * alpha * diff_sq / ((1 - u_norm_sq_i + eps) * (1 - u_norm_sq_j + eps));
            d_val = acosh(1 + delta);
            
            dist_mat(i, j) = d_val; dist_mat(j, i) = d_val;
        end
    end
end