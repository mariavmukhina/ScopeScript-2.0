function [] = stageAppend(varargin)
%STAGEAPPEND allows to save multiple XYZ locations of the microscope stage
%to global variable stageCoordinates of class scopeParams
%the stageCoordinates list is then used to execute functions (Z stacks) at the selected locations
%if doTimeLapse is called and stageCoordinates.stagePos are not empty,
%functions will be executed in each location for each timepoint

global stageCoordinates;
fcScopeCurrent = scopeParams('saveStage');
stageCoordinates = fcScopeCurrent;

end

