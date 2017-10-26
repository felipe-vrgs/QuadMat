
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