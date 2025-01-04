function [S_k_phi]=Directional_spectrum(k, phi)
    G1_k_phi = Bilateral_angular_distribution_function(k, phi); 
    S_k = Elfouhaily(5, max(k, 1e-10), 0);  % 计算海谱
% 计算方向谱 S(k, φ)
    S_k_phi = S_k .* G1_k_phi;  % S(k, φ)是全向海谱和角分布函数的乘积