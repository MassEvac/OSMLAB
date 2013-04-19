function [result] = getBoundary(place)

query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom) '...
        'FROM '...
        '(SELECT ST_DumpPoints(f.way) AS p FROM '...
        ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f) AS g'];

% , (g.p).path[1], (g.p).path[2]    

result = getFileOrQuery(['./cache/boundary-' place], query);