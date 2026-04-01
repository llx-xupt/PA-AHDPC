function result = mobius_addition(x, y, c)
    if nargin < 3, c = 1; end
    norm_x2 = norm(x)^2;
    norm_y2 = norm(y)^2;
    dot_xy = x' * y;
    num = (1 + 2*dot_xy/c + norm_y2/c)*x + (1 - norm_x2/c)*y;
    den = 1 + 2*dot_xy/c + (norm_x2*norm_y2)/(c^2);
    result = num / (den + eps);
end