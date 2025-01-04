clear all;
close all;

% 设置 kx 和 ky 的范围
k = -2:0.005:2;  % 横纵波数分量范围为 [-2, 2]
[k_x, k_y] = meshgrid(k, k);  % 创建 k_x 和 k_y 的二维网格
K = sqrt(k_x.^2 + k_y.^2);  % 总波数 K = sqrt(k_x^2 + k_y^2)

% 计算全向海谱 S(k)，假设你已经有 Elfouhaily 函数
S_k = zeros(size(K));  % 初始化海谱矩阵

% 计算海谱
for i = 1:length(k_x)
    for j = 1:length(k_y)
        S_k(i,j) = Elfouhaily(5, max(K(i,j), 1e-10), 0);  % 计算海谱
    end
end

% 创建新的图形窗口
figure;

% 绘制三维图
mesh(k_x, k_y, S_k);  % 使用 mesh 绘制网格图
xlabel('k_x / m^{-1}');
ylabel('k_y / m^{-1}');
zlabel('S(k) / m^3');
title('Elfouhaily全向海谱的三维网格图(U=5m/s)');
grid on;

% 设置均匀的 colorbar 范围 [0, 0.025]
colormap jet;  % 默认配色
caxis([0, 0.025]);  % 设置颜色范围
colorbar;  % 添加颜色条

% 绘制俯视图
figure;
contourf(k_x, k_y, S_k, 20);  % 使用等高线填充图
xlabel('k_x / m^{-1}');
ylabel('k_y / m^{-1}');
title('Elfouhaily全向海谱的俯视图(U=5m/s)');
colormap jet;
colorbar;
