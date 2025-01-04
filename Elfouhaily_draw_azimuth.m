clear all;
close all;

% 设置波数范围
lkmin = log(1e-3);
lkmax = log(1e+4);
dk = (lkmax - lkmin) / 100000;
wave_number = exp(lkmin:dk:lkmax);

% 设置风速
wind_speed = 15;  % 风速设定为15 m/s

% 设置风向（单位：度）
azimuths = [0, 30, 60, 90];  % 风向：0°、30°、60°、90°

% 线型定义
line_styles = {'-', '--', ':', '-.'};  % 不同线型

% 创建图形
figure;
hold on;

% 循环绘制不同风向下的 Elfouhaily 谱
for ii = 1:length(azimuths)
    azimuth = azimuths(ii);
    [SeaE, ~] = Elfouhaily(wind_speed, wave_number, azimuth);  % 计算 Elfouhaily 谱

    % 使用不同的线型绘制不同风向下的谱
    loglog(wave_number, SeaE, 'LineWidth', 2, 'LineStyle', line_styles{ii}, 'DisplayName', sprintf('Azimuth = %d°', azimuth));
end

% 设置图例
legend('show', 'Location', 'southwest');

% 设置轴和标题
set(gca, 'XScale', 'log', 'YScale', 'log');  % 设置坐标轴为对数刻度
axis([1e-3 1e4 1e-18 1e5]);
grid on;
xlabel('波数 k / m^{-1}');
ylabel('Elfouhaily谱 S(k) / m^3');
title('不同风向下的 Elfouhaily 海浪谱（风速 15 m/s）');

hold off;
