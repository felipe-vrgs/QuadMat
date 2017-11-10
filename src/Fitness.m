% Fitness: function description
%
% @param      target    Quem será controlado
% @param      gains     Os ganhos do PID
% @param      setpoint  O SetPoint
%
% @return     O fitness
%
function fit = Fitness(target, gains, setpoint)
	global err_int;
	%{ 
	 Apesar do código estar pronto para um fitness diferente por malha foi utilizada a mesma equação, ou seja, apenas a soma do erro é levada em conta no fitness
	 No caso do Z o fitness é multiplicado por 2000*20 para que a sua escala fique mais agradável, tendo em vista que o seu erro seria alto 
	 por ser uma malha lenta que possui valores grandes, o que é diferente para os ângulos, tendo em vista que apresentam uma variação média entre -0.32 e 0.32.
	%} 
	vista
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