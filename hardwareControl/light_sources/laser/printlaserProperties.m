function [] = printlaserProperties(laserNumber)
    % Check if the input is valid
    if ~ismember(laserNumber, [1, 2, 3])
        error('Invalid laser number. Please use 1, 2, or 3.');
    end

    global mmc;

    % Define property name templates with a placeholder for the laser number
    properties = {
        'Laser %d: 1. Enable', ...
        'Laser %d: 2. Emission', ...
        'Laser %d: 3. Level %%', ... % Escape the % symbol with %%
        'Laser %d: 4. Use TTL', ...
        'Laser %d: 5. Analog Mode'
    };

    % Print the laser number being queried
    fprintf('Current Properties for Laser %d:\n', laserNumber);

    % Loop through and print each property value
    for i = 1:length(properties)
        % Format the property name with the laser number
        propertyName = sprintf(properties{i}, laserNumber);
        % Get and print the property value
        value = mmc.getProperty('iChrome-MLE', propertyName);
        fprintf('%s: %s\n', propertyName, value);
    end
end
