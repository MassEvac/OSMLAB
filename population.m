place = 'London';

q3 = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom) '...
    'FROM '...
    '(SELECT ST_DumpPoints(f.way) AS p FROM '...
    ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f) AS g'];

q4 = ['SELECT ST_Raster2WorldCoordX(p.rast, x) AS wx, ST_Raster2WorldCoordY(p.rast,y) AS wy, ST_Value(p.rast, x, y) as v '...
      'FROM population AS p, '...
      '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f '...
      'CROSS JOIN generate_series(1, 10) As x '...
      'CROSS JOIN generate_series(1, 10) As y '...
      'WHERE ST_Intersects(p.rast,f.way)'];

% SELECT q FROM (SELECT ST_Intersection(p.way, r.rast) AS raster FROM population as r, planet_osm_polygon AS p WHERE p.name = 'London') AS q;
  
% -3.117 51.417, -3.118 51.418

p3 = cell2mat(importDB(q3));

p4 = cell2mat(importDB(q4));

X = p4(:,1);
Y = p4(:,2);
Z = p4(:,3);

hold on;
plot3k([X,Y,Z]);
p3(:,3) = max(Z);
plot(p3(:,1), p3(:,2),'.');