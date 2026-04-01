function shifted = shift_matrix_replicate(M, dy, dx) 
    [r, c] = size(M);
    shifted = zeros(r, c);
    src_r_start = max(1, 1 - dy);
    src_r_end   = min(r, r - dy);
    src_c_start = max(1, 1 - dx);
    src_c_end   = min(c, c - dx);
    dst_r_start = max(1, 1 + dy);
    dst_r_end   = min(r, r + dy);
    dst_c_start = max(1, 1 + dx);
    dst_c_end   = min(c, c + dx);
    shifted(dst_r_start:dst_r_end, dst_c_start:dst_c_end) = ...
        M(src_r_start:src_r_end, src_c_start:src_c_end);
    if dy > 0 
        shifted(1:dy, :) = repmat(shifted(dy+1, :), dy, 1);
    elseif dy < 0 
        shifted(r+dy+1:r, :) = repmat(shifted(r+dy, :), -dy, 1);
    end

    if dx > 0 
        shifted(:, 1:dx) = repmat(shifted(:, dx+1), 1, dx);
    elseif dx < 0 
        shifted(:, c+dx+1:c) = repmat(shifted(:, c+dx), 1, -dx);
    end
end