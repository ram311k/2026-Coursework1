N = 16; %%число элементов антенной решетки
J = 1; %% количество источников
d = 0.5;
z = 1i; %% мнимая единица
fi_ar = 6.46; %% ширина луча АР
fi_0 = [0]; %% угловые координаты источников
sigma_0 = 1; %% мощность шума приемника

% задаём массив из векторов направлений от J источников и заполняем его:
S_vectors = zeros(N, 1, J);
for k=1:J
    for i=1:N
        for j=1:1
            S_vectors(i,j,k) = exp(z*2*pi*d*(i-1)*sind(fi_0(k)));
        end
    end
end

%задаём амплитуду источников:
a_sources = [sqrt(10)];
sources_power = zeros(1, J);
for i=1:J
    sources_power(i) = mean(abs(a_sources(i)).^2);
end

%задаём весовой вектор:
%fi = 0; %направление главного луча АР
%W = zeros(N, 1);
%for i=1:N
%    for j=1:1
%        W(i,j) = exp(z*2*pi*d*(i-1)*sind(fi));
%    end
%end

%задаём корреляционную матрицу:
sum = zeros(N, N);
for i=1:J
    S_i = S_vectors(:,i);
    sum = sum + a_sources(i)*a_sources(i)/sigma_0 * (S_i * S_i');
end
M = sigma_0*(eye(N)+sum);

%зависимость средней выходной мощности от угла fi:
fi_range = -20:0.2:20;
P = zeros(size(fi_range)); %мощность
for i=1:length(fi_range)
    fi=fi_range(i);
    
    W = zeros(N, 1);
    for ind=1:N
        for j=1:1
           W(ind,j) = (1/sqrt(N))*exp(z*2*pi*d*(ind-1)*sind(fi));
        end
    end
    
    P(i) = real(W' * M * W);
end
P_norm = P/max(P); %нормировка к максимуму
P_dB = 10* log10(P); %перевод в дБ

plot(fi_range, P_norm)
xlabel('fi')
ylabel('P')
grid