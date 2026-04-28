N = 16; %%число элементов антенной решетки
J = 2; %% количество источников
d = 0.5;
z = 1i; %% мнимая единица
fi_ar = 6.46; %% ширина луча АР
fi_0 = [-2.8 2.8]; %% угловые координаты источников
sigma_0 = 1; %% мощность шума приемника
L = 5; %число выборок
% задаём массив из векторов направлений от J источников и заполняем его:
S_vectors = zeros(N, 1, J);
for k=1:J
    for i=1:N
        for j=1:1
            S_vectors(i,j,k) = exp(z*2*pi*d*(i-1)*sind(fi_0(k)));
        end
    end
end

Z = zeros(N, 1, L); %массив векторов компл. гсш из L выборок

%задаём случ. компл. гауссову амплитуду сигнала
sigma = sqrt(10); %корень из дисперсии
a_sources = zeros(J, L); %массив компл. амплитуд J источников L выборок

X = zeros(N, 1, L); %L выборок вектора входного процесса

for l=1:L
    for i=1:N
        Z(i, 1, l) = randn()/sqrt(2) + z * randn()/sqrt(2);
    end
    for k=1:J
        a_sources(k, l) = sigma * randn()/sqrt(2) + sigma * z * randn()/sqrt(2);
    end
    for p=1:J
        X(:, 1, l) = X(:, 1, l) + a_sources(p, l)* S_vectors(:, 1, p);
    end
    X(:, 1, l) = X(:, 1, l) + Z(:, 1, l);

end

M = zeros(N, N);
for i=1:L
    M = M+ X(:, 1, i)*(X(:, 1, i))';
end
M=M/L;

M_r = 0.2*eye(N) + M;

%зависимость средней выходной мощности от угла fi:
fi_range = -40:0.2:40;
P = zeros(size(fi_range)); %мощность
for i=1:length(fi_range)
    fi=fi_range(i);
    
    W = zeros(N, 1);
    for ind=1:N
        for j=1:1
           W(ind,j) = (1/sqrt(N))*exp(z*2*pi*d*(ind-1)*sind(fi));
        end
    end
    
    P(i) = real(W' * M_r * W);
end
P_norm = P/max(P); %нормировка к максимуму
P_dB = 10* log10(P); %перевод в дБ

plot(fi_range, P_norm)
xlabel('fi')
ylabel('P')
grid
xline(-2.8);
xline(2.8);


%for l=1:L
%    for i=1:J
%        a_sources(i, l) = sigma * randn()/sqrt(2) + sigma * z * randn()/sqrt(2);
%    end
%end

