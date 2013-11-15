function [highwayCount] = getHighwayCountTotal
% Gets the total number of highways in the OSM database
% 
% INPUT:
%           SQL Query
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [result] = getAmenity('bar', 'Bristol')

filename = 'cache/_count/highwayCount.mat';

if exist(filename)
    load(filename);
else  
    query = 'SELECT r.highway, COUNT(*) AS highwayCount FROM planet_osm_line AS r GROUP BY r.highway ORDER BY highwayCount DESC;';
    highwayCount =  importDB(query);
    save(filename,'highwayCount');
end