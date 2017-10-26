%% Quadcopter: function description
%! @brief      Describes the space state equations
%! @param      t     time vector
%! @param      x     inital conditions
%! @return     an array with dx
function dx = Quadcopter(t,x)
    % Montando o array dx que retorna da funcao
    dx = zeros(12,1);
    %{
        x(1) => phi
        x(2) => dphi/dt
        x(3) => theta
        x(4) => dtheta/dT
        x(5) => psi
        x(6) => dpsi/dT
        x(7) => z
        x(8) => dz/dt
        x(9) => x
        x(10) => dx/dT
        x(11) => y
        x(12) => dy/dT
    %}
    global g Km b m a Kf;

    % W é a vel angular em cada motor
    W = [6000 5000 6000 7000];
    % W = [0 0 0 0];

    % Matriz U das entradas
    % U(1) = Kf*(W(1)^2 + W(2)^2 + W(3)^2 + W(4)^2);   % Total Thrust
    % U(2) = Kf*(W(4)^2 - W(2)^2);                     % Roll
    % U(3) = Kf*(- W(3)^2 + W(1)^2);                   % Pitch
    % U(4) = Km*(W(1)^2 - W(2)^2 + W(3)^2 - W(4)^2);   % Yaw
    U = [5 0 2 0];
                                                
  
    
    % Omega é a velocidade relativa do motor
    Omega = W(1) - W(2) + W(3) - W(4);

    % Equações de esp. estados
    dx(1) = x(2);                                                               % Vel ang (phi)
    dx(2) = b(1)*U(2) - x(4)*Omega*a(2) + a(1)*x(4)*x(6);                       % Acel ang (phi)
    dx(3) = x(4);                                                               % Vel ang (theta) 
    dx(4) = b(2)*U(3) + x(2)*Omega*a(4) + a(3)*x(2)*x(6);                       % Acel ang (theta) 
    dx(5) = x(6);                                                               % Vel ang (ksi)
    dx(6) = b(3)*U(4) + a(5)*x(2)*x(4);                                         % Acel ang (ksi)
    dx(7) = x(8);                                                               % Vel Z
    dx(8) = g + (U(1)/m)*(cos(x(1))*cos(x(3)));                                 % Acel Z
    dx(9) = x(10);                                                              % Vel X
    dx(10) = (-U(1)/m)*(sin(x(1))*sin(x(5)) + cos(x(1))*sin(x(3))*cos(x(5)));   % Acel X
    %dx(10) = (-U(1)/m)*(x(5)*sin(x(3)) - cos(x(5))*x(1));                      % Simplificação da eq de cima
    dx(11) = x(12);                                                             % Vel Y
    dx(12) = (U(1)/m)*(sin(x(1))*cos(x(5)) - cos(x(1))*sin(x(3))*sin(x(5)));    % Acel Y
    %dx(12) = (-U(1)/m)*(x(1)*sin(x(5)) + x(5)*sin(x(3)));                      % Simplificação da eq de cima
end

