function X_vector = set_X_vector(N, J, L, sigma_range_linear, sigma_num, S_vectors)

Z = zeros(N, L); %массив векторов компл. гсш из L выборок

%задаём случ. компл. гауссову амплитуду сигнала
sigma = sqrt(sigma_range_linear(sigma_num)); %корень из дисперсии(среднеквадратичное отклонение)
a_sources = zeros(J, L); %массив компл. амплитуд J источников L выборок

X_vector = zeros(N, L); %L выборок вектора входного процесса

for l=1:L
    for idx=1:N
        Z(idx, l) = randn()/sqrt(2) + 1i * randn()/sqrt(2);
    end
    for k=1:J
        a_sources(k, l) = sigma * randn()/sqrt(2) + sigma * 1i * randn()/sqrt(2);
    end
    for p=1:J
        X_vector(:, l) = X_vector(:, l) + a_sources(p, l)* S_vectors(:, p);
    end
    X_vector(:, l) = X_vector(:, l) + Z(:, l);

end

end