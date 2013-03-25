function [r,s] = query(t1,t2,place)

if ~exist('queried','var')
    queried = 0;
end

% clear;

if (nargin < 3)
    t1 = 'bar';
    t2 = 'atm';
    place = 'Cardiff';
end

q1 = ['SELECT DISTINCT ST_X(p.way), ST_Y(p.way) '...
    'FROM planet_osm_point AS p, '...
    '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS q '...
    'WHERE (p.amenity=''' t1 ''' OR p.tags ? ''' t1 ''') AND ST_Intersects(p.way, q.way)'];

q2 = ['SELECT DISTINCT ST_X(p.way), ST_Y(p.way) '...
    'FROM planet_osm_point AS p, '...
    '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS q '...
    'WHERE (p.amenity=''' t2 ''' OR p.tags ? ''' t2 ''') AND ST_Intersects(p.way, q.way)'];

q3 = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom) '...
    'FROM '...
    '(SELECT ST_DumpPoints(f.way) AS p FROM '...
    ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f) AS g'];

% (g.p).path[1],(g.p).path[2], ;

if (~queried)
    p1 = cell2mat(importDB(q1));    
    p2 = cell2mat(importDB(q2));        
    p3 = cell2mat(importDB(q3));        
    queried = 1;
end    


% longitude is (:,1)
% latitude  is (:,2)

max1 = max(p3(:,1));
max2 = max(p3(:,2));
min1 = min(p3(:,1));
min2 = min(p3(:,2));

% delta of min and max longitudes
d1 = max1 - min1;
% delta of min and max latitudes of the map
d2 = max2 - min2;

% level of detail in longitudinal direction
x1 = 100;
% level of detail in latitudinal direction calculated as a round off of the
% proportion of the map.
x2 = round (x1* (d2 / d1));

% size of each unit cell
u1 = d1 / x1;
u2 = d2 / x2;

% create empty matrices with zeroes to count the number of amenities that
% fall within the each of the grid
a1 = zeros(x2,x1);
a2 = zeros(x2,x1);

% number of each of the amenities
[n1,~]=size(p1);
[n2,~]=size(p2);

for i = 1:n1,
    g2 = ceil((p1(i,1) - min1)/u1);
    g1 = ceil((max2 - p1(i,2))/u2);
    a1(g1,g2) = a1(g1,g2) + 1;
end

for i = 1:n2,
    g2 = ceil((p2(i,1) - min1)/u1);
    g1 = ceil((max2 - p2(i,2))/u2);
    a2(g1,g2) = a2(g1,g2) + 1;
end

% standard deviation to use
stdev = 1;

[a1s, reg] = gsmooth2(a1, stdev);
[a2s, reg] = gsmooth2(a2, stdev);

f1 = figure;
fname = [place ' x ' t1 ' o ' t2];
set(f1,'name',fname,'numbertitle','off')

hold on;
% % Map
% subplot(2,2,1);
% plot(p1(:,1),p1(:,2),'x','Color','blue');
% plot(p2(:,1),p2(:,2),'o','Color','red');
% plot(p3(:,1),p3(:,2),'.','Color','green');
% xlabel('longitude'); ylabel('latitude'); axis([min1 max1 min2 max2]);
% 
% % Correlation
% [R,S] = corrcoef(a1s,a2s);
% r = R(1,2);
% s = S(1,2);
% subplot(2,2,2); imagesc(R); colorbar;

% Point of interest 1
colormap(gray);
subplot(1,2,1); imagesc(a1s); xlabel(t1);

% Point of interest 2
colormap(gray);
subplot(1,2,2); imagesc(a2s); xlabel(t2);

% Save the figure as pdf
saveas(f1,[fname '.pdf'],'pdf');