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

start(motorB);
% color sensor
colorsensor = colorSensor(myev3);
i = 0;
lastTurnDir = 'left';
while true
    i = i + 1;
    disp(i);
    motorA.Speed = -30;
    motorC.Speed = -30;
  
    color = colorsensor.readColor();
    disp(color);

    if strcmp(color, 'red')
        pause(0.5);
        disp('go straight...');
        continue
    else
        notFoundFlag = false;
        countDegree = 0;
        if strcmp(lastTurnDir, 'left')
            while ~strcmp(colorsensor.readColor(), 'red')
                disp('left turn...');
                Turn('left', 20, motorA, motorC)
                countDegree = countDegree + 20;
                if countDegree >= 160
                    notFoundFlag = true;
                    break;
                end
            end
            lastTurnDir = 'left';

            if notFoundFlag == true
                while ~strcmp(colorsensor.readColor(), 'red')
                    disp('right turn...');
                    Turn('right', 20, motorA, motorC)
                end
                lastTurnDir = 'right';
            end
        else
            while ~strcmp(colorsensor.readColor(), 'red')
                disp('right turn...');
                Turn('right', 20, motorA, motorC)
                countDegree = countDegree + 20;
                if countDegree >= 160
                    notFoundFlag = true;
                    break;
                end
            end
            lastTurnDir = 'right';
            if notFoundFlag == true
                while ~strcmp(colorsensor.readColor(), 'red')
                    disp('left turn...');
                    Turn('left', 20, motorA, motorC)
                end
                lastTurnDir = 'left';
            end
        end
 
    end
    
end