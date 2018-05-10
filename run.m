clc; clear all;
myev3 = legoev3('USB')
%% A right wheel
%  C left wheel
%  B arms
motorA = motor(myev3,'A');
motorB = motor(myev3,'B');
motorC = motor(myev3,'C');

%% run
resetRotation(motorA);
resetRotation(motorC);
start(motorA);
start(motorC);
Turn('right',180, motorA, motorC);

stop(motorA)
stop(motorC)

rotation = readRotation(motorA)

%% arms
% resetRotation(motorB);
% start(motorB);
% motorB.Speed = 1;
% for time=1:100
%     pause(0.1);
% end
% stop(motorB)

%% infra-red sensor
% irsensor = irSensor(myev3)
% proximity = readProximity(irsensor)

%% sonic sensor
sonicsensor = sonicSensor(myev3);
distance = readDistance(sonicsensor)

%% color sensor
colorsensor = colorSensor(myev3);
color = readColor(colorsensor)
% intensity = readLightIntensity(colorsensor)