function [] = switchToTIRF()
%Moves TIRF lens of TiLAPP attachment to TIRF position
% range of values for POSITION = [-24320 24320];
%                     Speed = [1 9]

global ti2;

ti2.tirf1XSpeed.Value = 1;
ti2.tirf1YSpeed.Value = 1;

% position 24320/3.89 seems to be close to TIRF
%need to do more checks with more homogeneous sample
% all +/- combinations of positions seem to work similarly
ti2.tirf1XPOSITION.Value = 24320/3.89;
ti2.tirf1YPOSITION.Value = 24320/3.89;

disp('Laser illumination switched to TIRF')
