clear all;
close all;

% ���ò�����Χ
lkmin = log(1e-3);
lkmax = log(1e+4);
dk = (lkmax - lkmin) / 100000;
wave_number = exp(lkmin:dk:lkmax);

% ��ʼ������
Sea = zeros(10, 100001);
wind_speed = 3:2:21;  % ��ͬ����
line_styles = {'-', '--', ':', '-.', '-', '--', ':', '-.', '-', '--'}; % ��ͬ����

% ���� Elfouhaily ��
for ii = 1:length(wind_speed)
    [Sea(ii, :),B_l(ii, :),B_h(ii, :)] = Elfouhaily(wind_speed(ii), wave_number, 0);  % ����ÿ�����ٵ���
end

% ��ͼ
figure;
hold on;
for ii = 1:length(wind_speed)
    % ȷ��Ϊÿ������ѡ��ͬ�����Ͳ�����
    loglog(wave_number, Sea(ii, :), 'LineWidth', 2, 'LineStyle', line_styles{ii}, 'DisplayName', sprintf('U_{10} = %d m/s', wind_speed(ii)));
end

% ����ͼ��
legend('show', 'Location', 'southwest');

% ������ͱ���
set(gca, 'XScale', 'log', 'YScale', 'log'); 
axis([1e-3 1e4 1e-18 1e5]);
grid on;
xlabel('���� k / m^{-1}');
ylabel('Elfouhaily�� S(k) / m^3');
title('��ͬ�����µ� Elfouhaily ������');
hold off;
