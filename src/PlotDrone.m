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

%% Rad2RPM: function description
function [Deg] = Rad2Deg(rad)
    Deg = rad*57.2958;
end

%% getOS: function description
function [os] = getOS(vals, setpoint)
   % Verifica o % de OS
    if vals(1) > setpoint
        os = min(vals);
    elseif vals(1) == setpoint
        os = 0;
    else
        os = max(vals);
    end
    os = (abs(os)/abs(vals(1)))*100
end

%% getSetTime: function description
function [setTime] = getSetTime(x, t, setpoint)
    setTime = 0;
    if Rad2Deg(x(1)) > setpoint
        cmp = 1.02*setpoint;
    elseif Rad2Deg(x(1)) == setpoint
        cmp = 0;
    else
        cmp = 0.98*setpoint;
    end
    if setpoint == 0
        if Rad2Deg(x(1)) > setpoint
            cmp = 0.02*Rad2Deg(x(1));
        elseif Rad2Deg(x(1)) < setpoint
            cmp = -0.02*Rad2Deg(x(1));
        end
    end
    for I = 1:size(t)
        if Rad2Deg(x(1)) > setpoint
            if (Rad2Deg(x(I)) <= cmp)
                setTime = t(I);
                break
            end
        elseif (x(1)) < setpoint
            if (Rad2Deg(x(I)) >= cmp)
                setTime = t(I);
                break
            end
        end
    end
    setTime
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
    % subplot(2,2,1)
    % plot(t,Rad2Deg(X(:,1))) % Angulo phi
    % title('\^Angulo $\phi$','Interpreter','Latex')
    % ylabel('Graus','Interpreter','Latex')
    % xlabel('Tempo (s)','Interpreter','Latex')
    % grid on
    % getSetTime(X(:,1),t,0);
    % getOS(X(:,1),0);
    % Rad2Deg(X(350,1))
    % subplot(2,2,2)
    % plot(t,Rad2Deg(X(:,3))) % Posição em theta
    % title('\^Angulo $\theta$','Interpreter','Latex')
    % ylabel('Graus','Interpreter','Latex')
    % xlabel('Tempo (s)','Interpreter','Latex')
    % grid on
    % getSetTime(X(:,3),t,0);
    % getOS(X(:,3),0);
    % Rad2Deg(X(350,3))
    % subplot(2,1,2)
    plot(t,Rad2Deg(X(:,5))) % Posição em psi
    title('\^Angulo $\psi$','Interpreter','Latex')
    ylabel('Graus','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    getSetTime(X(:,5),t,0);
    getOS(X(:,5),0);
    % Rad2Deg(X(350,5))
    % suptitle('Movimento Angular')
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

