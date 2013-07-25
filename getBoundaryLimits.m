function [max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(place)
% Returns the edge co-ordinates of the rectangular box enclosing a list of co-ordinates
%
% INPUT:
%           place (String) - Name of an area polygon in OpenSteetMap
% OUTPUT:
%           max_lon (Double) - Maximum longitude
%           max_lat (Double) - Maximum latitude
%           min_lon (Double) - Minimum longitude
%           min_lat (Double) - Minimum latitude

coordinates = getBoundary(place);

max_lon = max(coordinates(:,1));
max_lat = max(coordinates(:,2));
min_lon = min(coordinates(:,1));
min_lat = min(coordinates(:,2));