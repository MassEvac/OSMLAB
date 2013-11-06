% Gets the number of amenities in the OSM database
% 
% INPUT:
%           'amenity.txt' - List of amenities to look at
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [result] = getAmenity('bar', 'Bristol')

tic;
query = 'SELECT p.amenity, COUNT(*) as amenityCount from planet_osm_point as p group by p.amenity ORDER BY amenityCount DESC';
amenityCount =  importDB(query);
save('cache/amenityCount.mat','amenityCount');
toc;