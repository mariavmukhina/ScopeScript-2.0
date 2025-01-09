function [] = livePL(varargin)
%LIVEPL runs imaging in the PL channel in a current focal plane with real-time display, data are not saved
% PL channel can be either preselected with setupChannel or specified as function input: livePL('1-QDot',100)

if ~isempty(varargin)
   channel =  varargin{1};
   energy =  varargin{2};
   setupChannel(channel,energy);
else
    channel = [];
    energy = [];
end

fcScope = scopeParams;
setExposure(fcScope.cameraExposureLivePL);
openTurretShutter();

% save current ROI
oldROI = getROI();
%clearROI();

PL();

stopStreaming();
disp('--livePL()-----------------------');

printScopeSettings();

doLive(oldROI,channel,energy);

setROI(oldROI);
turnOffCameraToggles();
BF();

fprintf('\n\n');
end

