% motorway, motorway_link
% trunk, trunk_link
% primary, primary_link
% secondary, secondary_link
% tertiary, tertiary_link
% residential, unclassified, road
% pedestrian, service, footway, path
% living_street
% raceway
% track
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
highwayClass{7} = {'pedestrian' 'service' 'footway' 'path' 'cycleway' 'steps' 'track'  'raceway' 'platform' 'proposed' 'construction' 'bridleway'};

highwayColours = {'yellow' 'magenta' 'cyan' 'red' 'green' 'blue' 'black'};

highways = [];
highwayType = [];

% limitation of 7 types of roads
for i = visibleHighways
    try
        highways = [highways highwayClass{i}];
        highwayType = [highwayType repmat(i,1,length(highwayClass{i}))];
    catch err
        %
    end
end