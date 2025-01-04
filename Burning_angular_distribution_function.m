clc;
clear;

% 定义参数
phi_w_vals = deg2rad([0, 90, 180, 270]); % φw = 0°, 90°, 180°, 270° (弧度制)
phi = linspace(-1*pi, 1*pi, 360); % φ 从 0 到 2π
%phi = linspace(0, 2*pi, 360);
g = 9.814;
k = 1; % 波数，可以自行设定
kp = 3; % 峰值波数
U19_5 = 0.1; % 风速（可以调整）
c_km = 0.23; % 波速 c(km)（可以调整）

% 计算 pm
pm = 11.5 * (U19_5 / c_km)^(-2.5);
disp(pm)
% 计算 p(k)
p = zeros(size(k));
if k < kp
    p = 0.46 * (k / kp)^2.5 * pm;
else
    p = 0.46 * (k / kp)^(-1.25) * pm;
end
disp(p)

line_styles = {'-', '--', ':', '-.'};

% 创建极坐标图
figure;
ax = polaraxes; % 创建极坐标轴

% 计算分布函数 G(k, φ) 对于每个 φw，并绘制每条曲线
hold on;
for i = 1:length(phi_w_vals)
    phi_w = phi_w_vals(i);
    % 计算 G(k, φ) 对应的分布函数
    G_k_phi =(1 / sqrt(pi)) * (gamma(1 + 0.5 * p) / gamma(0.5 + 0.5 * p)) ...
              .* abs(cos(phi - phi_w)).^(2 * p);
    %disp(gamma(1 + 0.5 * p))
    %disp(gamma(0.5 + 0.5 * p))
    %disp(abs(cos(phi - phi_w)).^(2 * p))
    % 绘制每条曲线
    polarplot(phi, G_k_phi, 'LineStyle', line_styles{i}, 'DisplayName', ['\phi_w = ', num2str(rad2deg(phi_w)), '°'],'LineWidth', 2);
end

% 图形设置
title('Burning双边角分布函数雷达图');

% 去除横纵坐标
%ax.ThetaTick = [];  % 去掉角度刻度
%ax.RTick = [];      % 去掉半径刻度
%ax.ThetaAxisLocation = 'top';  % 设置角度刻度位置为顶部
%ax.RLim = [0, max(G_k_phi)];  % 设置半径范围

legend;
hold off;