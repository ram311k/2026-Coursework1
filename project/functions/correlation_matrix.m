function M_r = correlation_matrix(N, L, X)
M = zeros(N, N);
for i=1:L
    M = M+ X(:, i)*(X(:, i))';
end
M=M/L;

M_r = 0.2*eye(N) + M;

end