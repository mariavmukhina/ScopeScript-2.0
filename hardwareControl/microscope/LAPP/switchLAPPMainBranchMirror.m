function [] = switchLAPPMainBranchMirror(position)
%Switches The mirror on the main branch of TiLAPP attachment between laser and UV LED
% position = 1 - laser
% position = 2 - LED

global ti2;

ti2.LappMainBranch1.Value = position;
if position == 1
    disp('Mirror on the main branch of TiLAPP attachment is switched to laser')
elseif position == 2
    disp('Mirror on the main branch of TiLAPP attachment is switched to LED')
else
    disp('Mirror position was not switched. Available positions: 1 - laser, 2 - LED');
end

end

