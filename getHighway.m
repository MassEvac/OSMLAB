function [result] = getHighway(place)
% Constructs a query to retrieve highway information
%
% INPUT:
%           place (String) - Name of an area polygon in OpenSteetMap
% OUTPUT:
%           result(:,1:2) (Doubles) - Longitude and Latitude
%           result(:,3) (Integer) - Index of a given path
%           result(:,4) (Integer) - Highway class
%           result(:,5) (Boolean) - Oneway or not
% EXAMPLE:
%           [result] = getHighway('Bristol')
% NOTE:
%           Highway classes are defined in getHighwayTagsAsNumbers
% ISSUES:
%           If there are 'java.lang.OutOfMemoryError: Java heap space'
%           problems, refer to the following link for instructions:
%           http://www.mathworks.co.uk/support/solutions/en/data/1-18I2C/

load('global');

query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom), (g.p).path[1], g.h, g.o '...
        'FROM ('...
        ' SELECT 1 AS edge_id, ST_DumpPoints(r.way) AS p, r.highway AS h, r.oneway as o '...
        ' FROM '...
        ' planet_osm_line AS r,'...
        ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' AND boundary=''administrative'' ORDER BY ST_area(way) DESC LIMIT 1) AS s'...
        ' WHERE r.highway <> '''' AND ST_Intersects(r.way, s.way)'...
        ') AS g'];

% query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom), (g.p).path[1], g.h, g.o '...
%         'FROM ('...
%         ' SELECT 1 AS edge_id, ST_DumpPoints(r.way) AS p, r.highway AS h, r.oneway as o '...
%         ' FROM '...
%         ' planet_osm_line AS r'...
%         ' WHERE r.highway IN (''motorway'',''motorway_link'',''trunk'',''trunk_link'',''primary'',''primary_link'') '...
%         ') AS g'];    
%     
    
% Entire Database    
% query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom), (g.p).path[1], g.h, g.o '...
%         'FROM ('...
%         ' SELECT 1 AS edge_id, ST_DumpPoints(r.way) AS p, r.highway AS h, r.oneway as o '...
%         ' FROM '...
%         ' planet_osm_line AS r'...
%         ' WHERE r.highway <> '''''...
%         ') AS g'];    

rootPath = ['./cache/highway/' DBase '/'];

if ~exist(rootPath,'file')
    mkdir(rootPath);
end

filePath = [rootPath place '/'];

if ~exist(filePath,'file')
    mkdir(filePath);
end
    
result = getFileOrQuery([filePath 'highwayQueryResult'], DBase, query,'highway');