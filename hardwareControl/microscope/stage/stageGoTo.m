function [] = stageGoTo(positionN)
%STAGEGOTO moves the microscope stage to XYZ positionN from the stagePos list saved in object stageCoordinates of class scopeParams, given that stagePos is populated by stageAppend

global stageCoordinates;
if positionN > 0 && positionN <= numel(stageCoordinates.stagePos)
   gotoStagePos(stageCoordinates.stagePos(positionN));
else
   disp('stage position is out of bounds'); 
end

end

