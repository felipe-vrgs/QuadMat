%% Plot: functions descriptions
%! @brief      Plot the values on graphs
%!
%! @param      t     time vector
%! @param      X     the x1 and x2 data
%!
%! @return     graphs
%!
function PlotDrone(t,X,ty)
    if strcmp(ty,'XYZ')
        PlotXYZAng(t,X)
    elseif strcmp(ty,'Ang')
        PlotAngles(t,X)
    elseif strcmp(ty,'VelXYZ')
        PlotXYZVel(t,X)
    elseif strcmp(ty,'VelAng')
        PlotAngVel(t,X)
    end
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

