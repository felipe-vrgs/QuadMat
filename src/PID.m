% PID: function description
%
% @param      Gains     The gains
% @param      Input     The input
% @param      SetPoint  The set point
%
% @return     { description_of_the_return_value }
%
function [U] = PID(Gains, inp, SetPoint, Ref)
	global err_ant err_int windup;

	% To not mess up the errors
	if strcmp(Ref,'U1')
		idx = 1;
	elseif strcmp(Ref,'U2')
		idx = 2;
	elseif strcmp(Ref,'U2')
		idx = 3;
	elseif strcmp(Ref,'U2')
		idx = 4;
	end

	% PID Gains
	Kp = Gains(1);
	Ki = Gains(2);
	Kd = Gains(3);

	% Error
	err = SetPoint - inp;

	% Int
    err_int(idx) = err_int(idx) + (err);
 
    % Windup (saturation)
    if (err_int(idx) < -(windup(idx)))
         err_int(idx) = -(windup(idx));
    elseif (err_int(idx) > windup(idx))
         err_int(idx) = windup(idx);
    end
 
    % Diff
    drv = err - err_ant(idx);
 
    % Scaling
    P = (Kp*err);
    I = (Ki*err_int(idx));
    D = (Kd*drv);
 
	% Att the errors
	err_ant(idx) = err;

    % Return U
    U = P + I + D;
end
