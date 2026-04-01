function V = map_to_tangent_space(U)
    num_points = size(U, 1);
    dim = size(U, 2);
    V = zeros(num_points, dim);
    u_norms = vecnorm(U, 2, 2);
    for i = 1:num_points
        if u_norms(i) < eps
            V(i, :) = zeros(1, dim);
        else
            V(i, :) = atanh(min(u_norms(i), 1-eps)) * (U(i, :) / u_norms(i));
        end
    end
end