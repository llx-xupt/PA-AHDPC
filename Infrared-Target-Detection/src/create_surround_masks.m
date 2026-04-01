function masks = create_surround_masks(window_size, s, core_size)
    masks = cell(1, 1);
    half_size = floor(window_size / 2);
    [X, Y] = meshgrid(-half_size:half_size, -half_size:half_size);

    core_mask = (abs(X) <= floor(core_size/2)) & (abs(Y) <= floor(core_size/2));

    surr_mask = (abs(X) <= floor(s/2)) & (abs(Y) <= floor(s/2)) & ~core_mask;
    masks{1} = surr_mask;
end