function ArmMoveStart(motorArm)
    start(motorArm);
    while true
        motorArm.Speed = -5;
        pause(1);
        motorArm.Speed = 5;
        pause(1);
    end
end