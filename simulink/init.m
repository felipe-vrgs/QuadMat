clear all
clc

g = - 9.81;       % Gravidade
Ix = 5e-3;      % In�rcia eixo X
Iy = 5e-3;      % In�rcia eixo Y
Iz = 10e-3;     % In�rcia eixo Z
L = 0.25;       % Dist�ncia do centro at� qualquer um dos motores
Km = 3e-6;      % Cte aerodin�mica (thrust)
Kf = 1e-7;      % Cte de arrasto (drag)
m = 0.5;        % Massa do drone
Jr = 6e-5;      % In�rcia do rotor
% Redu��o de vari�veis
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