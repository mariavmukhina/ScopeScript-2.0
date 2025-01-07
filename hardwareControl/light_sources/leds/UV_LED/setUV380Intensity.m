function [] = setUV380Intensity(intensity)
    global mmc;
    
    % Set the UV340 channel intensity
    % Intensity should be a string and within the valid range (e.g., '0' to '1000')
    mmc.setProperty('UV LED', 'UV380_Intensity', num2str(intensity));
end
