tic;
addpath('functions');

% параметры симуляции
params = init_simulation;

P_all = zeros(params.num_experiments, length(params.fi_range));

for eps_num = 1:params.n_eps
eps0_cur = params.eps0(eps_num);

% задаём массив из векторов направлений от J источников и заполняем его
S_vectors = set_S_vector(params.N, params.J, params.fi_0, params.d, params.rx_error, params.delta0, eps0_cur);

    for sigma_num = 1:params.n_sigma_range
        for exp_num = 1:params.num_experiments
        % задаём L выборок вектора X входного процесса
        X = set_X_vector(params.N, params.J, params.L, params.sigma_range_linear, sigma_num, S_vectors);

        % регуляризованная КМ
        M_r = correlation_matrix(params.N, params.L, X);

        P = resolution_function(params.fi_range, M_r, params.W, params.method);

        P_norm = P/max(P); %нормировка к максимуму
        P_dB = 10* log10(P_norm); %перевод в дБ
        P_all(exp_num, :) = P_dB;

        end
    [params.m, params.p_resolution, params.SKO,...
        params.SO, params.SKO_sum] ...
        = error_calculation(params.num_experiments, eps_num, P_all,...
        params.fi_range, params.J, sigma_num, params.fi_0, params.m,...
        params.p_resolution,params.SKO, params.SO,...
        params.SKO_sum);
    end
end

SKO_norm = params.SKO/params.fi_ar;
SO_norm = params.SO/params.fi_ar;
SKO_sum_norm = params.SKO_sum/params.fi_ar;
sigma_range_dB = 10* log10(params.sigma_range_linear);

figure;
hold on;
for eps_num = 1:params.n_eps
plot(sigma_range_dB, params.p_resolution(eps_num,:), 'LineWidth', 1);
end
ylim([0, inf]);
%xlim([10, 30]);
xlabel('SNR')
ylabel('p resolution')
grid on
if params.rx_error == 1
    labels = cell(1, params.n_eps);
    for eps_num = 1:params.n_eps
        labels{eps_num} = sprintf('eps0 = %g', params.eps0(eps_num));
    end
    legend(labels, 'Location', 'best');
end
%xticks(10:2:30);
hold off;

figure;
hold on;
for eps_num = 1:params.n_eps
plot(sigma_range_dB, SKO_norm(eps_num,:), 'LineWidth', 1);
end
ylim([0, inf]);
%xlim([10, 30]);
xlabel('SNR')
ylabel('SKO norm')
grid on
if params.rx_error == 1
    labels = cell(1, params.n_eps);
    for eps_num = 1:params.n_eps
        labels{eps_num} = sprintf('eps0 = %g', params.eps0(eps_num));
    end
    legend(labels, 'Location', 'best');
end
%xticks(10:2:30);
hold off;

figure;
hold on;
for eps_num = 1:params.n_eps
plot(sigma_range_dB, SO_norm(eps_num,:), 'LineWidth', 1);
end
ylim([0, inf]);
%xlim([10, 30]);
xlabel('SNR')
ylabel('SO norm')
grid on
if params.rx_error == 1
    labels = cell(1, params.n_eps);
    for eps_num = 1:params.n_eps
        labels{eps_num} = sprintf('eps0 = %g', params.eps0(eps_num));
    end
    legend(labels, 'Location', 'best');
end
%xticks(10:2:30);
hold off;

figure;
hold on;
for eps_num = 1:params.n_eps
plot(sigma_range_dB, SKO_sum_norm(eps_num,:), 'LineWidth', 1);
end
ylim([0, inf]);
%xlim([10, 30]);
xlabel('SNR')
ylabel('SKO sum norm')
grid on
if params.rx_error == 1
    labels = cell(1, params.n_eps);
    for eps_num = 1:params.n_eps
        labels{eps_num} = sprintf('eps0 = %g', params.eps0(eps_num));
    end
    legend(labels, 'Location', 'best');
end
%xticks(10:2:30);
hold off;

toc;