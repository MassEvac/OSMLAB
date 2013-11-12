function [amenityCount] = getAmenityCountTotal
% Gets the total number of amenities in the OSM database
% 
% INPUT:
%           'amenity.txt' - List of amenities to look at
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [result] = getAmenity('bar', 'Bristol')

filename = 'cache/_count/amenityCount.mat';

if exist(filename)
    load(filename);
else  
    query = 'SELECT p.amenity, COUNT(*) as amenityCount from planet_osm_point as p GROUP BY p.amenity ORDER BY amenityCount DESC';
    amenityCount =  importDB(query);
    save(filename,'amenityCount');
end