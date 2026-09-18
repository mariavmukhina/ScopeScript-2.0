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


        setChannel1 = {{'BF', 10}};
        function1    = {'takeA3DStack',{'zStack2','BrightFieldTTL'},''};
        timePoints1  = 0:60*15:60*60*3; % 
        exposure1 = 200;

        
        % fcScope[2] takes only 1 zstack in the PL channel "laser-640"
        setChannel2  = {{'laser-640',1}};
        function2    = {'takeA3DStack',{'zStack2','Laser640TTL'},''};
        timePoints2  = 0:60*5:60*10;
        exposure2    = 20;
        
        setChannel3  = {{'laser-561',1}};
        function3    = {'takeA3DStack',{'zStack2','Laser561TTL'},''};
        timePoints3  = 0:60*5:60*10;
        exposure3    = 20;
        
        setChannel4  = {{'laser-488',1}};
        function4    = {'takeA3DStack',{'zStack2','Laser488TTL'},''};
        timePoints4  = 0:15:60*60*4;
        exposure4    = 10;
        
               
        setChannel5  = {{'led-340',1}};
        function5    = {'takeA3DStack',{'zStackZeroStep','UVTTL'},''};
        timePoints5  = 0:15:60*60*3;
        exposure5    = 10;
        
        setChannel6  = {{'laser-561-640',{1,1}},{'laser-561-640',{1,1}}};
        function6    = {'takeA3DStack',{'zStack1','Laser561TTL','zStack2','Laser640TTL'},''};
        timePoints6  = 0:60*15:60*60*3;
        exposure6    = 10;
        

        setChannel7  = {{'laser-640',1},{'BF',1}};
        function7    = {'takeA3DStack',{'zStack1','Laser640TTL','zStack2','BrightFieldTTL'},''};
        timePoints7  = 0:60:60*60;
        exposure7    = 10;
        
        setChannel8  = {{'laser-561',1},{'BF',100}};
        function8    = {'takeA3DStack',{'zStack1','Laser561TTL','zStack2','BrightFieldTTL'},''};
        timePoints8  = 0:10:60;
        exposure8    = 10;
        
        setChannel9  = {{'laser-488',1},{'BF',100}};
        function9    = {'takeA3DStack',{'zStack1','Laser488TTL','zStack2','BrightFieldTTL'},''};
        timePoints9  = 0:10:60;
        exposure9    = 10;
        
        
        %fcScope[11] takes 2D stack with 2 PL channels triggered
        %simultaneously for Optosplit
        setChannel11  = {{'6-TRF561-640',{6,2}}};
        function11    = {'takeA3DStack',{'zStackZeroStep1','AllFourTTL'},''};
        timePoints11  = 0:5:60*60;
        exposure11    = 50;
        
        %-zStack recipes---------------------------------------------------
        % z step is defined in DAC units, not nanometers
        % 1 DAC unit = 220 um[max stage range]/65536 ~= 3 nm
        zStack1_N   = 100; % number of slices
        zStack1_dz  = 75; % size of a piezo step; stage goes up
        zStack1_z0  = 0;  % starting plane
        
        zStack2_N   = 100;
        zStack2_dz  = -75; % stage goes down
        zStack2_z0  = 100*75;
        
        zStack3_N   = 15;
        zStack3_dz  = -300;
        zStack3_z0  = 4*300;
        
        zStack4_N   = 1;
        zStack4_dz  = 0;
        zStack4_z0  = 0;
        
        zStack5_N   = 11;
        zStack5_dz  = 400;
        zStack5_z0  = 0;
        
        zStack6_N   = 11;
        zStack6_dz  = -400;
        zStack6_z0  = 8*400;
        
        zStack8_N   = 180; 
        zStack8_dz  = -7;
        zStack8_z0  = 0;
        
        zStackZeroStep_N   = 50; %for 2D timeLapses
        zStackZeroStep_dz  = 0;
        zStackZeroStep_z0  = 0;
        
        zStackZeroStep1_N   = 1; %for 2D timeLapses
        zStackZeroStep1_dz  = 0;
        zStackZeroStep1_z0  = 0;
