function [] = turnOFFBFLED()
    % turnOFFBFLED: switches the PEKA LED's power state to 0 ("OFF") 

    
    global ti2;

    % Set LED power state
    ti2.DiaLampSwitch.Value = 0;

end
