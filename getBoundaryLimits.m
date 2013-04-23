function [max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(boundary)

% determine the extremes
max_lon = max(boundary(:,1));
max_lat = max(boundary(:,2));
min_lon = min(boundary(:,1));
min_lat = min(boundary(:,2));