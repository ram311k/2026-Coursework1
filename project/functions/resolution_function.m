function P = resolution_function(fi_range, M_r, W, method)
P = zeros(size(fi_range)); %мощность
M_r_inv = inv(M_r);

for i=1:length(fi_range)
    
    if method == 1
        P(i) = abs(1/(W(:, i)' * M_r_inv * W(:, i)));
    elseif method == 2
        P(i) = abs(W(:, i)' * M_r * W(:, i));
    end
end
end