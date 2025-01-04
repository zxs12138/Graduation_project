clear;
clc;

[x,y]=meshgrid(-100:0.5:99.75);
dkx=2.*pi./200;
dky=2.*pi./200;
%二维傅里叶
kx=[(dkx:dkx:(200.*dkx)),-fliplr(dkx:dkx:(200.*dkx))];
ky=kx;

[kx,ky]=meshgrid(kx,ky);
A=dkx.*dky; %单位面元
 
B=normrnd(0,1,400,400);%均值，方差,矩阵,正太分布
B2=normrnd(0,1,400,400);

r=(B+1i.*B2)./2.^0.5;
rr=(rot90(B,2)+1i.*rot90(B2,2))./2.^0.5;

z=conj(rr);
S = zeros(400,400);
Q = zeros(400,400);
u=5;
s=10;
phi0=0;


S=(0.5.*0.0081.*((kx.^2+ky.^2).^0.5).^(-3).*exp(-0.74.*9.81.^2.*u.^(-4).*((kx.^2+ky.^2).^0.5).^(-2))).*(2^(2*s-1)*gamma(s+1)^2./(pi*gamma(2*s+1))*cos((atan2(kx,ky)-phi0)./2).^(2*s))./((kx.^2+ky.^2).^0.5);
Q=(0.5.*0.0081.*((kx.^2+ky.^2).^0.5).^(-3).*exp(-0.74.*9.81.^2.*u.^(-4).*((kx.^2+ky.^2).^0.5).^(-2))).*(2^(2*s-1)*gamma(s+1)^2./(pi*gamma(2*s+1))*cos((pi-atan2(kx,ky)-phi0)./2).^(2*s))./((kx.^2+ky.^2).^0.5);
 
H=r.*(S.*A).^0.5.*exp(1i.*(9.81.*((kx.^2+ky.^2).^0.5.*(1+(kx.^2+ky.^2)./363)).^0.5))   +   conj(rr).*(Q.*A).^0.5.*exp(-1i.*(9.81.*((kx.^2+ky.^2).^0.5.*(1+(kx.^2+ky.^2)./363)).^0.5));
 
Z=ifft2(400.*400.*H);

Z=real(Z);

%disp(size(Z));
mesh(y,x,Z);
    title('线性过滤法生成海面(Elfouhaily方向谱，U_{10}=5m/s)');
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('波浪高度 (m)');
    %axis([-100 100 -100 100 -1 1]); % 设置坐标轴范围

colorbar;