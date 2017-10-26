%% Main function, describes the global variables and does the simulation
function ExecMain
    clear all;
    clc;
    SetGlobals();
    global divisoes;
    %{
        A função ode45 aceita como primeiro parâmetro as derivadas do espaço
        de estados, como segundo o tempo de simulação e o terceiro é um array
        com as condições iniciais do sistema.
    %}
    [t,X] = ode45(@Quadricopter,0:0.001:10,[0 0 0 0 0 0 0 0 0 0 0 0]);
    cacm = zeros(divisoes,divisoes);
    %{
    	for k=1:length(t)
            x1 = X(k,3)
            x2 = X(k,4)
            [i,j] = AchaCelula(x1,x2);
            cacm(i,j) = cacm(i,j) + 1;
        end
    %}
    % comet3(X(:,11),X(:,9),X(:,7)); % Plot de X, Y, Z
    % comet3(X(:,1),X(:,3),X(:,5)); % Plot dos ângulos
    % grid on
    % title('Posicao Drone','Interpreter','Latex')
    % ylabel('y','Interpreter','Latex')
    % xlabel('x','Interpreter','Latex')
    % zlabel('z','Interpreter','Latex')
     % plot(t,X(:,7)) % Posicao do pendulo
     %plot1(cacm);
     PlotAngles(t,X) % Plot dos ângulos
     PlotXYZ(t,X) % Plot do XYZ
end

%% SetGlobals: function description
function SetGlobals()
    % Aqui são definidas as variáveis globais do sistema
    global divisoes x1ini x1fim x1divs x2ini x2fim x2divs x1delta x2delta numCores CodigoCores;
    numCores = 85;
    CodigoCores = zeros(numCores,3); % cores RGB
    for n=1:numCores
        CodigoCores(n,1) = 255 - 255*3*((n-1)/255); 
        CodigoCores(n,2) = 255 - 255*3*((n-1)/255); 
        CodigoCores(n,3) = 255 - 255*3*((n-1)/255); 
    end
    divisoes=60;
    x1ini=0; x1fim=1; x1divs=divisoes;
    x2ini=-4; x2fim=4;  x2divs=divisoes;
    x1delta=(x1fim-x1ini)/(x1divs);
    x2delta=(x2fim-x2ini)/(x2divs);
    %{    
    fprintf('\n\nValores do estado x1:\n');
    for n=1:divisoes
        fprintf('[%g] = %g a %g\n',n,x1ini+(n-1)*x1delta,x1ini+n*x1delta);
    end
    fprintf('\nValores do estado x2:\n');
    for n=1:divisoes
        fprintf('[%g] = %g a %g\n',n,x2ini+(n-1)*x2delta,x2ini+n*x2delta);
    end
    %}
end


%% InterpolaRGB: function description
function [c] = InterpolaRGB(ci,cf,intr)
    c = zeros(3,1);
    c(1) = (((cf(1)-ci(1))*intr(1,1)/255) + ci(1))/255;
    c(2) = (((cf(2)-ci(2))*intr(1,2)/255) + ci(2))/255;
    c(3) = (((cf(3)-ci(3))*intr(1,3)/255) + ci(3))/255;
end

%% Plot1: function description
%! @brief      Does the plotting of the space state in the shape
%!          of colored squares.
%! @param      cacm     The space state matrix
function plot1(cacm)
    global CodigoCores divisoes x1ini x1delta x2ini x2delta numCores;
    figure(1); hold on;
    for i=1:divisoes
        for j=1:divisoes
            coordx=x1ini+(i-1)*x1delta;
            coordy=x2ini+(j-1)*x2delta;
            val=cacm(i,j)+1;
            c = zeros(1,3);
            if val >= numCores
                val = numCores;
            end
            c = InterpolaRGB([100 0 0],[239 255 203],CodigoCores(val,:));
            % fprintf('i=%g  j=%g  cacmij=%g\n',i,j,val);
            % fprintf('x=%g  y=%g  [%g %g %g]\n\n',coordx,coordy,c(1),c(2),c(3));
            plot(coordx,coordy,'s',...
                'Markersize',16,...
                'MarkerEdgeColor',[0.96 0.96 0.96],...
                'MarkerFaceColor',[c(1) c(2) c(3)]);
            %drawnow;
        end
    end
    hold off;
    xlabel('x_1'); ylabel('x_2'); 
    title('Evolu\c{c}\~{a}o dos Estados','Interpreter','Latex');
