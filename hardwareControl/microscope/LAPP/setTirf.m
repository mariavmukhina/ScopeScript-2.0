function [] = setTirf(xPosition, yPosition)
%SETTIRF sets the X and Y position of the TIRF lens
% xPosition and yPosition should be within the range [-24320, 24320]
% Alternatively, use predefined configurations: 'TIRF', 'HILO', 'EPI'

global ti2;

% Predefined configurations
configs = struct( ...
    'TIRF', struct('X', 8601.0, 'Y', -1407.0), ...
    'HILO', struct('X', 8200.0, 'Y', -2600.0), ...
    'EPI', struct('X', -200.0, 'Y', -2600.0) ...
);

% Check if input is a string for predefined configuration
if ischar(xPosition) || isstring(xPosition)
    configName = upper(xPosition); % Convert to uppercase for consistency
    if isfield(configs, configName)
        xPosition = configs.(configName).X;
        yPosition = configs.(configName).Y;
    else
        error('Invalid configuration name. Use ''TIRF'', ''HILO'', or ''EPI''.');
    end
else
    % Validate input range
    if xPosition < -24320 || xPosition > 24320
        error('xPosition must be within the range [-24320, 24320]');
    end

    if yPosition < -24320 || yPosition > 24320
        error('yPosition must be within the range [-24320, 24320]');
    end
end

% Set the TIRF lens position
ti2.tirf1XPOSITION.Value = xPosition;
ti2.tirf1YPOSITION.Value = yPosition;

disp(['TIRF set to (', num2str(xPosition), ',', num2str(yPosition), ')']);
end 