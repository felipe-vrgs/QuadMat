clear all
clc

g = -9.81;     % Gravidade
Ix = 7.5e-3;      % Inércia eixo X
Iy = 7.5e-3;      % Inércia eixo Y
Iz = 1.3e-2;     % Inércia eixo Z
L = 0.2;       % Distância do centro até qualquer um dos motores
Km = 7.5e-7;      % Cte aerodinâmica (thrust)
Kf = 3.13e-5;      % Cte de arrasto (drag)
m = 0.5;        % Massa do drone
Jr = 6e-5;      % Inércia do rotor
% Redução de variáveis
a(1) = (Iy - Iz)/Ix;
a(2) = Jr/Ix;
a(3) = (Iz - Ix)/Iy;
a(4) = Jr/Iy;
a(5) = (Ix - Iy)/Iz;
b(1) = L/Ix;
b(2) = L/Iy;
b(3) = L/Iz;

% Ganhos dos controladores
% kp_z 
% kp_phi
% kp_theta
% kp_psi
% 
% ki_z
% ki_phi
% ki_theta
% ki_psi
% 
% kd_z
% kd_phi
% kd_theta
% kd_psi