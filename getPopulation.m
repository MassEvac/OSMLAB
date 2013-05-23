function [result] = getPopulation(place)

query = ['SELECT (ST_Raster2WorldCoordX(p.rast, x) + ST_ScaleX(rast) / 2) AS wx, (ST_Raster2WorldCoordY(p.rast,y) + ST_ScaleY(rast) / 2) AS wy, ST_Value(p.rast, x, y) as v '...
        'FROM population AS p, '...
        '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f '...
        'CROSS JOIN generate_series(1, 50) As x '...
        'CROSS JOIN generate_series(1, 50) As y '...
        'WHERE ST_Intersects(p.rast,f.way)'];  
    
disp(query);    
  
result = getFileOrQuery(['./cache/population-' place], query);