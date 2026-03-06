function [] = doTimeLapseInFcScope(fcScope)
%DOTIMELAPSEINFCSCOPE gets all the timepoints and calculates the smallest time period to
% accomodate every event
% i will append all the timepoints together
% sort it
% find unique diff
% calculate gcd
% use that as period

global masterFileMaker;
startDelay = fcScope.startDelay;
uberTimePoints = [];
<<<<<<< HEAD:imagingControl/timeLapseControl/doTimeLapseInFcScopeList.m


for i = 1:numFcScope
    uberTimePoints = [uberTimePoints fcScopeList{i}.combinedTimePoints];
=======
parsedAndValues = parseParamsForFunctions(fcScope);
executeOnly = fcScope.executeOnly;
for j = executeOnly
    currTimePoints = parsedAndValues.values{j}{3};
    if ~ischar(currTimePoints)
        uberTimePoints = [uberTimePoints currTimePoints];
    end
>>>>>>> upstream/main:imagingControl/timeLapseControl/doTimeLapseInFcScope.m
end

%setup period
uberTimePoints = sort(uberTimePoints);
periods = unique(diff(uberTimePoints));
timeLength = max(uberTimePoints(:));

if (timeLength == Inf || isempty(timeLength))
    warning('timepoints are not defined in fcScope objs');
    return;
end
useperiod = gcdInArray(periods(periods>0));
Nsamples = round(timeLength/useperiod)+1;
% setup new timelapse folder
masterFileMaker.setupTimeLapseFolder(fcScope);

% setup timer
% clear timers
t = timerfind('Name','timeLapse');
delete(t);
% create new timer
t = timer();
<<<<<<< HEAD:imagingControl/timeLapseControl/doTimeLapseInFcScopeList.m
t.Name              = 'timeLapse';
t.ExecutionMode     = 'fixedRate';
t.Period            = useperiod;
t.TasksToExecute    = Nsamples;
t.BusyMode          = 'drop';
t.StartFcn          = {@my_callback_fcn, @initForNextInFcScopeList,fcScopeList};
t.ErrorFcn          = {@terminateFunc};
t.StopFcn           = {@stopFunc};
t.TimerFcn          = {@my_callback_fcn, @executeFunctionsInFcScopeList,fcScopeList};
t.StartDelay        = startDelay;
=======

set(t,'Name','timeLapse');
set(t,'ExecutionMode','fixedRate');
set(t,'Period',useperiod);
set(t,'TasksToExecute',Nsamples);
set(t,'BusyMode','drop');
set(t,'ErrorFcn',{@terminateFunc});
set(t,'StopFcn',{@stopFunc});
set(t,'TimerFcn',{@my_callback_fcn, @executeFunctionsInFcScope,fcScope});
set(t','StartDelay',startDelay);
>>>>>>> upstream/main:imagingControl/timeLapseControl/doTimeLapseInFcScope.m
try
    fprintf('timer starting with delay(secs): %i, period(secs): %i, timeLength(secs): %i, Nsamples: %i\n',startDelay,useperiod,timeLength,Nsamples);
    start(t);
catch
    disp('doTimelapse failed');
end
end

function my_callback_fcn(obj, event, func, funcArg)
    fprintf('===');
    txt1 = '() executed at ';
    event_time = datestr(event.Data.time);
    msg = [func2str(func) txt1 event_time];
    fprintf('%s==========\n',msg);
    func(funcArg);
end

function terminateFunc(obj,event)
    global masterFileMaker;
    disp('error in doTimelapse');
    masterFileMaker.reset();
end

function stopFunc(obj,event)
    global masterFileMaker;
    fcScopeStop = scopeParams();
    endFunction = fcScopeStop.endFunction;
    if ~isempty(endFunction)
        disp('running stop function in timer');
        endFunction();
    end
    disp('TimeLapse Finished');
    masterFileMaker.reset();
end