end

%% MotorDC: function description
%! @brief      Describes the space state equations
%! @param      t     time vector
%! @param      x     inital conditions
%! @return     an array with dx
function dx = Quadricopter(t,x)
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
    
    % Ctes
    g = - 9.81;       % Gravidade
    Ix = 5e-3;      % Inércia eixo X
    Iy = 5e-3;      % Inércia eixo Y
    Iz = 10e-3;     % Inércia eixo Z
    L = 0.25;       % Distância do centro até qualquer um dos motores
    d = 3e-6;       % Cte aerodinâmica (thrust)
    b = 1e-7;       % Cte de arrasto (drag)
    m = 0.5;        % Massa do drone
    Jr = 6e-5;      % Inércia do rotor

    % W é a vel angular em cada motor
    W = [6000 5000 6000 7000];
    % W = [0 0 0 0];

    % Matriz U das entradas
    % U(1) = b*(W(1)^2 + W(2)^2 + W(3)^2 + W(4)^2);   % Total Thrust
    % U(2) = b*(W(4)^2 - W(2)^2);                     % Roll
    % U(3) = b*(- W(3)^2 + W(1)^2);                   % Pitch
    % U(4) = d*(W(1)^2 - W(2)^2 + W(3)^2 - W(4)^2);   % Yaw
    U = [5 0 2 0];
                                                
    % Redução de variáveis
    a(1) = (Iy - Iz)/Ix;
    a(2) = Jr/Ix;
    a(3) = (Iz - Ix)/Iy;
    a(4) = Jr/Iy;
    a(5) = (Ix - Iy)/Iz;
    b(1) = L/Ix;
    b(2) = L/Iy;
    b(3) = L/Iz;
    
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


%% AchaCelula: function description
%! @brief      Calculates the i-th, j-th partition of the state space the
%              states x1 and x2 belongs to.
%! @param      x1,x2    states x1 and x2
%! @return     i, j     partition i,j of the state space
function [i,j] = AchaCelula(x1,x2)
    global divisoes x1ini x1fim x1divs x2ini x2fim x2divs x1delta x2delta;

    % Aqui é o único cálculo a ser feito:
    i=(x1-x1ini)/x1delta; i=floor(i+1);
    j=(x2-x2ini)/x2delta; j=floor(j+1);
    % somar 1 e arredondar para baixo
end

%% Plot: functions descriptions
%! @brief      Plot the values on graphs
%!
%! @param      t     time vector
%! @param      X     the x1 and x2 data
%!
%! @return     graphs
%!
function PlotXYZ(t,X)
    figure()
    subplot(2,2,1)
    plot(t,X(:,9)) % Posição em X
    title('Posi\c{c}\~{a}o em X','Interpreter','Latex')
    ylabel('X','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,2,2)
    plot(t,X(:,11)) % Posição em Y
    title('Posi\c{c}\~{a}o em Y','Interpreter','Latex')
    ylabel('Y','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,1,2)
    plot(t,X(:,7)) % Posição em Z
    title('Posi\c{c}\~{a}o em Z','Interpreter','Latex')
    ylabel('Z','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    suptitle('Movimento em XYZ')
end

function PlotAngles(t,X)
    figure()
    subplot(2,2,1)
    plot(t,X(:,1)) % Angulo phi
    title('\^Angulo $\phi$','Interpreter','Latex')
    ylabel('$\phi$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,2,2)
    plot(t,X(:,3)) % Posição em theta
    title('\^Angulo $\theta$','Interpreter','Latex')
    ylabel('$\theta$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,1,2)
    plot(t,X(:,5)) % Posição em psi
    title('\^Angulo $\psi$','Interpreter','Latex')
    ylabel('$\psi$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    suptitle('Variação dos ângulos')
end