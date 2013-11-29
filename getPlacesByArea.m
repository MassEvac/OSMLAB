function [placesByArea] = getPlacesByArea
% Gets the total number of highways in the OSM database
% 
% INPUT:
%           SQL Query
% OUTPUT:
%           placesByArea - Name and SRID area of the place
% EXAMPLE:
%           [placesByArea] = getPlacesByArea

filePath = './cache/_area/';

if ~exist(filePath,'file')
    mkdir(filePath);
end

fileName = [filePath 'placesByAreaINm2.mat'];

if exist(fileName,'file')
    load(fileName);
else  
    query = 'SELECT p.name, ST_area(p.way,false) AS area FROM planet_osm_polygon AS p ORDER BY area DESC;';
    placesByArea =  importDB(query);
    save(fileName,'placesByArea');
end