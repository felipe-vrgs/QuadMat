clear all
clc

g = - 9.81;       % Gravidade
Ix = 5e-3;      % Inércia eixo X
Iy = 5e-3;      % Inércia eixo Y
Iz = 10e-3;     % Inércia eixo Z
L = 0.25;       % Distância do centro até qualquer um dos motores
Km = 3e-6;      % Cte aerodinâmica (thrust)
Kf = 1e-7;      % Cte de arrasto (drag)
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