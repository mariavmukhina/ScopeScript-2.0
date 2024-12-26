function [] = loadMMJarFiles()
%LOADJARFILES looks inside jarFolder and loads all the jars found inside

fcScope = scopeParams;
% Temporarily adds Micro-Manager path to MATLAB's environment PATH for this session
setenv('PATH', [getenv('PATH') ';' fcScope.micromanagerPath]);

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

