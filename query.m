%function [r,s,x1,x2] = query(t1,t2,place)

if ~exist('queried','var')
    queried = 0;
end

% clear;

nargin = 0;

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

q4 = ['SELECT (ST_Raster2WorldCoordX(p.rast, x) + ST_ScaleX(rast) / 2) AS wx, (ST_Raster2WorldCoordY(p.rast,y) + ST_ScaleY(rast) / 2) AS wy, ST_Value(p.rast, x, y) as v '...
      'FROM population AS p, '...
      '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f '...
      'CROSS JOIN generate_series(1, 50) As x '...
      'CROSS JOIN generate_series(1, 50) As y '...
      'WHERE ST_Intersects(p.rast,f.way)'];  
  
% (g.p).path[1],(g.p).path[2], ;

if (~queried)
    p1 = cell2mat(importDB(q1));    
    p2 = cell2mat(importDB(q2));        
    p3 = cell2mat(importDB(q3));
    p4 = cell2mat(importDB(q4));
    queried = 1;
end    


% longitude is (:,1)
% latitude  is (:,2)

max1 = max(p3(:,1));
max2 = max(p3(:,2));
min1 = min(p3(:,1));
min2 = min(p3(:,2));

% calculate the height and width of the bounding box
height = haversine([(max2) (min2)] , [(max1) (max1)]);
twidth = haversine([(max2) (max2)] , [(max1) (min1)]);
bwidth = haversine([(min2) (min2)] , [(max1) (min1)]);
width = (twidth + bwidth) / 2;

% specify gridsize in metres
gridsize = 100;

% number of cells in longitudinal and latitudinal direction
x1 = round (width  / gridsize);
x2 = round (height / gridsize);

% disp('The grid size is:');
% disp([x1 x2]);

% delta of min and max longitudes
d1 = max1 - min1;
% delta of min and max latitudes of the map
d2 = max2 - min2;

% size of each unit cell in degrees
u1 = d1 / x1;
u2 = d2 / x2;

% % give the approximate grid cell size of the top left corner 
% % and the bottom right corner
% tdist1 = haversine([(max2) (max2 + u2)] , [(max1) (max1)]);
% tdist2 = haversine([(max2) (max2)] , [(max1) (max1 + u1)]);
% bdist1 = haversine([(min2) (min2 - u2)] , [(min1) (min1)]);
% bdist2 = haversine([(min2) (min2)] , [(min1) (min1 + u1)]);
% 
% disp('The dimension of the top left cell and the bottom right cell is:');
% disp ([ tdist1 tdist2 ; bdist1 bdist2 ]);

% create empty matrices with zeroes to count the number of amenities that
% fall within the each of the grid
a1 = zeros(x2,x1);
a2 = zeros(x2,x1);
pop = zeros(x2,x1);

% number of each of the amenities
[n1,~]=size(p1);
[n2,~]=size(p2);

% get the population for each of the gridcell and normalise the population
for i = 1:x1,
    for j = 1:x2,
        l1 = (min1 + i * u1); % Longitude
        l2 = (max2 - j * u2); % Latitude
        ldiff = abs(p4(:,2) - l2) .* abs(p4(:,1) - l1);
        [min_difference, array_position] = min(ldiff);
%         disp(haversine([l2 p4(array_position,2)],[l1 p4(array_position,1)]));
%         disp([l1 l2]);
%         disp('corresponds to:');
%         disp([p4(array_position,1) p4(array_position,2)]);
%        a4 = [a4; l1 l2 p4(array_position,3)];
        pop(j,i) = round(haversine_area(l1,l2,u1,u2)/10^6 * p4(array_position,3));
    end
end    

for i = 1:n1,
    g1 = ceil((p1(i,1) - min1)/u1);
    g2 = ceil((max2 - p1(i,2))/u2);   
    a1(g2,g1) = a1(g2,g1) + 1 / pop(g2,g1);
end

for i = 1:n2,
    g1 = ceil((p2(i,1) - min1)/u1);
    % i=(longitude - minumumlongitude)/unitlongitude
    % minumumlongitude + i*unitlongitude = longitude
    g2 = ceil((max2 - p2(i,2))/u2);
    % j=(maximumlatitude - latitude)/unitlatitude
    % maximumlatitude - j*unitlatitude = latitude
    a2(g2,g1) = a2(g2,g1) + 1 / pop(g2,g1);
end

% standard deviation to use
stdev = 1;

%divide by population

[a1s, reg] = gsmooth2(a1, stdev);
[a2s, reg] = gsmooth2(a2, stdev);
[pops, reg] = gsmooth2(pop, stdev);


f1 = figure;
fname = [place ' x ' t1 ' o ' t2];
set(f1,'name',fname,'numbertitle','off')

colormap(gray);

% Point of interest 1
subplot(2,2,1); imagesc(a1s); xlabel(t1);

% Point of interest 2
subplot(2,2,2); imagesc(a2s); xlabel(t2);

% Population
subplot(2,2,3); imagesc(pops); xlabel('population');

% Map
subplot(2,2,4);
hold on;
plot(p1(:,1),p1(:,2),'x','Color','blue');
plot(p2(:,1),p2(:,2),'o','Color','red');
plot(p3(:,1),p3(:,2),'.','Color','green');
xlabel('longitude'); ylabel('latitude'); axis([min1 max1 min2 max2]);

% Save the figure as pdf
saveas(f1,[fname '.pdf'],'pdf');

[r,s] = corrcoef([a1s(:),a2s(:),pops(:)]);