function [] = initTirf()
%Moves TIRF lens of TiLAPP attachment 
% range of values for POSITION = [-24320 24320];
%                     Speed = [1 9]

global ti2;

ti2.tirf1XSpeed.Value = 1;
ti2.tirf1YSpeed.Value = 1;

%set tirf position to zero
ti2.tirf1XPOSITION.Value = 0;
ti2.tirf1YPOSITION.Value = 0;

disp('TIRF set to (0,0)')
