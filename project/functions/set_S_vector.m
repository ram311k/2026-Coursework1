function S_vectors = set_S_vector(N, J, fi_0, d, rx_error, delta0, eps0)
% задаём матрицу из векторов направлений от J источников и заполняем её:
S_vectors = zeros(N, J);

% неидентичность приемников
if rx_error == 1
    delta = zeros(N,1);
    eps = zeros(N,1);
    for ind = 1:N
        delta(ind,1) = 1 + normrnd(0, delta0);
        eps(ind,1) = normrnd(0, eps0);
    end
end

for k=1:J
    for j=1:N
        S_vectors(j,k) = exp(1i*2*pi*d*(j-1)*sind(fi_0(k)));
        if rx_error == 1
            S_vectors(j,k) = S_vectors(j,k) * delta(j,1) * exp(1i*eps(j,1));
        end
    end
end

end