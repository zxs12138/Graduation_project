function  [G_k_phi] = Bilateral_angular_distribution_function(k, phi)
    % 参数定义
phi_w_vals = deg2rad([0, 90, 180, 270]); % φw = 0°, 90°, 180°, 270° (弧度制)
%phi = linspace(-1*pi/2, 1*pi/2, 180);
%phi = linspace(0, 2*pi, 360); % φ 从 0 到 2π
%k = 300; % 波数，可以调整
g = 9.81;
U_10 = 5;
kp = 0.84^2 * g/U_10^2; % 峰值波数
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
phi_w = 0;
% 计算 G(k, φ)
G_k_phi =(1 / (2 * pi)) * (1 + Delta_k * cos(2 * (phi - phi_w)));
