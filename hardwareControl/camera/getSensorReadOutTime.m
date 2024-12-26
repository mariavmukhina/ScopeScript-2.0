function [readOutTime] = getSensorReadOutTime()
%GETSENSORREADOUTTIME returns frame read out time in ms
global mmc;

readOutTime = str2double(mmc.getProperty(mmc.getCameraDevice,'ReadoutTime'));

end

