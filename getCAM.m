function [CAM] = getCAM(HAM, C)

CAM = HAM;

CAM(CAM==1)=C*3;
CAM(CAM==2)=C*2;
CAM(CAM==3)=C*2;
CAM(CAM==4)=C*1.5;
CAM(CAM==5)=C*1;
CAM(CAM==6)=C*1;
CAM(CAM==7)=C*0.5;

% 1	'motorway'
% 1	'motorway_link'
% 2	'trunk'
% 2	'trunk_link'
% 3	'primary'
% 3	'primary_link'
% 4	'secondary'
% 4	'secondary_link'
% 5	'tertiary'
% 5	'tertiary_link'
% 6	'residential'
% 6	'byway'
% 6	'road'
% 6	'living_street'
% 7 all others...