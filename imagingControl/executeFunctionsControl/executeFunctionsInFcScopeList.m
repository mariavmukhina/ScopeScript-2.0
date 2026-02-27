function [] = executeFunctionsInFcScopeList(fcScopeList)
%EXECUTEFUNCTIONSINPARAMS will look inside the list of fcScopes, which
%contains fcScopes defined at various stage positions and pfsOffset,
%functions... parses all of them. and executes the functions if the
%timepoints match the current timestamp.
%
%
%function labled as functioni
% for each functioni
% 1) if setChanneli exists, setupChannel(setChanneli);
% 2) execute functioni = {functionname, argumentList}
%    functionname(argumentList);
% 3) if timepointsi exists and timer is running, only execute functions
% when timepointsi match the current elapsed time (seconds)
%
% can be given a single fcScope object or a list of them
% if a list is given, the timepointsi of all of the them will be collected
% and organized as such

setupStage();
global masterFileMaker;
currentElapsedTimeInSeconds = returnSecsFromRunningTimer();
display(['current timepoint (secs):' num2str(currentElapsedTimeInSeconds)]);
if isempty(currentElapsedTimeInSeconds)
    currentElapsedTimeInSeconds = 0;
end
numFcScope = numel(fcScopeList);
for i = 1:numFcScope
    for j = 1:length(fcScopeList{i}.recipelist)
        if contains(fcScopeList{i}.recipelist{j}.setChannel,'BF')
            BF();
        else
            PL();
        end
        currTimePoints = fcScopeList{i}.combinedTimePoints;
        if ~ischar(currTimePoints)
            timer = timerfind('Name','timeLapse');
            lastTimePoint = max(currTimePoints); 
            if isempty(lastTimePoint)
                checkLastTimePoint = false;
            else
                checkLastTimePoint = lastTimePoint == currentElapsedTimeInSeconds;
            end
        end
        if (~ischar(currTimePoints) && (sum(ismember(currTimePoints,currentElapsedTimeInSeconds))>0))  || ~isATimerOn()
            % go to stage pos if available
            if numel(fcScopeList) > 1
                if ~isempty(fcScopeList{i}.stagePos)
                    masterFileMaker.setStagePos(i);
                else
                    masterFileMaker.setStagePos([]);
                end       
            else
                masterFileMaker.setStagePos([]);
            end
            % wait for stage position to finish
            waitForSystem();
            % setup channel
            updateChannelGivenCommand(fcScopeList{i}.recipelist{j}.setChannel);
            % wait for PFS
            currentPFSState = getPFSState();
            if currentPFSState
                waitForPFS(fcScopeList{i}.pfsOffset);
            end
            % set exposure 
            setExposure(fcScopeList{i}.recipelist{j}.exposure);            
            % execute function
            executeFunctionGivenCommand(fcScopeList{i}.recipelist{j}.functions,fcScopeList{i})
            % wait for PFS
            if currentPFSState
                waitForPFS(fcScopeList{i}.pfsOffset);
            end   
        else  
        end       
    end
end

initForNextInFcScopeList(fcScopeList);
end

