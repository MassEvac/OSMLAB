function [placesByArea] = getPlacesByArea
% Gets the total number of highways in the OSM database
% 
% INPUT:
%           SQL Query
% OUTPUT:
%           placesByArea - Name and SRID area of the place
% EXAMPLE:
%           [placesByArea] = getPlacesByArea

load('global');

rootPath = ['./cache/area/' DBase '/list'];

if ~exist(rootPath,'file')
    mkdir(rootPath);
end

fileName = [rootPath 'placesByAreaInMetricAdministrative'];


query = 'SELECT p.osm_id, p.name, p.admin_level, sum(ST_Area(p.way,false)) AS area FROM planet_osm_polygon AS p WHERE boundary=''administrative'' GROUP BY p.osm_id, p.name, p.admin_level ORDER BY area DESC;';
placesByArea =  getFileOrQuery(fileName, DBase, query,'nocell2mat');