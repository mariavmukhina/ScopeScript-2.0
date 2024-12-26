function [] = turnOffAllUVLEDs()
    global mmc;
    
    % Turn off the UV LED device
    mmc.setProperty('UV LED', 'State', '0'); % Turn the device OFF
end
