classdef scopeParams < matlab.mixin.SetGet & handle
    properties
        %% PATH TO EXPERIMENT FOLDER
        defaultSampleName       = 'test_3CH_15minGap_6Positions';
        defaultExpFolder        = 'test-timeLapse-stageAppend';

        %% EXPOSURE PARAMETERS FOR REAL TIME IMAGING WITH LIVEBF AND LIVEPL
        cameraExposureLivePL = 10;    % in ms
        cameraExposureLiveBF = 50;    % in ms      
        
        %% DEFINITION OF FUNCTIONS FOR EXECUTEFUNCTION() OR DOTIMELAPSE()
        % define experiments here; executeFunctions() uses setChannel,function and exposure; doTimeLapse() also uses timePoints
        
        % when executeFunctions() or doTimeLapse() are called, the script will look for function[i] = {functionName,argumentList} selected in executeOnly;
        % if selected more than one function, the functions will be run in the order defined in executeOnly
     
        executeOnly = [1,6]; 

        % then execute

        %%%% EXAMPLE RECIPE
        %            i)   setChannel7  = {{'laser-640',1},{'BF',100}};
        %            ii)  function7    = {'takeA3DStack',{'zStack1','Laser640TTL','zStack2','BrightFieldTTL'},''};
        %            iii) timePoints7  = 0:10:60;
        %                 exposure7    = 1;

        % i)   setChannel_i, if does not exist, do nothing - CAN BE USED TO SPEED UP single channel timelapse
        % ii)  function_i
        % iii) at timePoints_i (seconds), if does not exist, do always
        
        % This recipe will take zstacks at two channels defined by (i) setupChannel(): 1 - in the PL channel "laser-640" at 1% Laser intensity, 2 - in the BF channel at 100 units of intensity scale

        % (ii) function7    = {'takeA3DStack',{'zStack1','Laser640TTL','zStack2','BrightFieldTTL'},''} will pass parameters for zstacks to takeA3DStack() to be sent to a custom TTL control board
        % "zstack[i]" (defined below) - number and size of steps of piezo stage
        % "Laser640TTL" - TTL trigger for 640-nm Toptica laser line to be used with "laser-640" channel
        % The full list of TTL triggers for Toptica laser, Retra UV LED (PL), and Peka LED (BF): 'UVTTL','Laser488TTL', 'Laser561TTL', 'Laser640TTL','Laser561&640','BrightFieldTTL'.

        % (iii) If doTimeLapse() is called, 2 zstacks are taken at time points defined in timePoints[7]
        % timePoints1  = 0:10:60; % start immediately, call function[7]
        % every 10 sec for 60 sec total; 

        % Both zstacks are taken with exposure[7]

        %%%%%
        recipelist = []; 
        combinedTimePoints = [];

        
        %-zStack recipes---------------------------------------------------
        % z step is defined in DAC units, not nanometers
        % 1 DAC unit = 220 um[max stage range]/65536 ~= 3 nm
        
        %-zStack feed forward recipes--------------------------------------
        % these parameters define additional stage acceleration
        % acceleration obtained by sending triangle pulses defined by additional voltage ff1_deltaUp and ff1_deltaDown
        % for each z stack recipe, ff1_deltaUp and ff1_deltaDown have to be determined empirically
        % additional acceleration works only in open-loop mode of the z stage (faster but less accurate)
        % by default, the z stage is set up to the closed-loop mode to ensure stability, additional acceleration is not used
        % if parameter for chosen dz step is absent then stage will be moved with a standard rate 
        
        % ff1_dz          = 75;
        % ff1_deltaUp     = 1500;
        % ff1_delayUp     = 1;
        % ff1_deltaDown   = -500;
        % ff1_delayDown   = 1;
        % 
        % ff2_dz          = -300;
        % ff2_deltaUp     = -2850;
        % ff2_delayUp     = 1;
        % ff2_deltaDown   = 100;
        % ff2_delayDown   = 1;
        % 
        % ff3_dz          = -3000;
        % ff3_deltaUp     = -5000;
        % ff3_delayUp     = 20;
        % ff3_deltaDown   = 1000;
        % ff3_delayDown   = 1;
        % 
        % ff4_dz          = -1200;
        % ff4_deltaUp     = -5000;
        % ff4_delayUp     = 20;
        % ff4_deltaDown   = 1000;
        % ff4_delayDown   = 1;
        % 
        % ff5_dz          = 2700;
        % ff5_deltaUp     = 2930;
        % ff5_delayUp     = 1;
        % ff5_deltaDown   = -1000;
        % ff5_delayDown   = 1;
        % 
        % ff6_dz          = 400;
        % ff6_deltaUp     = 2230;
        % ff6_delayUp     = 1;
        % ff6_deltaDown   = -1000;
        % ff6_delayDown   = 1;
        % 
        % ff7_dz          = -400;
        % ff7_deltaUp     = -2850;
        % ff7_delayUp     = 1;
        % ff7_deltaDown   = 100;
        % ff7_delayDown   = 1;
        % 
        % ff8_dz          = -800;
        % ff8_deltaUp     = -3230;
        % ff8_delayUp     = 1;
        % ff8_deltaDown   = 100;
        % ff8_delayDown   = 1;
        % 
        % ff9_dz          = 800;
        % ff9_deltaUp     = 2230;
        % ff9_delayUp     = 1;
        % ff9_deltaDown   = -1000;
        % ff9_delayDown   = 1;
        
        %% -- OPTIONAL PARAMETERS ----------------------------------------------

        % waitForPFS() - after turning ON Nikon PFS requires time to find focus
        waitForPFS_N            = 1000;
        waitForPFS_thresh       = 1;
        waitForPFS_timeout      = 5;

        % adjustGarbageFrames() - micromanager requests N frames, but there are garbage frames in front or back of stream.
        leadingGarbageFrames    = 0;
        laggingGarbageFrames    = 2;

        % setupChannel() - pause for vibration induced by moving filter turret
        pauseTimeFilterCube     = 0;
        pauseTimeShutters       = 0;

        % timelapse start delay in seconds
        startDelay              = 0;
        
        % timelapse stop function
        endFunction = @finishExperiment;
        

        %% -STATE VARIABLES--------------------------------------------------
        currentDate;            % this defines the exp folder
        pfsOffset;              % this defines the PFS offset if available
        stagePos;               % this defines the stage position(s) to use in executeFunctions and doTimeLapse
        currentDateTime;        % this is the curent date and time as datetime obj
    end
    
    properties (Constant)
        %-USER FOLDER TO SAVE IN------------------------------------------
        defaultUser             = 'testUser';
        %-DRIVE TO SAVE IN
        drive                   = 'H:';
        %-MICROMANAGER AND MICROSCOPE CONTROL PROPS------------------------
        %path to uManager app files
        micromanagerPath        = 'C:\Program Files\Micro-Manager-2.0\';
        %path to uManager hardware configuration
        configPath              = 'C:\Program Files\Micro-Manager-2.0\microscope_config.cfg';
        bufferSize              = 4096; %in MB
        % com port for custom TTL control
        fcPiezoCircuitCOMPort   = 'COM3';    
        fcPiezoCircuitBaudRate  = 115200;
        %-TIF SAVING PARAMS------------------------------------------------
        saveParams              = {'tif', 'Compression', 'none'};
    end

    methods
        function obj = scopeParams(varargin)
            % fcScope = scopeParams('saveStage') then this will save the current stage position
            % fcScope = scopeParams() doesn't save stage position
            if nargin == 1
                global stageCoordinates;
                obj.stagePos = stageCoordinates.stagePos;
                if isempty(stageCoordinates.stagePos)
                    obj.stagePos = getStagePos();        % first entry
                else
                    obj.stagePos = [obj.stagePos getStagePos()];  % append as new column
                end
            else
                obj.stagePos    = [];
            end
            obj.currentDate = returnDate();
            obj.pfsOffset   = getPFSOffset();
            obj.currentDateTime = datetime('now');

            recipe1 = recipe();
            recipe1.setChannel  = {{'BF', 10}};
            recipe1.functions   = {'takeA3DStack',{zStack(100, 75, 0),'BrightFieldTTL'},''};
            recipe1.timePoints  = 0:60:60*60*3; % start immediately, call function[1] every 10 sec for 60 sec total
            recipe1.exposure    = 200;

            recipe2 = recipe();
            recipe2.setChannel  = {{'GFP', 10}};
            recipe2.functions   = {'takeA3DStack',{zStack(100, 75, 0),'GFP'},''};
            recipe2.timePoints  = 0:60:60*60*3; % start immediately, call function[1] every 10 sec for 60 sec total
            recipe2.exposure    = 200;

            obj.recipelist = [recipe1, recipe2];


            obj.combinedTimePoints = sort(unique([recipe1.timePoints, recipe2.timePoints]));
        end
        
        function expPath = returnPath(obj)
                expPath = [obj.drive filesep obj.defaultUser filesep obj.currentDate filesep];
        end

        function obj = updateFcScope(obj, otherObj) % updates fcScope without changing stagePos
            props = properties(obj);
            constant_props = {'defaultUser' 'drive' 'micromanagerPath' 'configPath' 'bufferSize' 'fcPiezoCircuitCOMPort' 'fcPiezoCircuitBaudRate' 'saveParams'};      

            for k = 1:numel(props)
                if  ismember(props{k},constant_props) || strcmp(props{k},'stagePos')
                    continue
                end
                obj.(props{k}) = otherObj.(props{k});
            end
        end
    end
end
