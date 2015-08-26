function [highwayCount] = getHighwayCountTotal
% Gets the total number of highways in the OSM database
% 
% INPUT:
%           SQL Query
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [highwayCount] = getHighwayCountTotal

fileName = 'cache/count/highwayCount';

query = 'SELECT r.highway, COUNT(*) AS highwayCount FROM planet_osm_line AS r GROUP BY r.highway ORDER BY highwayCount DESC;';
highwayCount =  getFileOrQuery(fileName, query);