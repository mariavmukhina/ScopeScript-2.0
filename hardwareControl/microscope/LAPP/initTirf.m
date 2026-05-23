function [] = initTirf()
%Moves TIRF lens of TiLAPP attachment 
% range of values for POSITION = [-24320 24320];
%                     Speed = [1 9]

global ti2;

ti2.tirf1XSpeed.Value = 1;
ti2.tirf1YSpeed.Value = 1;

%setTirf('EPI');
%disp('Laser is set to EPI');

setTirf('HILO');
disp('Laser is set to HILO');

fprintf('\n\n');
