function [amenityCount] = getAmenityCountTotal
% Gets the total number of amenities in the OSM database
% 
% INPUT:
%           'amenity.txt' - List of amenities to look at
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [result] = getAmenityCountTotal

load('global');

filePath = ['./cache/count/' DBase '/'];

if ~exist(filePath,'file')
    mkdir(filePath);
end

query = 'SELECT p.amenity, COUNT(*) AS amenityCount FROM planet_osm_point AS p GROUP BY p.amenity ORDER BY amenityCount DESC';

amenityCount =  getFileOrQuery([filePath 'amenityCount'],DBase,query,'nocell2mat');