clear; clc;

% 参数设置
Lx = 200;   % 海域长度 (m)
Ly = 200;   % 海域宽度 (m)
dx = 0.5;     % 网格步长
dy = 0.5;
x = -Lx/2:dx:Lx/2; % X方向网格
y = -Ly/2:dy:Ly/2; % Y方向网格
[X, Y] = meshgrid(x, y);

% 线性海面生成
kx = 2*pi/Lx * (-length(x)/2:length(x)/2-1); % 波数向量 (X方向)
ky = 2*pi/Ly * (-length(y)/2:length(y)/2-1); % 波数向量 (Y方向)
[Kx, Ky] = meshgrid(kx, ky);
K = sqrt(Kx.^2 + Ky.^2);

% 定义海浪方向谱 (Pierson-Moskowitz)
g = 9.81; % 重力加速度
U10 = 15; % 增大风速
scale_factor = 1; % 调整比例因子
S = scale_factor * 0.0081 * g^2 ./ (K.^3) .* exp(-0.74 * (g./(U10 .* K)).^4);
S(K==0) = 0; % 去掉零波数

% 随机相位生成
phi = 2*pi*rand(size(S));
Z_linear = sqrt(S) .* exp(1i * phi); % 频域线性海面

% 希尔伯特变换 (频域)
Z_hilbert = 1i * sign(K) .* Z_linear;

% 非线性海面生成
epsilon = 0.3; % 非线性强度
Z_nonlinear = Z_linear + epsilon * Z_hilbert;

% 逆傅里叶变换到时域
z = ifft2(ifftshift(Z_nonlinear)) * (length(x) * length(y)); % 归一化
z = real(z); % 取实部

% 计算 RMS
rms_linear = sqrt(mean(Z_linear(:).^2));          % 线性海面的 RMS
rms_nonlinear = sqrt(mean(Z_nonlinear(:).^2));    % 非线性海面的 RMS

% 计算斜率
[dz_dx_linear, dz_dy_linear] = gradient(Z_linear); % 线性海面梯度
[dz_dx_nonlinear, dz_dy_nonlinear] = gradient(Z_nonlinear); % 非线性海面梯度

% 计算斜率 RMS
slope_rms_linear = sqrt(mean(dz_dx_linear(:).^2 + dz_dy_linear(:).^2)); % 线性海面斜率 RMS
slope_rms_nonlinear = sqrt(mean(dz_dx_nonlinear(:).^2 + dz_dy_nonlinear(:).^2)); % 非线性海面斜率 RMS

% 输出结果
fprintf('线性海面 RMS: %.4f\n', rms_linear);
fprintf('线性海面斜率 RMS: %.4f\n', slope_rms_linear);
fprintf('非线性海面 RMS: %.4f\n', rms_nonlinear);
fprintf('非线性海面斜率 RMS: %.4f\n', slope_rms_nonlinear);


% 可视化
figure;
mesh(X, Y, z);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Height (m)');
title('Creamer非线性海面(U_10=5m/s,风向0°)');
colorbar;
