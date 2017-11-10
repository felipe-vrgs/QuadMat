%% Main function, describes the global variables and does the simulation
%% QuadMat: function description
function [t,X] = QuadMat(gains,target,setpoint,plotGraphs)
    if nargin == 3
        plotGraphs = 1;
    end
    [t,X] = ExecMain(gains,target,setpoint);
    % comet3(X(:,11),X(:,9),X(:,7)); % Plot de X, Y, Z
    % comet3(X(:,1),X(:,3),X(:,5)); % Plot dos ângulos
    % grid on
    % plot1(cacm);
    if plotGraphs == 1
        PlotDrone(t,X,'XYZAng')
        PlotDrone([],[],'U')
    end
    % PlotDrone(t,X,'Ang')
end


function [t,X] = ExecMain(gains,target,setpoint)
    SetGlobals();
    global divisoes;
    %{
        A função ode45 aceita como primeiro parâmetro as derivadas do espaço
        de estados, como segundo o tempo de simulação e o terceiro é um array
        com as condições iniciais do sistema.
    %}
    Control = 'PID';
    Ins = InsertDisturb('theta','psi','phi');
    options = odeset('RelTol',1e-7,'AbsTol',1e-9,'Refine',1);
    [t,X] = ode23(@(t,y) Quadcopter(t,y,Control,gains,target,setpoint),0:0.01:10,Ins,options);
    % cacm = zeros(divisoes,divisoes);
    %{
    	for k=1:length(t)
            x1 = X(k,3)
            x2 = X(k,4)
            [i,j] = AchaCelula(x1,x2);
            cacm(i,j) = cacm(i,j) + 1;
        end
    %}
end

%% InsertDisturb: function description
function [in] = InsertDisturb(varargin)
    in = [0 0 0 0 0 0 0 0 0 0 0 0];
    for n = 1:nargin
        val = varargin(n);
        if strcmp(val,'phi')
            in(1) = -0.17453 + 2*rand(1,1)*0.17453; % -10 a 10º de disturbio
        elseif strcmp(val,'phidot')
            in(2) = -0.1 + 2*rand(1,1)*0.1;
        elseif strcmp(val,'theta')
            in(3) = -0.17453 + 2*rand(1,1)*0.17453; % -10 a 10º de disturbio
        elseif strcmp(val,'thetadot')
            in(4) = -0.1 + 2*rand(1,1)*0.1;
        elseif strcmp(val,'psi')
            in(5) = -0.17453 + 2*rand(1,1)*0.17453; % -10 a 10º de disturbio
        elseif strcmp(val,'psidot')
            in(6) = -0.1 + 2*rand(1,1)*0.1;
        elseif strcmp(val,'z')
            in(7) = -100 + 2*rand(1,1)*100;
        elseif strcmp(val,'zdot')
            in(8) = -0.5 + 2*rand(1,1)*0.5;
        elseif strcmp(val,'x')
            in(9) = -100 + 2*rand(1,1)*100;
        elseif strcmp(val,'xdot')
            in(10) = -0.5 + 2*rand(1,1)*0.5;
        elseif strcmp(val,'y')
            in(11) = -100 + 2*rand(1,1)*100;
        elseif strcmp(val,'ydot')
            in(12) = -0.5 + 2*rand(1,1)*0.5;
        end
    end
end

%% SetGlobals: function description
function SetGlobals()
    % Aqui são definidas as variáveis globais do sistema
    global divisoes x1ini x1fim x1divs x2ini x2fim x2divs x1delta x2delta numCores CodigoCores;
    numCores = 85;
    CodigoCores = zeros(numCores,3); % cores RGB
    for n=1:numCores
        CodigoCores(n,1) = 255 - 255*3*((n-1)/255); 
        CodigoCores(n,2) = 255 - 255*3*((n-1)/255); 
        CodigoCores(n,3) = 255 - 255*3*((n-1)/255); 
    end
    divisoes=60;
    x1ini=0; x1fim=1; x1divs=divisoes;
    x2ini=-4; x2fim=4;  x2divs=divisoes;
    x1delta=(x1fim-x1ini)/(x1divs);
    x2delta=(x2fim-x2ini)/(x2divs);
    %{    
    fprintf('\n\nValores do estado x1:\n');
    for n=1:divisoes
        fprintf('[%g] = %g a %g\n',n,x1ini+(n-1)*x1delta,x1ini+n*x1delta);
    end
    fprintf('\nValores do estado x2:\n');
    for n=1:divisoes
        fprintf('[%g] = %g a %g\n',n,x2ini+(n-1)*x2delta,x2ini+n*x2delta);
    end
    %}
    
    % Ctes do modelo
    global g L Kf Km m a b;
    g = 9.81;     % Gravidade
    Ix = 7.5e-3;      % Inércia eixo X
    Iy = 7.5e-3;      % Inércia eixo Y
    Iz = 1.3e-2;     % Inércia eixo Z
    L = 0.2;       % Distância do centro até qualquer um dos motores
    Km = 7.5e-7;      % Cte aerodinâmica (thrust)
    Kf = 3.13e-5;      % Cte de arrasto (drag)
    m = 0.5;        % Massa do drone
    Jr = 6e-5;      % Inércia do rotor
    
    % Redução de variáveis
    a(1) = (Iy - Iz)/Ix;
    a(2) = Jr/Ix;
    a(3) = (Iz - Ix)/Iy;
    a(4) = Jr/Iy;   
    a(5) = (Ix - Iy)/Iz;
    b(1) = L/Ix;
    b(2) = L/Iy;
    b(3) = L/Iz;

    % Ctes do controle
    global err_ant err_int windup t_ant err_dot U_ant;
    err_ant = zeros(4,1);
    windup = [15 1 1 1];
    err_int = zeros(4,1);
    err_dot = zeros(4,1);
    t_ant = zeros(4,1);
    U_ant = zeros(4,1);

    global U_hist T_hist;
    U_hist = [];
    T_hist = [];
end