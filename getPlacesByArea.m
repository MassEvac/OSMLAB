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

% Get all places ordered by size
query = 'SELECT p.osm_id, p.name, p.admin_level, sum(ST_Area(p.way,false)) AS area FROM planet_osm_polygon AS p WHERE boundary=''administrative'' GROUP BY p.osm_id, p.name, p.admin_level ORDER BY area DESC;';

% Get places similar to City of Bristol (+/- 25%)
query = 'SELECT * FROM (SELECT p.osm_id, p.name, p.admin_level, SUM(ST_Area(p.way,false))  AS area, COUNT(p.osm_id) AS polygon_count FROM planet_osm_polygon AS p WHERE boundary=''administrative'' GROUP BY p.osm_id, p.name,p.admin_level ORDER BY admin_level, area DESC) AS q WHERE polygon_count = 1 AND CAST(admin_level AS INT) < 10 AND name != '''' AND area != ''NaN'' AND area BETWEEN 235816681.819764*3/4 AND 235816681.819764*5/4;';
placesByArea =  getFileOrQuery(fileName, DBase, query,'nocell2mat');