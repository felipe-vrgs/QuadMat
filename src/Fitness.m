% Fitness: function description
%
% @param      target    Quem será controlado
% @param      gains     Os ganhos do PID
% @param      setpoint  O SetPoint
%
% @return     O fitness
%
function fit = Fitness(target, gains, setpoint, p)
	 if nargin == 3
        p = 0;
    end
	global err_int;
	%{ 
	 Apesar do código estar pronto para um fitness diferente por malha foi utilizada a mesma equação, ou seja, apenas a soma do erro é levada em conta no fitness
	 No caso do Z o fitness é multiplicado por 2000*20 para que a sua escala fique mais agradável, tendo em vista que o seu erro seria alto 
	 por ser uma malha lenta que possui valores grandes, o que é diferente para os ângulos, tendo em vista que apresentam uma variação média entre -0.32 e 0.32.
	%} 
	[t,X] = QuadMat(gains,target,setpoint,p);
	errMax = 0;
	err = zeros(size(t));
	chkVar = zeros(size(t));
	Kfit = 30;
	KOS = 1;
	switch target
		case 'z'
			chkVar(:) = X(:,7);
			Kfit = 2000*2;
		case 'phi'
			chkVar(:) = X(:,1);
		case 'theta'	
			chkVar(:) = X(:,3);
		case 'psi'	
			chkVar(:) = X(:,5);
	end
	for n = 1:size(t)
		err(n) = t(n)*(real(chkVar(n)) - setpoint)^2;
		errMax = errMax + err(n);
	end
	% Verifica o % de OS
	if chkVar(1) > setpoint
		osValue = min(chkVar);
	elseif chkVar(1) == setpoint
		osValue = 0;
	else
		osValue = max(chkVar);
	end
	if p == 1
		if setpoint ~= 0
			((osValue - setpoint)/setpoint)*100;
		else 
			osValue*100;
		end
	end
	errMax = errMax + (abs(osValue - setpoint)^2)*KOS;
	if errMax == 0
		fit = 10000000;
	else
		fit = (1/errMax)*Kfit;
	end
end