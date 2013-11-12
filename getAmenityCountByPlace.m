function [amenityCount] = getAmenityCountByPlace(amenityTags,places)
% Gets the total number of amenities in the OSM database
% 
% INPUT:
%           amenityTags{j} (String Cell) - Name of the amenities to consider
%           places{i} (String Cell) - Name of an area polygons in OpenSteetMap
% OUTPUT:
%           amenityCount(i,j) (Integer) - Number of amenityTag{i} in places{j}
% EXAMPLE:
%           [result] = getAmenity('bar', 'Bristol')


filename = 'cache/_count/amenityCountByPlace.mat';

if exist(filename)
    load(filename);
else  
    tic;
    query = ['SELECT DISTINCT p.amenity,q.name, COUNT(*) AS amenityCount FROM planet_osm_point AS p, planet_osm_polygon AS q WHERE q.name IN (''' strjoin(places,''',''') ''') AND p.amenity IN (''' strjoin(amenityTags,''',''') ''') AND ST_Intersects(p.way, q.way) GROUP BY p.amenity,q.name ORDER BY q.name, amenityCount DESC'];
    result = importDB(query);
    save(filename,'amenityCount');
    toc;
end

a = length(amenityTags);
p = length(places);

amenityCount = zeros(p,a);

[r,~]=size(result);

for i = 1:r
    thisAmenity = find(ismember(amenityTags,result{i,1}));
    thisPlace = find(ismember(places,result{i,2}));
    if (thisPlace && thisAmenity)
        amenityCount(thisPlace,thisAmenity) = result{i,3};
    end
end