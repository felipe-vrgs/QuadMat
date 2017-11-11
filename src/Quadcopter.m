% Quadcopter: Modelo em espaço de estados do quadricóptero
%
% @brief      Descrição das equações de espaço de estados e aplicação de controle
%             PID
%             
% @param      t        Tempo
% @param      x        Condições Iniciais
% @param      control  Qual controlador será usado (para quando tiver mais que um) 
% @param      gains    Ganhos do controlador (para o genético)
% @param      target   Malha que deve se inserir os ganhos (para o genético)
% @param      sp       Set Point
%
% @return     A matriz com as derivadas
%
function dx = Quadcopter(t,x,control,gains,target,sp)
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
    global g Km b m a Kf U_hist;

    % Valores iniciais para o PID, 1 -> kp | 2-> ki | 3-> kd
    % Esses valores já sao os otimizados com o AG
    kz(1) = 10.5183;
    kz(2) = 0.0046;
    kz(3) = 3.633;

    kphi(1) = 2.4932;
    kphi(2) = 0;
    kphi(3) = 1.8975;

    kphi(1) = 171.9776;
    kphi(2) = 0.3107;
    kphi(3) = 30.0775;

    ktheta(1) = 1.1783;
    ktheta(2) = 0;
    ktheta(3) = 1.2595;

    kpsi(1) = 1.8509;
    kpsi(2) = 0;
    kpsi(3) = 1.6949;

    % Valores para os setpoints (2 para a altura e os ângulos devem ficar estáveis em 0)
    setpoint(1) = 2;
    setpoint(2) = 0;
    setpoint(3) = 0;
    setpoint(4) = 0;

    % Subs quando usado o genetico
    switch target
        case 'z'
            kz(1) = gains(1);
            kz(2) = gains(2);
            kz(3) = gains(3); 
            setpoint(1) = sp;
        case 'phi'
            kphi(1) = gains(1);
            kphi(2) = gains(2);
            kphi(3) = gains(3); 
            setpoint(2) = sp;
        case 'theta'
            ktheta(1) = gains(1);
            ktheta(2) = gains(2);
            ktheta(3) = gains(3); 
            setpoint(3) = sp;
        case 'psi'
            kpsi(1) = gains(1);
            kpsi(2) = gains(2);
            kpsi(3) = gains(3); 
            setpoint(4) = sp;
        otherwise
    end

    % As 4 malhas de controle já fechadas e aplicadas nos esforços de controle
    U(1) = PID([kz(1) kz(2) kz(3)], x, setpoint(1), 'U1',t);
    U(2) = PID([kphi(1) kphi(2) kphi(3)], x, setpoint(2), 'U2', t);
    U(3) = PID([ktheta(1) ktheta(2) ktheta(3)], x, setpoint(3), 'U3', t);
    U(4) = PID([kpsi(1) kpsi(2) kpsi(3)], x, setpoint(4), 'U4', t);

    % Para conseguir plotar o esforço de controle depois
    global U_hist T_hist;
    U_hist = [U_hist; U];
    T_hist = [T_hist; t];
    
    % Calculando a velocidade angular dos motores para os esforços de controle obtidos.
    W(1) = ((U(1)/(4*Kf)) + (U(3)/(2*Kf)) + (U(4)/(4*Km)))^(1/2);
    W(2) = ((U(1)/(4*Kf)) - (U(2)/(2*Kf)) - (U(4)/(4*Km)))^(1/2);
    W(3) = ((U(1)/(4*Kf)) - (U(3)/(2*Kf)) + (U(4)/(4*Km)))^(1/2);
    W(4) = ((U(1)/(4*Kf)) + (U(2)/(2*Kf)) - (U(4)/(4*Km)))^(1/2);                    
  
    
    % Omega é a velocidade relativa do motor
    Omega = W(1) - W(2) + W(3) - W(4);

    % Equações de esp. estados
    dx(1) = x(2);                                                               % Vel ang (phi)
    dx(2) = b(1)*U(2)  + a(1)*x(4)*x(6);                                        % Acel ang (phi)
    dx(3) = x(4);                                                               % Vel ang (theta) 
    dx(4) = b(2)*U(3)  + a(3)*x(2)*x(6);                                        % Acel ang (theta) 
    dx(5) = x(6);                                                               % Vel ang (ksi)
    dx(6) = b(3)*U(4)  + a(5)*x(2)*x(4);                                        % Acel ang (ksi)
    dx(7) = x(8);                                                               % Vel Z
    dx(8) = - g + (U(1)/m)*(cos(x(1))*cos(x(3)));                               % Acel Z
    dx(9) = x(10);                                                              % Vel X
    dx(10) = (-U(1)/m)*(sin(x(1))*sin(x(5)) + cos(x(1))*sin(x(3))*cos(x(5)));   % Acel X
    dx(11) = x(12);                                                             % Vel Y
    dx(12) = (U(1)/m)*(sin(x(1))*cos(x(5)) - cos(x(1))*sin(x(3))*sin(x(5)));    % Acel Y
end

