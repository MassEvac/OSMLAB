function [placesByArea] = getPlacesByArea
% Gets the total number of highways in the OSM database
% 
% INPUT:
%           SQL Query
% OUTPUT:
%           placesByArea - Name and SRID area of the place
% EXAMPLE:
%           [placesByArea] = getPlacesByArea

filePath = './cache/area/';

if ~exist(filePath,'file')
    mkdir(filePath);
end

fileName = [filePath 'placesByAreaInMetricBD'];

query = 'SELECT p.name, ST_Area(p.way,false) AS area FROM planet_osm_polygon AS p WHERE p.name <> '''' ORDER BY area DESC;';
placesByArea =  getFileOrQuery(fileName, query,'nocell2mat');