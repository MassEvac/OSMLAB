%function [r,s,x1,x2] = query(t1,t2,place)

%clear;
nargin = 0;

if (nargin < 3)
    t1 = 'bar';
    t2 = 'atm';
    place = 'Bristol';
end

a1 = getAmenity(t1, place);
a2 = getAmenity(t2, place);

boundary = getBoundary(place);
population = getPopulation(place);

% Now determine the dimension of the grid based on the gridsize specified

% specify gridsize in metres
gridsize = 250;

max_lon = max(boundary(:,1));
max_lat = max(boundary(:,2));
min_lon = min(boundary(:,1));
min_lat = min(boundary(:,2));

% calculate the height and width of the bounding box
height = haversine([(max_lat) (min_lat)] , [(max_lon) (max_lon)]);
twidth = haversine([(max_lat) (max_lat)] , [(max_lon) (min_lon)]);
bwidth = haversine([(min_lat) (min_lat)] , [(max_lon) (min_lon)]);
width = (twidth + bwidth) / 2;

% number of cells in longitudinal and latitudinal direction
x_lon = round (width  / gridsize);
x_lat = round (height / gridsize);

% delta of min and max longitudes
d_lon = max_lon - min_lon;
d_lat = max_lat - min_lat;

% size of each unit cell in degrees
u_lon = d_lon / x_lon;
u_lat = d_lat / x_lat;

% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

% Now place the population and amenities in the appropriate grid

% create empty matrices with zeroes to count the number of amenities that
% fall within the each of the grid
grid_a1 = zeros(x_lat,x_lon);
grid_a2 = zeros(x_lat,x_lon);
grid_pop = zeros(x_lat,x_lon);

% get the population for each of the gridcell and normalise the population
for i = 1:x_lon,
    for j = 1:x_lat,
        l1 = (min_lon + i * u_lon); % Longitude
        l2 = (max_lat - j * u_lat); % Latitude
        ldiff = abs(population(:,2) - l2) .* abs(population(:,1) - l1);
        [min_difference, array_position] = min(ldiff);
%         disp(haversine([l2 p4(array_position,2)],[l1 p4(array_position,1)]));
%         disp([l1 l2]);
%         disp('corresponds to:');
%         disp([p4(array_position,1) p4(array_position,2)]);
%        a4 = [a4; l1 l2 p4(array_position,3)];
        grid_pop(j,i) = round(haversine_area(l1,l2,u_lon,u_lat)/10^6 * population(array_position,3));
    end
end    

% number of each of the amenities
[n1,~]=size(a1);
[n2,~]=size(a2);

for i = 1:n1,
    g1 = ceil((a1(i,1) - min_lon)/u_lon);
    g2 = ceil((max_lat - a1(i,2))/u_lat);
    
    this = 1 / grid_pop(g2,g1);
    if (grid_pop(g2,g1) == 0) 
        this = 1;
    end

    grid_a1(g2,g1) = grid_a1(g2,g1) + this;
end

for i = 1:n2,
    g1 = ceil((a2(i,1) - min_lon)/u_lon);
    g2 = ceil((max_lat - a2(i,2))/u_lat);
    
    this = 1 / grid_pop(g2,g1);
    if (grid_pop(g2,g1) == 0)
        this = 1;
    end
    
    grid_a2(g2,g1) = grid_a2(g2,g1) + this;
end

% standard deviation to use
stdev = 2;

%divide by population
[smooth_a1, reg] = gsmooth2(grid_a1, stdev, 'same');
[smooth_a2, reg] = gsmooth2(grid_a2, stdev, 'same');
[pops, reg] = gsmooth2(grid_pop, stdev, 'same');


f1 = figure;
fname = [place '-x-' t1 '-o-' t2];
set(f1,'name',fname,'numbertitle','off')

%colormap(gray);

% ---- 2 x 1 figures

% set(f1,'Position', [0, 0, 800, 300]);
%
% % Point of interest 1
% subplot(1,2,1); imagesc(log(a1s)); xlabel(upper(t1),'FontSize',14); set(gca,'FontSize',14);
% 
% % Point of interest 2
% subplot(1,2,2); imagesc(log(a2s)); xlabel(upper(t2),'FontSize',14); set(gca,'FontSize',14);

% ----- 2 x 2 figures

set(f1,'Position', [0, 0, 800, 600]);

% Point of interest 1
subplot(2,2,1); imagesc(log(smooth_a1)); xlabel(t1,'FontSize',14); set(gca,'FontSize',14);

% Point of interest 2
subplot(2,2,2); imagesc(log(smooth_a2)); xlabel(t2,'FontSize',14); set(gca,'FontSize',14);

% Population
subplot(2,2,3); imagesc(pops); xlabel('population','FontSize',14); set(gca,'FontSize',14);

% Map
subplot(2,2,4);
hold on;
plot(a1(:,1),a1(:,2),'x','Color','blue');
plot(a2(:,1),a2(:,2),'o','Color','red');
plot(boundary(:,1),boundary(:,2),'.','Color','green');
xlabel('longitude','FontSize',14); ylabel('latitude','FontSize',14); axis([min_lon max_lon min_lat max_lat]); set(gca,'FontSize',14); 

% ----

% Save the figure as pdf
savefig([fname '.pdf'],f1,'pdf');

[r,s] = corrcoef([smooth_a1(:),smooth_a2(:),pops(:)]);