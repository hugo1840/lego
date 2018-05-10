function Turn( direction, degree, motorL, motorR)
%turn
    if strcmp(direction,'left')
        forMotor = motorR;
        backMotor = motorL;
    else if strcmp(direction,'right')
        forMotor = motorL;
        backMotor = motorR;
        end
    end

    stop(forMotor);
    stop(backMotor);
    
    % Application parameters
    L = 0.16; D = 0.042; 
    % convert from xiaoche degree to wheel degree
    Rotation_Input = L / D * degree;
%     turn_speed = 100;
    % calculate the exe time
    EXE_TIME = 1;                            % Application running time in seconds
    NUM_SAMPLE = int32(EXE_TIME * 100);
    POSITION_CMD=zeros(2,NUM_SAMPLE);  %degree
    POSITION_OUT = zeros(2, NUM_SAMPLE);
    TIME_STEP = zeros(1, NUM_SAMPLE);
    KP = 0.1;                                     % PID controller parameter
    KI = 0.32;
    KD = 0;
    resetRotation(forMotor);
    resetRotation(backMotor);
    start(forMotor);
    start(backMotor);
    
    if exist('flag', 'dir')
        rmdir('flag');
    end
    timeclock = timer('TimerFcn', 'stat=false; mkdir(''flag'')', 'StartDelay',EXE_TIME);
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
        if exist('flag', 'dir')
            break;
        end
%         fprintf('i = %d, NUM_SAMPLE = %d\n',i, NUM_SAMPLE);
        t1=clock;
        t=etime(t1,t0);
        TIME_STEP(i) = t;
        POSITION_CMD(1, i)= Rotation_Input;
        POSITION_CMD(2, i)= -Rotation_Input;

        % A
        posA_k = readRotation(forMotor);          % read position    
        POSITION_OUT(1, i) = posA_k;
        eA_k=POSITION_CMD(1, i)-posA_k;                %error 
        eA_k1=POSITION_CMD(1, i-1)-posA_k1;
        eA_k2=POSITION_CMD(1, i-2)-posA_k2;

        delta_uA=int8(KP*(eA_k-eA_k1)+KI*eA_k+KD*(eA_k-2*eA_k1+eA_k2)); %PID calculate
        uA_k=uA_k1+delta_uA;

        forMotor.Speed=uA_k+delta_uA;               %control value

        posA_k2= posA_k1;
        posA_k1 = posA_k;


        % B
        posB_k = readRotation(backMotor);          % read position    
        POSITION_OUT(2, i) = posB_k;
        eB_k=POSITION_CMD(2, i)-posB_k;                %error 
        eB_k1=POSITION_CMD(2, i-1)-posB_k1;
        eB_k2=POSITION_CMD(2, i-2)-posB_k2;

        delta_uB=int8(KP*(eB_k-eB_k1)+KI*eB_k+KD*(eB_k-2*eB_k1+eB_k2)); %PID calculate
        uB_k=uB_k1+delta_uB;

        backMotor.Speed=uB_k+delta_uB;               %control value

        posB_k2= posB_k1;
        posB_k1 = posB_k;
        i=i+1;
     %  pause(0.05)
    end
    if exist('flag', 'dir')
        rmdir('flag');
    end
    %% Clean up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    stop(forMotor);                             % Stop motor 
    stop(backMotor);
    start(forMotor);                             % start motor 
    start(backMotor);
    
%     disp('end')
    %% plot
%     subplot(2, 1, 1);
%     plot(TIME_STEP, POSITION_CMD(1, :), 'r.', TIME_STEP, POSITION_OUT(1, :), 'b.');
%     subplot(2, 1, 2);
%     plot(TIME_STEP, POSITION_CMD(2, :), 'r.', TIME_STEP, POSITION_OUT(2, :), 'b.');
end

