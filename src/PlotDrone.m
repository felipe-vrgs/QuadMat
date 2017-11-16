% PlotDrone: Funão que realiza a plotagem dos gráficos.
%
% @param      t     Tempo
% @param      X     X
% @param      ty    Tipo do gráfico
%
% @return     graphs !
%
function PlotDrone(t,X,ty)
    % Verifica qual é o tipo e redireciona para a função correta
    % Não vou entrar muito em detalhes nesse arquivo tendo em vista que as funções são bem simples
    if strcmp(ty,'XYZ')
        PlotXYZ(t,X)
    elseif strcmp(ty,'XYZAng')
        PlotXYZAng(t,X)
    elseif strcmp(ty,'Ang')
        PlotAngles(t,X)
    elseif strcmp(ty,'VelXYZ')
        PlotXYZVel(t,X)
    elseif strcmp(ty,'VelAng')
        PlotAngVel(t,X)
    elseif strcmp(ty,'U')
        PlotU()
    elseif strcmp(ty,'W')
        PlotW()
    end
end

%% PlotU: function description
function PlotU()
   global U_hist T_hist;
    figure()
    subplot(2,2,1)
    plot(T_hist(:,1), U_hist(:,1))
    title('Empuxo Vertical','Interpreter','Latex')
    ylabel('U1','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    subplot(2,2,2)
    plot(T_hist(:,1), U_hist(:,2))
    title('Rolagem','Interpreter','Latex')
    ylabel('U2','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    subplot(2,2,3)
    plot(T_hist(:,1), U_hist(:,3))
    title('Arfagem','Interpreter','Latex')
    ylabel('U3','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    subplot(2,2,4)
    plot(T_hist(:,1), U_hist(:,4))
    title('Guinada','Interpreter','Latex')
    ylabel('U4','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
end

%% PlotU: function description
function PlotW()
   global W_hist T_hist;
    figure()
    subplot(2,2,1)
    plot(T_hist(:,1), Rad2RPM(W_hist(:,1)))
    title('Vel. Ang. Motor 1','Interpreter','Latex')
    ylabel('W1 (rpm)','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    subplot(2,2,2)
    plot(T_hist(:,1), Rad2RPM(W_hist(:,2)))
    title('Vel. Ang. Motor 2','Interpreter','Latex')
    ylabel('W2 (rpm)','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    subplot(2,2,3)
    plot(T_hist(:,1), Rad2RPM(W_hist(:,3)))
    title('Vel. Ang. Motor 3','Interpreter','Latex')
    ylabel('W3 (rpm)','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    subplot(2,2,4)
    plot(T_hist(:,1), Rad2RPM(W_hist(:,4)))
    title('Vel. Ang. Motor 4','Interpreter','Latex')
    ylabel('W4 (rpm)','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    suptitle('Velocidade Angular dos motores (rpm)')
end

%% Rad2RPM: function description
function [RPM] = Rad2RPM(rad)
    RPM = rad*9.54929658551;
end

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

function PlotXYZVel(t,X)
    figure()
    subplot(2,2,1)
    plot(t,X(:,10)) % Velocidade em X
    title('Velocidade em X','Interpreter','Latex')
    ylabel('$\dot{X}$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,2,2)
    plot(t,X(:,12)) % Velocidade em Y
    title('Velocidade em Y','Interpreter','Latex')
    ylabel('$\dot{Y}$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,1,2)
    plot(t,X(:,8)) % Velocidade em Z
    title('Velocidade em Z','Interpreter','Latex')
    ylabel('$\dot{Z}$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    suptitle('Velocidade em XYZ')
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
    suptitle('Movimento Angular')
end

function PlotXYZAng(t,X)
    figure()
    hold on
    subplot(3,2,1)
    plot(t,X(:,9)) % Posição em X
    % title('Posi\c{c}\~{a}o em X','Interpreter','Latex')
    ylabel('X','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(3,2,2)
    plot(t,X(:,1)) % Angulo phi
    % title('\^Angulo $\phi$','Interpreter','Latex')
    ylabel('$\phi$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(3,2,3)
    plot(t,X(:,11)) % Posição em Y
    % title('Posi\c{c}\~{a}o em Y','Interpreter','Latex')
    ylabel('Y','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(3,2,5)
    plot(t,X(:,7)) % Posição em Z
    % title('Posi\c{c}\~{a}o em Z','Interpreter','Latex')
    ylabel('Z','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(3,2,4)
    plot(t,X(:,3)) % Posição em theta
    % title('\^Angulo $\theta$','Interpreter','Latex')
    ylabel('$\theta$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(3,2,6)
    plot(t,X(:,5)) % Posição em psi
    % title('\^Angulo $\psi$','Interpreter','Latex')
    ylabel('$\psi$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    suptitle('Variacao das Posicoes Angulares e Lineares')
end

function PlotAngVel(t,X)
    figure()
    subplot(2,2,1)
    plot(t,X(:,2)) % Velocidade phi
    title('Velocidade $\dot\phi$','Interpreter','Latex')
    ylabel('$\dot\phi$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,2,2)
    plot(t,X(:,4)) % Posição em theta
    title('Velocidade $\dot\theta$','Interpreter','Latex')
    ylabel('$\dot\theta$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,1,2)
    plot(t,X(:,6)) % Posição em psi
    title('Velocidade $\dot\psi$','Interpreter','Latex')
    ylabel('$\dot\psi$','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    suptitle('Velocidade Angular')
end

