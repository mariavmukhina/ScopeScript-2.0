function [position] = getMirrorPosition()
%Returns position of the mirror switching between between laser and LED light pathes on the main branch of TiLAPP attachment:
%LED - position 2
%Laser - position 1

global ti2;

position = get(ti2,'iLAPP_MAINBranch1');

end