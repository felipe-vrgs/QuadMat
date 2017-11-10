%% Fitness: function description
function fit = Fitness(target, gains, setpoint)
	global err_int;
	switch target
		case 'z'
			[t,X] = QuadMat(gains,target,setpoint);
			errMax = 0;
			err = zeros(size(t));
			for n = 1:size(t)
				err(n) = (real(X(n,7)) - setpoint)^2;
				errMax = errMax + err(n);
			end
			if errMax == 0
				fit = 10000000;
			else
				fit = (1/errMax)*2000;
			end
			% PlotVars(t,X(:,7),err);
	end
end

function PlotVars(t,act,Err)
    figure()
    subplot(2,1,1)
    plot(t,act) % Posição em X
    title('Posi\c{c}\~{a}o em Z','Interpreter','Latex')
    ylabel('Z','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    subplot(2,1,2)
    plot(t,Err) % Posição em Y
    title('Varia\c{c}\~{a}o do erro','Interpreter','Latex')
    ylabel('E','Interpreter','Latex')
    xlabel('Tempo (s)','Interpreter','Latex')
    grid on
    suptitle('Função custo')
end