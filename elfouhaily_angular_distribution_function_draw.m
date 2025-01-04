clc;
clear;

% 参数定义
phi_w_vals = deg2rad([0,30,60,90]); % φw = 0°, 90°, 180°, 270° (弧度制)
phi = linspace(-pi, pi, 360);
%phi = linspace(0, 2*pi, 360); % φ 从 0 到 2π
k = 300; % 波数，可以调整
g = 9.81;
U_10 = 5;
kp = 0.84^2 * g / U_10^2; % 峰值波数
km = 370; % 中心波数
uf = 10; % 摩擦速度 (可以调整)
a0 = 0.173; % 参数 a0
ap = 4; % 参数 ap
am = 0.13 * uf / 0.23; % 参数 am

% 波速比定义
c_k = sqrt(g * (1 + k^2/km^2) / k); % 波速 c(k)
c_kp = sqrt(g * (1 + kp^2/km^2) / kp); % 波速 c(kp)
c_km = 0.23; % 波速 c(km)

% 计算 Delta(k)
Delta_k = tanh(a0 + ap * (c_k / c_kp)^2.5 + am * (c_km / c_k)^2.5);

line_styles = {'-','--', ':','-.'};

% 创建一个新的图形窗口
figure;

% 使用 polaraxes 创建极坐标图
ax = polaraxes; % 创建一个极坐标轴

% 绘制每个 φw 对应的雷达图
hold on;
for i = 1:length(phi_w_vals)
    phi_w = phi_w_vals(i);

    % 计算 G(k, φ)
    G_k_phi = (1 / (2 * pi)) * (1 + Delta_k * cos(2 * (phi - phi_w)));

    % 绘制曲线
    polarplot(phi, G_k_phi, 'LineStyle', line_styles{i}, 'LineWidth', 2, ...
        'DisplayName', ['\phi_w = ', num2str(rad2deg(phi_w)), '°'], 'Parent', ax);
end

% 图形设置
thetalim([-180 180]);
title('Elfouhaily 双边角分布函数雷达图');
legend;
hold off;