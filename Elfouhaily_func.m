function  [SeaE, B_l, B_h] = Elfouhaily(wind_spd, wave_number, azimuth)
%ElfSpectrum: Compute Elfouhaily wave spectrum
%
% Usage: PSI = ElfSpectrum(wave_number,azimuth,wind_spd,wave_age)
%
% Purpose: Compute the unified directional spectrum of Elfouhaily
% (JGR, 102, No. C7, 15781-15796.). Assumes the wind direction is
% along positive x-axis in normal Cartesian plane.
%
% Inputs:
%  wave_number: wave number (k)
%  azimuth: azimuth angle (phi degrees)
%  wind_spd: wind speed at 10 m height (m/s)
%  wave_age: inverse wave age (0.84 for well-developed seas) 取0.84
%
% Outputs:
%  PSI: wave spectrum
%
% Notes: Assumes the wind direction is along positive x-axis in normal
% Cartesian plane.
%
% Sources:
%  Elfouhaily paper: JGR, 102, No. C7, p. 15781-15796
%  Zavorotny (Elfouhaily) fortran code
%
% Dallas Masters
% Copyright 2003 under GNU GPL
% University of Colorado
% mastersd@colorado.edu
% $Revision: 1.1 $   $Date: 2004/03/17 17:01:52 $

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
% USA


% Global constants
cGrav = 9.81;    % Gravity at surface

% Rename variables consistent with papers
wave_age = 0.84;        %充分发展的海域
k = wave_number;
phi = (azimuth) * pi / 180;
fetch = wave_age;
U10 = wind_spd;

c_m = 0.23;
k_m = 370;
% k_m = 2*cGrav / (c_m)^2;

k_0 = cGrav./(U10.^2);
X = fetch.*k_0;
X_0 = 2.2e4;
c = sqrt(cGrav.*(1 + (k./k_m).^2)./k);

if fetch > 1000
  omega_c = 0.84.*tanh(((X./X_0).^0.4).^0.75);
else
  omega_c = fetch;
end

% 摩擦风速
% Ustar = HEXOS(U10,omega_c);
Ustar = wind_spd .* sqrt(0.001*(0.81 + 0.65*wind_spd));

if Ustar < c_m
  alpha_m = (1e-2).*(1 + log(Ustar./c_m));
else
  alpha_m = (1e-2).*(1 + 3.*log(Ustar./c_m));
end

k_p = k_0.*omega_c.^2;

% Original from JGR
% c_p = sqrt(cGrav.*(1 + (k_p./k_m).^2)./k_p);

% New value from Zavorotny
c_p = U10./omega_c;

delta = 0.08.*(1 + 4./(omega_c.^3));

if omega_c < 1
  gamma = 1.7;
else
  gamma = 1.7 + 6.*log10(omega_c);
end

GAMMA = exp(-((sqrt(k./k_p)-1).^2)./2./(delta.^2));
J_p = gamma.^GAMMA;
L_pm = exp(-5.*((k_p./k).^2)./4);

a_m = 0.13.*Ustar./c_m;
a_0 = log(2)./4;
a_p = 4;
delta_k = tanh(a_0 + a_p.*((c./c_p).^2.5) + a_m.*((c_m./c).^2.5));

F_p = L_pm.*J_p.*exp(-omega_c.*(sqrt(k./k_p) - 1)./sqrt(10));
F_m = L_pm.*J_p.*exp(-(((k./k_m)-1).^2)./4);

% Low freq. component original B_l from JGR
%B_l = alpha_p.*c_p.*F_p./c./2;

% New B_l from Zavorotny
B_l = (3e-3).*sqrt(omega_c.*k./k_p).*F_p;

% High freq. component
B_h = alpha_m.*c_m.*F_m./c./2;

% Unified directional spectrum
SeaE = (B_l + B_h).*(1 + delta_k.*cos(2.*phi))./2./pi./(k.^3);
