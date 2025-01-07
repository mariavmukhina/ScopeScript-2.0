global ti2;

% % for tirf1, tirf2, and tirf3, has X and Y: %
% Max value is ti2.tirf1XPOSITION.Value = 24320;





% ti2.tirf1XPOSITION
% ti2.tirf1XSpeed
% 
% ti2.tirf1YPOSITION
% ti2.tirf1YSpeed

% % example
% 
% ti2.tirf1XPOSITION.Value = 100;

%I have confirmed that tirf1 controls the XY position of the condeser lens
%for the laser. You can see the lens move if you look into the optical path
%where the laser goes

%these are your 2 options for the switching the mirror on main branch 1, either UV LED (2)
%Or Laser(1) 
%ti2.LappMainBranch1.Value = 1
%ti2.LappMainBranch1.Value = 2