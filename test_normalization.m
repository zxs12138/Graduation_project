clc;
clear;

% 定义参数
phi_w_vals = deg2rad([0, 90, 180, 270]); % φw = 0°, 90°, 180°, 270° (弧度制)
phi = linspace(-1*pi, 1*pi, 360); % φ 从 0 到 2π
%phi = linspace(0, 2*pi, 360);
g = 9.814;
kp = 370; % 峰值波数
k = 3 * kp; % 波数，可以自行设定
U19_5 = 10; % 风速（可以调整）
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

    phi_w = phi_w_vals(1);
    % 计算 G(k, φ) 对应的分布函数
    G_k_phi =@(k, phi)(1 / sqrt(pi)) * (gamma(1 + 0.5 * p) / gamma(0.5 + 0.5 * p)) ...
              .* abs(cos(phi - phi_w)).^(2 * p);

% 计算 G_k_phi 在 phi 上的积分
G_values = G_k_phi(k, phi);  % 计算函数值
integral_value = trapz(phi, G_values);  % 使用梯形积分计算

% 输出结果
fprintf('归一化验证结果：\n');
fprintf('积分值 = %.6f\n', integral_value);

% 可视化角分布函数
figure;
plot(phi, G_values, 'b-', 'LineWidth', 1.5);
xlabel('\phi (rad)');
ylabel('G_k(\phi)');
title('双边角分布函数 G_k(\phi)');
grid on;
