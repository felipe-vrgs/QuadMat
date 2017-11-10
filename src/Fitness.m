%% Fitness: function description
function fit = Fitness(target, gains, setpoint)
	global err_int;
	switch target
		case 'z'
			[t,X] = QuadMat(gains,target,setpoint,0);
			errMax = 0;
			err = zeros(size(t));
			for n = 1:size(t)
				err(n) = (real(X(n,7)) - setpoint)^2;
				errMax = errMax + err(n);
			end
			if errMax == 0
				fit = 10000000;
			else
				fit = (1/errMax)*2000*20;
			end
		case 'phi'
			[t,X] = QuadMat(gains,target,setpoint,0);
			errMax = 0;
			err = zeros(size(t));
			for n = 1:size(t)
				err(n) = (real(X(n,1)) - setpoint)^2;
				errMax = errMax + err(n);
			end
			if errMax == 0
				fit = 10000000;
			else
				fit = (1/errMax)*20;
			end
		case 'theta'	
			[t,X] = QuadMat(gains,target,setpoint,0);
			errMax = 0;
			err = zeros(size(t));
			for n = 1:size(t)
				err(n) = (real(X(n,3)) - setpoint)^2;
				errMax = errMax + err(n);
			end
			if errMax == 0
				fit = 10000000;
			else
				fit = (1/errMax)*20;
			end
		case 'psi'	
			[t,X] = QuadMat(gains,target,setpoint,0);
			errMax = 0;
			err = zeros(size(t));
			for n = 1:size(t)
				err(n) = (real(X(n,5)) - setpoint)^2;
				errMax = errMax + err(n);
			end
			if errMax == 0
				fit = 10000000;
			else
				fit = (1/errMax)*20;
			end
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