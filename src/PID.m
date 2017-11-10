% PID: function description
%
% @param      Gains     The gains
% @param      Input     The input
% @param      SetPoint  The set point
%
% @return     { description_of_the_return_value }
%
function [U] = PID(Gains, x, SetPoint, Ref, t)
	global err_ant err_int windup t_ant err_dot;

	% To not mess up the errors
	if strcmp(Ref,'U1')
		idx = 1;
		trgt = x(7);
	elseif strcmp(Ref,'U2')
		idx = 2;
		trgt = x(1);
	elseif strcmp(Ref,'U3')
		idx = 3;
		trgt = x(3);
	elseif strcmp(Ref,'U4')
		idx = 4;
		trgt = x(5);
	end

	% PID Gains
	Kp = Gains(1);
	Ki = Gains(2);
	Kd = Gains(3);

	limitInt = 20;

	dt = t - t_ant(idx);

	% Error
	err = SetPoint - trgt;

	% Int err
    err_int(idx) = err_int(idx) + err*dt;

    if err_int(idx) > limitInt
    	err_int(idx) = limitInt;
    elseif err_int(idx) < -limitInt
    	err_int(idx) = - limitInt;
    end
 
    % Dot err
    if dt ~= 0
	    if err_dot(idx) == 0
			err_dot(idx) = (err - err_ant(idx))/dt;
	    else
	    	err_dot(idx) = (err_dot(idx) + (err - err_ant(idx))/dt)/2;
	    end
	else
		err_dot(idx) = 0;
	end
    	
    % Scaling
    P = Kp*err;
    I = Ki*err_int(idx);
    D = Kd*err_dot(idx);
 
	% Att the errors
	err_ant(idx) = err;

    % Return U
    U = Err2U((P+I+D), x, Ref);
    	
    if U > windup(idx)
    	U = windup(idx);
    elseif U < -windup(idx)
    	U = - windup(idx);
    end
 	t_ant = t;
end


%% Err2U: function description
function [U] = Err2U(val, x, Ref)
    global g L Kf Km m a b;
	if strcmp(Ref,'U1')
		U = (val+g)*m/(cos(x(1))*cos(x(3)));
	elseif strcmp(Ref,'U2')
		% U = (val+g)*m/(cos(x(1))*cos(x(3)));
	elseif strcmp(Ref,'U3')
		% U = (val+g)*m/(cos(x(1))*cos(x(3)));
	elseif strcmp(Ref,'U4')
		% U = (val+g)*m/(cos(x(1))*cos(x(3)));
	end
end

