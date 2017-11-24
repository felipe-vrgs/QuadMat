% CACM: function description
%
% @param      target    Quem será controlado
% @param      gains     Os ganhos do PID
% @param      setpoint  O SetPoint
%
% @return     O CACM
%
function CACM()
    % CACM
    global divisoes numSim z_val zdot_val x1ini x1fim x1divs x2ini x2fim x2divs x1delta x2delta numCores CodigoCores cacm U_MAP;
    numCores = 255;
    CodigoCores = zeros(numCores,3); % cores RGB
    for n=1:numCores
        CodigoCores(n,1) = 255 - 255*((n-1)/255); 
        CodigoCores(n,2) = 255 - 255*((n-1)/255);
        CodigoCores(n,3) = 255 - 255*((n-1)/255); 
    end
    divisoes=100;
    x1ini=-0; x1fim=4; x1divs=divisoes;
    x2ini=-4; x2fim=4;  x2divs=divisoes;
    x1delta=(x1fim-x1ini)/(x1divs);
    x2delta=(x2fim-x2ini)/(x2divs);
    numSim = 50;
    cacm = zeros(divisoes,divisoes);
    U_MAP = zeros(divisoes,divisoes);
    % figure(1); hold on;
    for num=1:numSim+1
        z_val = (num - 1)/((numSim)/4);
        for num2=1:numSim+1
            zdot_val = -4 + 2*(num2 - 1)/((numSim)/4);
            if (z_val == 2 && zdot_val == 0)
            else
                [t,X] = QuadMat([],'',0,0);
            end
            % plot(t(1:500),X(1:500,7))
        end
    end
    % hold off;
    assignin('base', 'cacm', cacm);
    assignin('base', 'U_MAP', U_MAP);
    plot1(cacm, U_MAP);
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
function plot1(cacm, U_MAP)
    global CodigoCores divisoes x1ini x1delta x2ini x2delta numCores;
    figure(); hold on;
    for j=1:divisoes
        for i=1:divisoes
            coordx=x1ini+(i-1)*x1delta;
            coordy=x2ini+(j-1)*x2delta;
            val=cacm(i,j)+1;
            c = zeros(1,3);
            if val >= numCores
                val = numCores;
            end
            c = InterpolaRGB([0 0 0],[255 255 255],CodigoCores(val,:));
            % [100 0 0],[239 255 203]
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
    ylabel('$\dot{Z}$','Interpreter','Latex')
    xlabel('Z','Interpreter','Latex')
    title('Evolu\c{c}\~{a}o dos Estados','Interpreter','Latex');

    figure()
    mesh(U_MAP)
    ylabel('$\dot{Z}$','Interpreter','Latex')
    xlabel('$Z$','Interpreter','Latex')
    zlabel('$U_{1}$','Interpreter','Latex')
    % figure()
    % pcolor(cacm)
    % ylabel('$\dot{Z}$','Interpreter','Latex')
    % xlabel('Z','Interpreter','Latex')
end

%% AchaCelula: function description
%! @brief      Calculates the i-th, j-th partition of the state space the
%              states x1 and x2 belongs to.
%! @param      x1,x2    states x1 and x2
%! @return     i, j     partition i,j of the state space
function [i,j] = AchaCelula(x1,x2)
    global divisoes x1ini x1fim x1divs x2ini x2fim x2divs x1delta x2delta;
    % Aqui é o único cálculo a ser feito:
    i=(abs(x1)-x1ini)/x1delta; i=floor(i+1);
    if i > divisoes
        i=divisoes;
    elseif i < 1
        i = 1;
    end
    j=(x2-x2ini)/x2delta; j=floor(j+1);
    if j > divisoes
        j=divisoes;
    elseif j < 1
        j = 1;
    end
    % somar 1 e arredondar para baixo
end