function metaData = genMetaData(varargin)
%GENMETADATA gets the current state of the microscope to save as meta data
%for the tif files
% genMetaData() returns microscope paramts + current timestamp, fcScope is
% assumed to be the default one in scopeParams.m
% genMetaData(fcScope) returns current microscope params additional
% parameters specified in fcScope
% genMetaData(fcScope,zMeta) returns the current microscope params with
% additional protocol specified from fcScope.
% takes about 12ms to generate meta data
% 

% grab current timestamp
timestamp = char(datetime('now'));
if nargin == 0
    fcScope = scopeParams();
elseif nargin ==1
    fcScope = varargin{1};
elseif nargin ==2
    fcScope = varargin{1};
    zMeta = varargin{2};
    TTLtrigger = insertAStringBetweenCells(',',zMeta.TTLtrigger);
    % get illumination energies
    EpiLightslevels = char(printCurrentEpiLightSourceState(TTLtrigger));
    z0 = num2str(zMeta.zParams.z0);
    N  = num2str(zMeta.zParams.N);
    dz = num2str(zMeta.zParams.dz);
else
    error('incorrect number of arguments');
end

% (new) grab timepoint information
% Determine which imaging recipe was executed
if isempty(fcScope.executeOnly)
    timePointsStr = 'N/A'; % No imaging sequence used
else
    recipeIdx = fcScope.executeOnly(1); % Get the first selected recipe
    timePointsField = sprintf('timePoints%d', recipeIdx); % Generate field name dynamically

    % Check if the field exists in fcScope
    if isprop(fcScope, timePointsField)
        timePointsArray = get(fcScope, timePointsField); % Get the timePoints data

        % Check if the timePoints were originally in a colon notation format
        if length(timePointsArray) > 1 && all(diff(timePointsArray) == timePointsArray(2) - timePointsArray(1))
            % Reconstruct the original colon notation
            timePointsStr = sprintf('%d:%d:%d', timePointsArray(1), timePointsArray(2) - timePointsArray(1), timePointsArray(end));
        else
            % If irregular, fallback to comma-separated values
            timePointsStr = strjoin(string(timePointsArray), ', ');
        end
    else
        timePointsStr = 'Unknown'; % If the field is missing, default to Unknown
    end
end



global mmc;
global ti2;
% get current magnification
currMag = num2str(getEffectiveMag());
objName = char(getCurrentObjective());
% get current filter block
filter = char(getCurrentFilterCube());
% get current exposure
exposure = num2str(mmc.getExposure());
% get current stage position
stagePosX = num2str(ti2.iXPOSITION);
stagePosY = num2str(ti2.iYPOSITION);
% save camera parameters
if mmc.getCameraDevice == 'Andor'
        cameraName = 'Andor iXon';
        cameraPixelSize = num2str(13);
        cameraGain = char(mmc.getProperty(mmc.getCameraDevice,'Gain'));
        cameraSensorReadOutTime = [num2str(getSensorReadOutTime()) ' ms'];
else
        error('did not specify meta data for the camera you are using');
end
% get user defined parameters
strainName = fcScope.defaultSampleName;
% save all the meta data into a formatted string
metaData = {'fcScope parameters',['strainName: ' strainName],['timestamp: ' timestamp],...
    ['magnification: ' currMag],['objective: ' objName], ['exposure: ' exposure],['cameraName: ' cameraName],...
    ['cameraPixelSize: ' cameraPixelSize],['cameraGain: ' cameraGain],['cameraSensorReadoutTime: ' cameraSensorReadOutTime],...
    ['filterCube: ' filter],['Epi Lights levels: ' EpiLightslevels],...
    ['xpos: ' stagePosX],['ypos: ' stagePosY],['timePoints: ' timePointsStr]};
if nargin==2
    metaData = {metaData{:}, ['TTLtrigger: ' TTLtrigger], ['z0: ' z0], ['N: ' N], ['dz: ' dz]};
end

metaData = insertAStringBetweenCells('\n',metaData);
end

