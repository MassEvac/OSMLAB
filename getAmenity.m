function [result] = getAmenity(amenityTag, place)
% Gets the co-ordinates of amenities within the given place described by amenityTag
% 
% INPUT:
%           amenityTag (String) - Name of the amenity to consider
%           place (String) - Name of an area polygon in OpenSteetMap
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity

query = ['SELECT DISTINCT ST_X(p.way), ST_Y(p.way) '...
        'FROM planet_osm_point AS p, '...
        '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS q '...
        'WHERE (p.amenity=''' amenityTag ''' OR p.tags ? ''' amenityTag ''') AND ST_Intersects(p.way, q.way)'];

result = getFileOrQuery(['./cache/' amenityTag '-' place], query);