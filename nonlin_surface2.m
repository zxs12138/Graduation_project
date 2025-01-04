
clear;
clc;

% 网格设置
[x, y] = meshgrid(-100:0.5:99.75);
dkx = 2 * pi / 200;
dky = 2 * pi / 200; 
kx = [(dkx:dkx:(200 * dkx)), -fliplr(dkx:dkx:(200 * dkx))];
ky = kx;

[kx, ky] = meshgrid(kx, ky);
A = dkx * dky; % 单位面元

% 高斯噪声生成
B = normrnd(0, 1, 400, 400);  % 均值，方差，矩阵，正态分布
B2 = normrnd(0, 1, 400, 400);
r = (B + 1i * B2) / 2.^0.5;
rr = (rot90(B, 2) + 1i * rot90(B2, 2)) / 2.^0.5;
z = conj(rr);

% 频谱定义
S = zeros(400, 400);
Q = zeros(400, 400);
u = 5; % 风速
s = 10; % 风谱指数
phi0 = pi / 2; % 风向

% Elfouhaily方向谱计算
S = (0.5 * 0.0081 * ((kx.^2 + ky.^2).^0.5).^(-3) .* exp(-0.74 * 9.81^2 * u^(-4) * ((kx.^2 + ky.^2).^0.5).^(-2))) ...
    .* (2^(2 * s - 1) * gamma(s + 1)^2 / (pi * gamma(2 * s + 1)) * cos((atan2(kx, ky) - phi0) / 2).^(2 * s)) ./ ((kx.^2 + ky.^2).^0.5);

Q = (0.5 * 0.0081 * ((kx.^2 + ky.^2).^0.5).^(-3) .* exp(-0.74 * 9.81^2 * u^(-4) * ((kx.^2 + ky.^2).^0.5).^(-2))) ...
    .* (2^(2 * s - 1) * gamma(s + 1)^2 / (pi * gamma(2 * s + 1)) * cos((pi - atan2(kx, ky) - phi0) / 2).^(2 * s)) ./ ((kx.^2 + ky.^2).^0.5);

% 生成海面高频域
H = r .* (S .* A).^0.5 .* exp(1i * (9.81 * ((kx.^2 + ky.^2).^0.5 .* (1 + (kx.^2 + ky.^2) / 363)).^0.5)) + ...
    conj(rr) .* (Q .* A).^0.5 .* exp(-1i * (9.81 * ((kx.^2 + ky.^2).^0.5 .* (1 + (kx.^2 + ky.^2) / 363)).^0.5));

% 线性海面生成
Z_linear = ifft2(400 * 400 * H);
Z_linear = real(Z_linear);

% **Creamer 模型：对海面进行非线性调整**
% 计算波浪的相位谱和振幅
Z_linear_freq = fft2(Z_linear);

% 获取振幅和相位
amplitude = abs(Z_linear_freq);
phase = angle(Z_linear_freq);

% 对相位进行希尔伯特变换，且对变换幅度做微调
phase_nonlinear = phase + 0.5 * imag(hilbert(phase));  % 控制扰动幅度，避免过大的相位变化

% 合成非线性海面：振幅保持不变，调整相位
Z_nonlinear_freq = amplitude .* exp(1i * phase_nonlinear);

% 生成非线性海面
Z_nonlinear = ifft2(Z_nonlinear_freq);
Z_nonlinear = real(Z_nonlinear);


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

mesh(y, x, Z_linear);
hold on;
title('线性海面生成');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('波浪高度 (m)');
axis([-100 100 -100 100 -1 1]); % 设置坐标轴范围
colorbar;


mesh(y, x, Z_nonlinear);
title('Creamer模型生成非线性海面');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('波浪高度 (m)');
axis([-100 100 -100 100 -1 1]); % 设置坐标轴范围
colorbar;
