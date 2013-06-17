function [AM] = resizeAM(AM)
pSize = length(AM);
    
if size(AM,1) ~= pSize || size(AM,2) ~= pSize
    AM(pSize,pSize) = 0;
end