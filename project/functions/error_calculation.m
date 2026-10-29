function  [m, p_resolution, SKO, SO, SKO_sum] = error_calculation(num_experiments, eps_num, P_all, fi_range, J,...
    sigma_num, fi_0, m, p_resolution, SKO, SO, SKO_sum)

%находим пики на графике
results = struct('exp_num', {}, 'peaks', {}, 'locs', {});
for exp_num = 1:num_experiments
    [pks, locs] = findpeaks(P_all(exp_num, :), fi_range, 'MinPeakHeight', -10);
    
    
    results(exp_num).exp_num = exp_num;
    results(exp_num).peaks = pks;
    results(exp_num).locs = locs;
end

%находим число экспериментов с праивильно оцененным числом целей
%и составляем массивы всех левых и правых пиков

%left_peaks = zeros(1, length(results));
%right_peaks = zeros(1, length(results));

for exp_num=1:length(results)
    if length(results(exp_num).peaks)==J
        m(eps_num, sigma_num) = m(eps_num, sigma_num) + 1;
    end
end
%fprintf('Число экспериментов с правильно оцененным числом целей: %d\n', m);

%расчет средней оценки азимутов целей и СКО
if m(eps_num, sigma_num)>0
    fi_avr_1 = 0;
    fi_avr_2 = 0;
    for exp_num=1:length(results)
        if length(results(exp_num).peaks)==J
            fi_avr_1 = fi_avr_1 + min(results(exp_num).locs);
            fi_avr_2 = fi_avr_2 + max(results(exp_num).locs);
        end
    end
    fi_avr_1 = fi_avr_1 / m(eps_num, sigma_num);
    fi_avr_2 = fi_avr_2 / m(eps_num, sigma_num);
    if m(eps_num, sigma_num)>1
        sigm_1_pow2 = 0;
        sigm_2_pow2 = 0;
        for exp_num=1:length(results)
            if length(results(exp_num).peaks)==J
                sigm_1_pow2 = sigm_1_pow2 + (min(results(exp_num).locs)-fi_avr_1)^2;
                sigm_2_pow2 = sigm_2_pow2 + (max(results(exp_num).locs)-fi_avr_2)^2;
            end
        end
        sigm_1_pow2 = sigm_1_pow2/(m(eps_num, sigma_num)-1);
        sigm_2_pow2 = sigm_2_pow2/(m(eps_num, sigma_num)-1);
        SKO(eps_num, sigma_num) = sqrt(0.5*(sigm_1_pow2+sigm_2_pow2));
    elseif m(eps_num, sigma_num) == 1
        SKO(eps_num, sigma_num) = NaN;
    end
    %fprintf('fi_avr_1 = %f\n', fi_avr_1);
    %fprintf('fi_avr_2 = %f\n', fi_avr_2);
   % fprintf('SKO = %f\n', SKO);
    %расчет систематической и суммарной ошибки:
    SO(eps_num, sigma_num) = sqrt(0.5*((fi_avr_1 - fi_0(1))^2 + (fi_avr_2 - fi_0(2))^2));
    SKO_sum(eps_num, sigma_num) = sqrt((SKO(eps_num, sigma_num))^2+(SO(eps_num, sigma_num))^2);
    p_resolution(eps_num, sigma_num)=m(eps_num, sigma_num)/num_experiments;
   % fprintf('SO = %f\n', SO);
   % fprintf('SKO_sum = %f\n', SKO_sum);
end

end