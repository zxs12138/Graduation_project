clear all;
close all;

% 参数设置
k_min = -2;   % 最小波数 k_x 和 k_y
k_max = 2;    % 最大波数 k_x 和 k_y
num_points = 400;  % 网格点数

% 计算k_x和k_y的范围
k_x = linspace(k_min, k_max, num_points);
k_y = linspace(k_min, k_max, num_points);

% 创建k_x和k_y的网格
[k_x, k_y] = meshgrid(k_x, k_y);

% 计算k和φ
K = sqrt(k_x.^2 + k_y.^2);  % k是波数，计算每对(k_x, k_y)的合成波数
phi = atan2(k_y, k_x);  % φ是方向角，通过atan2计算
S_k = zeros(size(K));

for i = 1:length(k_x)
    for j = 1:length(k_y)
        S_k(i,j) = Elfouhaily(5, max(K(i,j), 1e-10), 0);  % 计算海谱
        G1_k_phi(i,j) = LH_function(K(i,j), phi(j,i)); 
        %G2_k_phi(i,j) = Bilateral_angular_distribution_function(phi(j,i));
    end
end
%%
% 计算方向谱 S(k, φ)
S_k_phi = S_k .* G1_k_phi;  % S(k, φ)是全向海谱和角分布函数的乘积

% 绘制三维图
mesh(k_x, k_y, S_k_phi);  % 使用 mesh 绘制网格图
xlabel('k_x / m^{-1}');
ylabel('k_y / m^{-1}');
zlabel('Directional Spectrum S(k_x, k_y) (m^3)');
title('Directional Spectrum S(k_x, k_y)(U_{10}=5m/s)');
grid on;

% 设置均匀的 colorbar 范围 [0, 0.025]
colormap jet;  % 默认配色
%caxis([0, 0.003]);  % 设置颜色范围
colorbar;  % 添加颜色条
%%

