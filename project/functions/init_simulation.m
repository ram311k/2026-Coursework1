function params = init_simulation()

params.N = 12; %число элементов антенной решетки
params.J = 2; % количество источников
params.d = 0.5; % расстояние между элементами антенны, выраженное в длинах волн
params.fi_ar = 2*asind(0.451/params.d/params.N); % ширина луча АР
params.fi_0 = [-2.155 2.155]; % угловые координаты источников
params.fi_range = -20:0.1:20; %диапазон сканирования
params.W = exp(1i * 2*pi*params.d * ((0:(params.N-1)).' * sind(params.fi_range))) / sqrt(params.N);
params.delta_fi_norm = abs(params.fi_0(1)-params.fi_0(2))/params.fi_ar; %угловое расстояние между источниками к ширине луча
params.sigma_0 = 1; % мощность шума приемника
params.L = 20; %число выборок
params.num_experiments = 3000; %число экспериментов

params.method = 1; % 1 - Кейпон, 2 - Фурье

params.rx_error = 1; % 1 - вносим неидентичность приемников, 0 - не вносим
params.delta0 = 0; % стандартное отклонение амплитудной ошибки приемника
if params.rx_error == 0
    params.eps0 = 0; % стандартное отклонение фазовой ошибки приемника
elseif params.rx_error == 1
    params.eps0 = [0, pi/15, pi/10];
end

params.sigma_range = 0:1:20; %мощность источников в дБ
params.sigma_range_linear = 10.^(params.sigma_range/10); %мощность источников в разах
params.n_sigma_range = length(params.sigma_range); 

params.n_eps = length(params.eps0);
params.m=zeros(params.n_eps, params.n_sigma_range);%число экспериментов с правильно оцененным числом целей
params.p_resolution=zeros(params.n_eps, params.n_sigma_range);%вероятность разрешения
params.SKO=zeros(params.n_eps, params.n_sigma_range);
params.SO=zeros(params.n_eps, params.n_sigma_range);
params.SKO_sum=zeros(params.n_eps, params.n_sigma_range);
end