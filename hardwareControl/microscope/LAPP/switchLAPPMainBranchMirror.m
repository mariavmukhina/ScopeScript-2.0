function [] = switchLAPPMainBranchMirror(position)
%Switches mirror on the main branch of TiLAPP attachment between laser and LED positions:
%LED - position 2
%Laser - position 1

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