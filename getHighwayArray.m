%function getHighwayArray

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

place = 'Bristol';
highway = 'motorway';

r = getHighway(highway,place);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Highway:' highway ' in ' place];
set(f1,'name',fname,'numbertitle','off');

n = length(r);

first = 1;
for i = 2:n+1
    if (r(i,3) == 1 || i>n)
        last = i - 1;
        hold on;
        plot(r(first:last,1),r(first:last,2),'Color','blue');
        first = i;
    end
    set(gca,'FontSize',14);
end
