function [result] = getPopulation(place)
% Gets the population density of the tiles that encapsulate the given place
% 
% DETAIL:
%           Gets the population density of a geographical area confined within
%           the geographical area referenced by the input place in terms of 
%           point location and the population density
% INPUT:
%           place (String) - Name of an area polygon in OpenSteetMap
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the data centroid
%           result(:,3) (Double) - Population Density (persons/km^2)

query = ['SELECT (ST_Raster2WorldCoordX(p.rast, x) + ST_ScaleX(rast) / 2) AS wx, (ST_Raster2WorldCoordY(p.rast,y) + ST_ScaleY(rast) / 2) AS wy, ST_Value(p.rast, x, y) as v '...
        'FROM population AS p, '...
        '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f '...
        'CROSS JOIN generate_series(1, 50) As x '...
        'CROSS JOIN generate_series(1, 50) As y '...
        'WHERE ST_Intersects(p.rast,f.way)'];  
  
result = getFileOrQuery(['./cache/population-' place], query);