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
    [t,X] = ode45(@Quadcopter,0:0.001:10,[0 0 0 0 0 0 0 0 0 0 0 0]);
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
    
    % Ctes do modelo
    global g L Kf Km m a b;
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