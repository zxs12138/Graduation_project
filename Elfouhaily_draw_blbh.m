clear all;
close all;

% 设置波数范围
lkmin = log(1e-3);
lkmax = log(1e+4);
dk = (lkmax - lkmin) / 100000;
wave_number = exp(lkmin:dk:lkmax);

% 设置风速
wind_speed = 15;  % 风速设定为15 m/s

% 使用 Elfouhaily 函数计算 B_l, B_h 和 Sea
[SeaE, B_l, B_h] = Elfouhaily(wind_speed, wave_number, 0);

% 绘制图像
figure;
hold on;

% 绘制 B_L 曲线（使用虚线）
loglog(wave_number, B_l, 'LineWidth', 2, 'LineStyle', '--', 'DisplayName', 'B_L');

% 绘制 B_h 曲线（使用点划线）
loglog(wave_number, B_h, 'LineWidth', 2, 'LineStyle', ':', 'DisplayName', 'B_H');

% 绘制 Sea 曲线（使用实线）
loglog(wave_number, (B_l+B_h), 'LineWidth', 2, 'LineStyle', '-', 'DisplayName', 'Sea');

% 设置图例
legend('show', 'Location', 'southwest');

% 设置轴和标题
set(gca, 'XScale', 'log', 'YScale', 'log');  % 设置坐标轴为对数刻度
axis([1e-3 1e4 1e-18 1e5]);
grid on;
xlabel('波数 k / m^{-1}');
ylabel('海浪谱值');
title('风速 15 m/s 下的B_L+B_H , B_L 和 B_H');

hold off;
