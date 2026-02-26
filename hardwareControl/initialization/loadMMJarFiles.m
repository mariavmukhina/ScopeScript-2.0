function [] = loadMMJarFiles()
%LOADJARFILES looks inside jarFolder and loads all the jars found inside

fcScope = scopeParams;
% Sets Matlab's Java path to the version supplied with Micro Manager
%jenv("C:\Users\mukhina\Documents\GitHub\ScopeScript-2.0\binaries\Micro-Manager-2.0\jre");
% Temporarily adds Micro-Manager path to MATLAB's environment PATH for this session so that Matlab caould get access to Micromanager DLLs
%setenv('PATH', [getenv('PATH') ';' fcScope.micromanagerPath]);
%% 


%Temporarily adds  Micro-Manager path to MATLAB's Java path
jarPath = 'plugins\Micro-Manager';
jarFolder = [fcScope.micromanagerPath jarPath];
jarFiles = getLocalFiles(jarFolder,'jar');
% load micromanager jars
for i = 1:numel(jarFiles)
    javaaddpath(jarFiles{i});
end
javaaddpath([fcScope.micromanagerPath 'ij.jar']);
% add uManager folder so dlls can be found
addpath(fcScope.micromanagerPath);

end

