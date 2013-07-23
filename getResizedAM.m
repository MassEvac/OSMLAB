function [AM] = getResizedAM(AM,varargin)
if nargin>1
    pSize = varargin{1};
else
    pSize = length(AM);
end    
    
if size(AM,1) ~= pSize || size(AM,2) ~= pSize
    AM(pSize,pSize) = 0;
end