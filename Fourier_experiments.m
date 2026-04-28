N = 16; %%число элементов антенной решетки
J = 2; %% количество источников
d = 0.5;
z = 1i; %% мнимая единица
fi_ar = 6.46; %% ширина луча АР
fi_0 = [-2.8 2.8]; %% угловые координаты источников
sigma_0 = 1; %% мощность шума приемника
L = 5; %число выборок
num_experiments = 100; %число экспериментов

fi_range = -40:0.1:40;
P_all = zeros(num_experiments, length(fi_range));
for exp_num = 1:num_experiments
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
P_dB = 10* log10(P_norm); %перевод в дБ
P_all(exp_num, :) = P_dB;
end

%находим пики на графике
results = struct('exp_num', {}, 'peaks', {}, 'locs', {});
for exp_num = 1:num_experiments
    [pks, locs] = findpeaks(P_all(exp_num, :), fi_range, 'MinPeakHeight', -10);
    
    results(exp_num).exp_num = exp_num;
    results(exp_num).peaks = pks;
    results(exp_num).locs = locs;
end

%находим число экспериментов с праивльно оцененным числом целей
%и составляем массивы всех левых и правых пиков
m=0;
left_peaks = zeros(1, length(results));
right_peaks = zeros(1, length(results));

for exp_num=1:length(results)
    if length(results(exp_num).peaks)==J
        m = m + 1;
        left_peaks(exp_num) = min(results(exp_num).locs);
        right_peaks(exp_num) = max(results(exp_num).locs);
    else
        left_peaks(exp_num) = NaN;
        right_peaks(exp_num)= NaN;
    end
end
fprintf('Число экспериментов с правильно оцененным числом целей: %d\n', m);

%расчет средней оценки азимутов целей и СКО
if m>0
    fi_avr_1 = 0;
    fi_avr_2 = 0;
    for exp_num=1:length(results)
        if length(results(exp_num).peaks)==2
            fi_avr_1 = fi_avr_1 + min(results(exp_num).locs);
            fi_avr_2 = fi_avr_2 + max(results(exp_num).locs);
        end
    end
    fi_avr_1 = fi_avr_1 / m;
    fi_avr_2 = fi_avr_2 / m;
    if m>1
    sigm_1_pow2 = 0;
    sigm_2_pow2 = 0;
    for exp_num=1:length(results)
        if length(results(exp_num).peaks)==2
            sigm_1_pow2 = sigm_1_pow2 + (min(results(exp_num).locs)-fi_avr_1)^2;
            sigm_2_pow2 = sigm_2_pow2 + (max(results(exp_num).locs)-fi_avr_2)^2;
        end
    end
    sigm_1_pow2 = sigm_1_pow2/(m-1);
    sigm_2_pow2 = sigm_2_pow2/(m-1);
    SKO = sqrt(0.5*(sigm_1_pow2+sigm_2_pow2));
    end
    fprintf('fi_avr_1 = %f\n', fi_avr_1);
    fprintf('fi_avr_2 = %f\n', fi_avr_2);
    fprintf('SKO = %f\n', SKO);
    %расчет систематической и суммарной ошибки:
    SO = sqrt(0.5*((fi_avr_1 - fi_0(1))^2 + (fi_avr_2 - fi_0(2))^2));
    SKO_sum = sqrt(SKO^2+SO^2);
    fprintf('SO = %f\n', SO);
    fprintf('SKO_sum = %f\n', SKO_sum);
end


%построение графика разрешающей функции
hold on;
%colors = {'b', 'r', 'g'};
for exp_num = 1:size(P_all, 1)
    plot(fi_range, P_all(exp_num,:))
end
xlabel('fi')
ylabel('P')
grid
%xline(-5.6);
%xline(5.6);

%plot(fi_range, P_all(exp_num,:), colors{exp_num})

