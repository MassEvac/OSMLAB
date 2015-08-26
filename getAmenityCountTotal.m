function [amenityCount] = getAmenityCountTotal
% Gets the total number of amenities in the OSM database
% 
% INPUT:
%           'amenity.txt' - List of amenities to look at
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [result] = getAmenityCountTotal

fileName = 'cache/count/amenityCount';

query = 'SELECT p.amenity, COUNT(*) AS amenityCount from planet_osm_point AS p GROUP BY p.amenity ORDER BY amenityCount DESC';
amenityCount =  getFileOrQuery(fileName,query);