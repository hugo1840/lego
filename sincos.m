%% Go Straight Close-Loop Template %%

% Copyright SHI Libin
% control a LEGO robot 

%% Set up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
myev3=legoev3('USB');
% myev3=legoev3('wifi','172.20.10.3','0016535ce002');
motorA = motor(myev3,'A');
motorB = motor(myev3,'C');

% Application parameters
EXE_TIME = 15;                              % Application running time in seconds
POSITION_CMD=zeros(2,1500);  %degree
POSITION_OUT = zeros(2, 1500);
TIME_STEP = zeros(1, 1500);
KP =0.1;                                     % PID controller parameter
KI =0.5;
KD =0;
resetRotation(motorA);
resetRotation(motorB);
start(motorA);
start(motorB);

timeclock = timer('TimerFcn', 'stat=false;', 'StartDelay',EXE_TIME);
start(timeclock);

%% Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stat = true;
% A
posA_k1=0;
posA_k2=0;
posA_k=0;
uA_k1 = 0;
% B
posB_k1=0;
posB_k2=0;
posB_k=0;
uB_k1 = 0;
t0=clock;
i=3;
while stat == true                          % Quit when times up
    t1=clock;
    t=etime(t1,t0);
    TIME_STEP(i) = t;
    POSITION_CMD(1, i)=360*sin(0.4*pi*t);   % sins wave source
    POSITION_CMD(2, i)=360*sin(0.4*pi*t);
%     POSITION_CMD(i) = 360;
 

    

    % A
    posA_k = readRotation(motorA);          % read position    
    POSITION_OUT(1, i) = posA_k;
    eA_k=POSITION_CMD(1, i)-posA_k;                %error 
    eA_k1=POSITION_CMD(1, i-1)-posA_k1;
    eA_k2=POSITION_CMD(1, i-2)-posA_k2;

    delta_uA=int8(KP*(eA_k-eA_k1)+KI*eA_k+KD*(eA_k-2*eA_k1+eA_k2)); %PID calculate
    uA_k=uA_k1+delta_uA;
    
    motorA.Speed=uA_k+delta_uA;               %control value

    posA_k2= posA_k1;
    posA_k1 = posA_k;


    % B
    posB_k = readRotation(motorB);          % read position    
    POSITION_OUT(2, i) = posB_k;
    eB_k=POSITION_CMD(2, i)-posB_k;                %error 
    eB_k1=POSITION_CMD(2, i-1)-posB_k1;
    eB_k2=POSITION_CMD(2, i-2)-posB_k2;

    delta_uB=int8(KP*(eB_k-eB_k1)+KI*eB_k+KD*(eB_k-2*eB_k1+eB_k2)); %PID calculate
    uB_k=uB_k1+delta_uB;
    
    motorB.Speed=uB_k+delta_uB;               %control value

    posB_k2= posB_k1;
    posB_k1 = posB_k;
   i=i+1;
 %  pause(0.05)
  end

%% Clean up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stop(motorA);                             % Stop motor 
stop(motorB);

%% plot
subplot(2, 1, 1);
plot(TIME_STEP, POSITION_CMD(1, :), 'r.', TIME_STEP, POSITION_OUT(1, :), 'b.');
subplot(2, 1, 2);
plot(TIME_STEP, POSITION_CMD(2, :), 'r.', TIME_STEP, POSITION_OUT(2, :), 'b.');