clear all;
close all;

% 设置波数范围
lkmin = log(1e-3);
lkmax = log(1e+4);
dk = (lkmax - lkmin) / 100000;
wave_number = exp(lkmin:dk:lkmax);

% 初始化变量
Sea = zeros(10, 100001);
wind_speed = 3:2:21;  % 不同风速
line_styles = {'-', '--', ':', '-.', '-', '--', ':', '-.', '-', '--'}; % 不同线型

% 计算 Elfouhaily 谱
for ii = 1:length(wind_speed)
    [Sea(ii, :),B_l(ii, :),B_h(ii, :)] = Elfouhaily(wind_speed(ii), wave_number, 0);  % 计算每个风速的谱
end

% 绘图
figure;
hold on;
for ii = 1:length(wind_speed)
    % 确保为每个风速选择不同的线型并绘制
    loglog(wave_number, Sea(ii, :), 'LineWidth', 2, 'LineStyle', line_styles{ii}, 'DisplayName', sprintf('U_{10} = %d m/s', wind_speed(ii)));
end

% 设置图例
legend('show', 'Location', 'southwest');

% 设置轴和标题
set(gca, 'XScale', 'log', 'YScale', 'log'); 
axis([1e-3 1e4 1e-18 1e5]);
grid on;
xlabel('波数 k / m^{-1}');
ylabel('Elfouhaily谱 S(k) / m^3');
title('不同风速下的 Elfouhaily 海浪谱');
hold off;
