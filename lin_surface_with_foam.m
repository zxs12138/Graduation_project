% 初始化
clear;
clc;

% 设置海面初始范围和网格分辨率
x_range = linspace(-200, 200, 400); % 原始网格 X 方向
y_range = linspace(-200, 200, 400); % 原始网格 Y 方向
[x, y] = meshgrid(x_range, y_range);

% 生成初始线性海面 H
H = lin_surface2(); % 模拟海面，范围 [-1.3, 1.3] m

% 海面网格精细化
[x_fine, y_fine] = meshgrid(linspace(-200, 200, 800), linspace(-200, 200, 800)); % 精细化网格
H_fine = interp2(x, y, H, x_fine, y_fine, 'cubic'); % 插值到精细化网格

% 初始化白冠泡沫覆盖掩膜
foam_mask = zeros(size(H_fine));

% 滑动窗口参数
window_size = 50; % 滑动窗口大小，9x9邻域
half_window = floor(window_size / 2);
% 参数定义
foam_half_window = 5; % 白冠检测范围半径
threshold = 0.06; % 白冠覆盖的波陡值阈值
% 创建白冠覆盖矩阵（和H_fine大小一致）
foam_mask = zeros(size(H_fine));
extrema_points = zeros(size(H_fine)); % 初始化极值点标记矩阵

% 遍历海面矩阵（滑动窗口的中心区域）
for i = 1 + half_window:size(H_fine, 1) - half_window
    for j = 1 + half_window:size(H_fine, 2) - half_window
        % 提取滑动窗口
        local_window = H_fine(i-half_window:i+half_window, j-half_window:j+half_window);
        
        % 在窗口内找到波峰（即局部最高值的位置）
        [peak_value, linear_index] = max(local_window(:));
        [local_row, local_col] = ind2sub(size(local_window), linear_index);

        % 将波峰的全局坐标转换回原始网格的坐标
        global_row = i - half_window + local_row - 1;
        global_col = j - half_window + local_col - 1;
        extrema_points(global_row, global_col) = 1;

        % 确保这个点是波峰且没有被重复处理
        if foam_mask(global_row, global_col) == 0
            % 提取波峰附近区域（foam_half_window）
            foam_window = H_fine(max(global_row-foam_half_window, 1):min(global_row+foam_half_window, size(H_fine, 1)), ...
                                 max(global_col-foam_half_window, 1):min(global_col+foam_half_window, size(H_fine, 2)));
            
            % 计算波陡值 (局部区域的斜率)
            [grad_x, grad_y] = gradient(foam_window);
            slope = sqrt(grad_x.^2 + grad_y.^2);
            
            % 判断是否超过阈值（只针对波峰区域处理）
            if max(slope(:)) > threshold
                foam_mask(global_row, global_col) = 1; % 标记此点有白冠覆盖
            end
        end
    end
end

% 在俯视图上显示白冠覆盖
figure;
hold on;
imagesc([-200, 200], [-200, 200], H_fine); % 绘制海面俯视图
colorbar;
%scatter(x_fine(extrema_points == 1), y_fine(extrema_points == 1), 5, 'w', 'filled'); % 标记极值点
scatter(x_fine(foam_mask == 1), y_fine(foam_mask == 1), 5, 'w', 'filled');
title('海面白冠覆盖显示(U_{10}=17m/s)');
xlabel('X');
ylabel('Y');
hold off;
