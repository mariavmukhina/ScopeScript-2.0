function [] = loadMMConfigFile()
%LOADCONFIGFILE imports mmcorej.* and creates cmmcore object and loads
%configuration file

global mmc;
fcScope = scopeParams;
import mmcorej.*;
mmc = CMMCore;
mmc.enableStderrLog(true);
mmc.enableDebugLog(true);
logFilePath = 'C:\Users\khanley1\Documents\MicroManagerLog.txt';
mmc.setPrimaryLogFile(logFilePath, true);

disp('loading other hardware configuration ...');
mmc.loadSystemConfiguration(fcScope.configPath);



