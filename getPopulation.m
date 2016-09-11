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
%           result(:,1:2) (Double) - Longitude and Latitude of the cell centroid
%           result(:,3) (Double) - Population Density (persons/km^2)
% EXAMPLE:
%           [result] = getPopulation('Bristol')

load('global');

table = 'pop_gpwv4_2015';

% Old query format
query = ['SELECT ST_RasterToWorldCoordX(p.rast, x) AS wx, ST_RasterToWorldCoordY(p.rast,y) AS wy, ST_Value(p.rast, x, y) as v '...
        'FROM ' table ' AS p, '...
        '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' AND boundary=''administrative'' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f '...
        'CROSS JOIN generate_series(1, 100) As x '...
        'CROSS JOIN generate_series(1, 100) As y '...
        'WHERE ST_Intersects(p.rast,f.way)'];  

% New query format copied over from MassEvac v4
query = ['SELECT x, y, val FROM'...
                        '(SELECT (ST_PixelAsCentroids(ST_Clip(q.raster,q.clipper))).* FROM'...
                            '(SELECT p.rast AS raster, b.way as clipper'...
                                'FROM {} AS p,'...
                                    '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' AND boundary = ''administrative'' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS b'...
                                'WHERE ST_Intersects(p.rast,b.way)) AS q) AS foo;'];

filePath = ['./cache/' table '/'];

if ~exist(filePath,'file')
    mkdir(filePath);
end

rootPath = [filePath DBase '/']

if ~exist(rootPath,'file')
    mkdir(rootPath);
end

result = getFileOrQuery([rootPath place], DBase, query);