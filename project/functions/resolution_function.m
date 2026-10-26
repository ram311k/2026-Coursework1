function P = resolution_function(fi_range, N, d, M_r, method)
P = zeros(size(fi_range)); %мощность
M_r_inv = inv(M_r);

for i=1:length(fi_range)
    fi=fi_range(i);
    
    W = zeros(N, 1);
    for ind=1:N
        W(ind,1) = (1/sqrt(N))*exp(1i*2*pi*d*(ind-1)*sind(fi));
    end
    
    if method == 1
        P(i) = abs(1/(W' * M_r_inv * W));
    elseif method == 2
        P(i) = abs(W' * M_r * W);
    end
end
end