function stagePos = getStagePos()
%GETSTAGEPOS Summary of this function goes here
%   Detailed explanation goes here

global ti2;
stagePosX = get(ti2,'iXPOSITION');
stagePosY = get(ti2,'iYPOSITION');
stagePosZ = get(ti2, 'iZPOSITION');
stagePos.X = stagePosX;
stagePos.Y = stagePosY;
stagePos.Z = stagePosZ;
end

