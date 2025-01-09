function [] = liveBF(varargin)
%LIVEBF runs imaging in the BF channel in a current focal plane with real-time display, data are not saved
% BF channel can be either preselected with setupChannel or specified as function input: liveBF('led-BF',50)

if ~isempty(varargin)
   channel =  varargin{1};
   energy =  varargin{2};
   setupChannel(channel,energy);
else
    channel = [];
    energy = [];
end

fcScope = scopeParams;
setExposure(fcScope.cameraExposureLiveBF);
closeTurretShutter();

% save current ROI
oldROI = getROI();
clearROI();

BF();

stopStreaming();
disp('--liveBF()-----------------------');

doLive(oldROI,channel,energy);

setROI(oldROI);
turnOffCameraToggles();

fprintf('\n\n');

end

