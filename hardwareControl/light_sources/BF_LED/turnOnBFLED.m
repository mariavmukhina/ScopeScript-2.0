function [] = turnOnBFLED(energy)
    % turnONBFLED: switches the PEKA LED's power state to 1 ("ON") and
    % adjusts the intensity

    
    global ti2;

    % Set LED power state
    ti2.DiaLampSwitch.Value = 1;

    if energy < 1 || energy > 2090
        error('Invalid intensity. Must be between 1 and 2090.');
    else
        ti2.DiaLampPos.Value = energy;
    end

end
