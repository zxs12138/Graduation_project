function  [G_k_phi] = LH_function(k, phi)
% 参数定义
phi_w_vals = deg2rad([0, 45, 180, 270]); % φw = 0°, 90°, 180°, 270° (弧度制)
%phi = linspace(-1*pi/2, 1*pi/2, 180);
%phi = linspace(0, 2*pi, 360); % φ 从 0 到 2π
g = 9.81;
km = 370; % 中心波数
uf = 15; % 摩擦速度 (可以调整)
a0 = 0.173; % 参数 a0
ap = 4; % 参数 ap
X = 3e4;
omega_c = 7 * pi * X^(-0.33);
U_10 = 5;

kp = omega_c^2 * g / U_10^2; % 峰值波数
%k = 3*kp; % 波数，可以调整

% 波速比定义
c_k = sqrt(g * (1 + k^2/km^2) / k); % 波速 c(k)
c_kp = sqrt(g * (1 + kp^2/km^2) / kp); % 波速 c(kp)
c_km = 0.23; % 波速 c(km)
am = 0.13 * uf / c_km; % 参数 am
% 计算 Delta(k)
Delta_k = tanh(a0 + ap * (c_k / c_kp)^2.5 + am * (c_km / c_k)^2.5);

s = 1-log((1 - Delta_k) / (1 + Delta_k)) / log(2);

    phi_w = phi_w_vals(2);

    % 计算 G(k, φ)
    G0 = 2^(2*s-1) / pi * (gamma(s+1))^2/(gamma(2*s+1));
    G_k_phi = G0 .* abs(cos(((phi - phi_w)/2))) .^ (2*s);
