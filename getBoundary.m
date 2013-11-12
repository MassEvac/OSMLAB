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

query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom) '...
        'FROM '...
        '(SELECT ST_DumpPoints(f.way) AS p FROM '...
        ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f) AS g'];

filePath = './cache/_boundary/';

if ~exist(filePath,'file')
    mkdir(filePath);
end
    
result = getFileOrQuery([filePath place], query);