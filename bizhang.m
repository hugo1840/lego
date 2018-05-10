clc; clear all;
% myev3 = legoev3('USB');
myev3=legoev3('wifi','172.20.10.8','0016535ce002');

%% 
% A right wheel
%  C left wheel
%  B arms
motorA = motor(myev3,'A');
motorB = motor(myev3,'B');
motorC = motor(myev3,'C');

start(motorA);
start(motorC);


% Turn('left', 90, motorA, motorC);

% % sensors
sonicsensor = sonicSensor(myev3);
i = 0
while(true)
    
    motorA.Speed = -50;
    motorC.Speed = -50;
    distance = readDistance(sonicsensor)
    if distance < 0.3
        randForTurn = {'right','left'};
        randDirect = int8(random('unif',0,1) > 0.5);
        Turn(randForTurn(randDirect + 1), 90, motorA, motorC);
%        Turn(randForTurn(randDirect + 1),30, motorC,motorA)
        i = i + 1
%         start(motorA);
%         start(motorC);
    end
    if i == 5
        break;
    end
end

stop(motorA)
stop(motorC)
