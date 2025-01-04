%%JONSWAP谱1

[x,S_Jon] = JONSWAP1(5 ,1 * 10^6); %5m/s
[x1,S_Jon1] = JONSWAP1(7,1 * 10^6); %10m/s
[x2,S_Jon2] = JONSWAP1(10 ,1 * 10^6); %15m/s

figure;
hold on;
plot(x,S_Jon,'LineWidth',1.5);
hold on;
plot(x1,S_Jon1,'LineWidth',1.5);
plot(x2,S_Jon2,'LineWidth',1.5);
box on
hold off
set(gca,'fontsize',14,'FontName','Times New Roman');%设置刻度字体大小
title('JONSWAP Spectrum (X=10km)', 'FontSize', 14);
legend({'5m/s', '7m/s','10m/s'},'Location','northeast','FontSize',14);
xlabel('wave number k(rad/cm)','fontsize',14,'FontName','Times New Roman');
ylabel('S(k)/m^3·rad','fontsize',14,'FontName','Times New Roman');

%%JONSWAP谱2

[x,S_Jon] = JONSWAP1(10 ,1 * 5*10^5); %5km
[x1,S_Jon1] = JONSWAP1(10 ,1 * 10^6); %10km
[x2,S_Jon2] = JONSWAP1(10 ,1 * 15*10^5); %15km

figure;
hold on;
plot(x,S_Jon,'LineWidth',1.5);
hold on;
plot(x1,S_Jon1,'LineWidth',1.5);
plot(x2,S_Jon2,'LineWidth',1.5);
box on
hold off
set(gca,'fontsize',14,'FontName','Times New Roman');%设置刻度字体大小
title('JONSWAP Spectrum', 'FontSize', 14);
legend({'5km', '10km','15km'},'Location','northeast','FontSize',14);
xlabel('wave number k(rad/cm)','fontsize',14,'FontName','Times New Roman');
ylabel('S(k)/m^3·rad','fontsize',14,'FontName','Times New Roman');

%% Bretschneider谱
[w,S_B1] = Bretsch(20);
[w,S_B2] = Bretsch(25);
[w,S_B3] = Bretsch(30);
figure;

hold on;
plot(w,S_B1,'LineWidth',1.5);
hold on;
plot(w,S_B2,'LineWidth',1.5);
plot(w,S_B3,'LineWidth',1.5);
box on

hold off
set(gca,'fontsize',14,'FontName','Times New Roman');
title('Bretschneider Spectrum', 'FontSize', 14);
legend({'20m/s', '25m/s','30m/s'},'Location','northeast','FontSize',14);
xlabel('wave number k(rad/cm)','fontsize',14,'FontName','Times New Roman');
ylabel('S(k)/cm^3·rad','fontsize',14,'FontName','Times New Roman');
% saveas(gca,'步式谱1.png');
%% PM谱
[w,S_PM1] = PM1(5);
[w,S_PM2] = PM1(7);
[w,S_PM3] = PM1(10);
figure;

hold on;
plot(w,S_PM1,'LineWidth',1.5);
hold on;
plot(w,S_PM2,'LineWidth',1.5);
plot(w,S_PM3,'LineWidth',1.5);
box on
hold off
set(gca,'fontsize',14,'FontName','Times New Roman');
title('Pierson-Moskowitz Spectrum', 'FontSize', 14);
legend({'U_{19.5}=5m/s', 'U_{19.5}=7m/s','U_{19.5}=10m/s'},'Location','northeast','FontSize',14);
xlabel('wave number k(rad/cm)','fontsize',14,'FontName','Times New Roman');
ylabel('S(k)/cm^3·rad','fontsize',14,'FontName','Times New Roman');
% saveas(gca,'PM谱1.png');

%% 几个谱函数

%% PM谱
function [w,s] = PM1(U)
i = 0;
for w = 0:0.01:1
    i = i+ 1;
    s(i) = 0.0081 / (4*w^3) * exp((-0.74) * (9.81^2) / (w^2 * U^4) );
end
w = 0:0.01:1;

end

%% JONSWAP谱
function [w,S] = JONSWAP1(U,X)
i = 0;
 gamma = 3.3;
 %gamma = exp(3.484 * (1 - 0.1975 * D * T_p^4)/)
 for omega = 0:0.01:5
     
     i = i+1;
     g = 9.81;
     alpha = 0.076 * (g * X/ U^2)^-0.22;
     omega_p = 22 * (g/U) * (g * X/U^2)^-0.33;
     %T_p = 2 * pi / omega_p;
     if omega > omega_p
         sigma = 0.09;
     else
         sigma = 0.07;
     end
     K = exp(-(omega - omega_p)^2 /(2 * sigma^2 * omega_p^2));
     
     S(i) = alpha * g^2 / omega^5 * exp(-5/4 * (omega_p / omega)^4) * gamma^K;
 end
    w = 0:0.01:5;
end



function [w,S] = Bretsch(U)
%% 布氏谱
i = 0;
W_m = 9.81 / U;
H = 0.22 * U^2 / 9.81;

for w = 0:0.01:1
    i = i+1;
    S(i) = 1.25 / 4 * W_m^4 / w^5 * H * exp(-1.25*(W_m/w)^4);
end
    
w = 0:0.01:1;

end
