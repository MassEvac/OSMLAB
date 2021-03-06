function [result] = getBoundary(place)
% Gets the boundary co-ordinates of the given place
% 
% INPUT:
%           place (String) - Name of an area polygon in OpenSteetMap
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the boundary
% EXAMPLE:
%           [result] = getBoundary('Bristol')
% NOTE:
%           May be useful to query the following in the future:
%           (g.p).path[1] is the index of polygon when there are multiple
%           (g.p).path[2] is the index of coordinate within each polygon

load('global');

query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom), (g.p).path[1], (g.p).path[2] '...
        'FROM '...
        '(SELECT ST_DumpPoints(f.way) AS p FROM '...
        ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' AND boundary=''administrative'' ORDER BY ST_area(way) DESC LIMIT 1) AS f) AS g'];

rootPath = ['./cache/boundary/' DBase '/'];

if ~exist(rootPath,'file')
    mkdir(rootPath);
end
    
result = getFileOrQuery([rootPath place], DBase, query);