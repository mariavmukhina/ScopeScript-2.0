%STARTMICROSCOPE startups the microscope and initializes other hardware

% load Nikon Ti2 configuration
loadNikonTI2();
% loads the java library
loadMMJarFiles();
% loads the uManager config file and returns mmc object
loadMMConfigFile();

% variable that stores all Nikon settings
global ti2;
% variable that stores settings for all other devices using µManager adapters
global mmc;
%multiple xy stage positions
global stageCoordinates;

%user-defined ROI to be shown as a white rectange in all live images
%it is also added as a white rectange to all images produced by executeFucntions / doTimeLapse is ROI for those functions is bigger than defined by showROI
%default is full ROI
global showROI;

%prepare to save the data
global masterFileMaker;
masterFileMaker = masterFileGenerator();

% set image buffer size
mmc.setCircularBufferMemoryFootprint(scopeParams.bufferSize);
mmc.initializeCircularBuffer();

parpool();

fprintf('\n\n');

initMicroscope();

disp('INITIALIZATION IS SUCCESSFULLY COMPLETED')
disp('============================================================')

