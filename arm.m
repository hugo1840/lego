clc; clear all;
% myev3 = legoev3('USB');
myev3=legoev3('wifi','172.20.10.3','0016535ce002');

motorB = motor(myev3,'B');

start(motorB);


while true
    motorB.Speed = -5;
    pause(1);
    motorB.Speed = 5;
    pause(1);
end