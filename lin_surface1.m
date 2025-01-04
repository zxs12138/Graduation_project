% 参数设置
Lx = 120; % X方向海域范围 (m)
Ly = 120; % Y方向海域范围 (m)
Nx = 399; % X方向离散点数
Ny = 399; % Y方向离散点数
dx = Lx / Nx;
dy = Ly / Ny;
[x,y]=meshgrid(-100:0.5:99.75);

T = 1; % 模拟时间 (s)
dt = 0.1; % 时间步长
t = 0:dt:T;

M = 50; % 频率离散点数
N = 36; % 方向角离散点数
omega_min = 0; % 最小角频率 (rad/s)
omega_max = sqrt(4*9.81); % 最大角频率 (rad/s)
theta_min = 0; % 最小方向角 (rad)
theta_max = 2 * pi; % 最大方向角 (rad)

% 波数、频率和方向的离散化
omega = linspace(omega_min, omega_max, M); % 离散频率
theta = linspace(theta_min, theta_max, N); % 离散方向角
domega = omega(2) - omega(1); % 频率间隔
dtheta = theta(2) - theta(1); % 方向间隔

% 功率谱密度 S(k, theta) 的表达式
%S = Directional_spectrum(k, phi); % 示例谱密度，请替换为您的表达式
k = omega.^2 / 9.81; % 波数与频率的关系（浅水条件下）

% 初始相位
epsilon = 2 * pi * rand(M, N);

% 计算海面波浪高度
eta = zeros(Nx+1, Ny+1, length(t));
for ti = 1:length(t)
    for i = 1:M
        for j = 1:N
            % 每个波的贡献
            amplitude = sqrt(2 * Directional_spectrum(k(i), theta(j)) * domega * dtheta); % 振幅
            eta(:,:,ti) = eta(:,:,ti) + amplitude * cos(k(i) * (x * cos(theta(j)) + y * sin(theta(j))) - omega(i) * t(ti) + epsilon(i, j));
        end
    end
end

colorbarMin = -0.5; % 设置最小值
colorbarMax = 0.5;  % 设置最大值

% 创建 VideoWriter 对象并设置保存参数
videoFileName = 'wave_simulation.avi'; % 保存的视频文件名
v = VideoWriter(videoFileName); % 创建 VideoWriter 对象
v.FrameRate = 10; % 设置帧率（每秒帧数）
open(v); % 打开视频对象

% 生成动画并保存
for ti = 1:length(t)
    mesh(x, y, eta(:, :, ti)); % 使用 mesh 绘制
    title(['海面波浪模拟 - 时间: ', num2str(t(ti)), ' s']);
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('波浪高度 (m)');
    colorbar;
    clim([colorbarMin colorbarMax]); % 固定 colorbar 范围
    axis([-100 100 -100 100 -2 2]); % 设置坐标轴范围
    
    % 捕获当前帧并写入视频
    frame = getframe(gcf); % 捕获当前图像
    writeVideo(v, frame); % 写入视频
    
    pause(0.1);
end

% 关闭 VideoWriter 对象
close(v);

disp(['视频已保存为 ', videoFileName]);
