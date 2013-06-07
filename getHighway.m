function [result] = getHighway(place,varargin)

% motorway, motorway_link
% trunk, trunk_link
% primary, primary_link
% secondary, secondary_link
% tertiary, tertiary_link
% residential, unclassified, road
% pedestrian, service, footway, path
% living_street
% raceway
% track, bridleway
% platform
% proposed, construction

% also option for tunnel = 'yes'
% http://wiki.openstreetmap.org/wiki/Key:highway

highwayClass{1} = {'motorway' 'motorway_link'};
highwayClass{2} = {'trunk' 'trunk_link'};
highwayClass{3} = {'primary' 'primary_link'};
highwayClass{4} = {'secondary' 'secondary_link'};
highwayClass{5} = {'tertiary' 'tertiary_link'};
highwayClass{6} = {'residential' 'unclassified' 'road' 'bus_guideway' 'living_street'};
highwayClass{7} = {'pedestrian' 'service' 'footway' 'path' 'cycleway' 'steps' };

highways = [];
highwayType = [];

% limitation of 7 types of roads
for i = 1:7
    try
        highways = [highways highwayClass{i}];
        highwayType = [highwayType repmat(i,1,length(highwayClass{i}))];
    catch err
        %
    end
end

query = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom), (g.p).path[1], g.q '...
        'FROM ('...
        ' SELECT 1 AS edge_id, ST_DumpPoints(r.way) AS p, r.highway AS q '...
        ' FROM '...
        ' planet_osm_line AS r, ('...
        '  SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1'...
        ' ) AS s '...
        ' WHERE highway <> '''' AND ST_Intersects(r.way, s.way)'...
        ') AS g'];

result = getFileOrQuery(['./cache/highway-' place], query,'highway',highways, highwayType);