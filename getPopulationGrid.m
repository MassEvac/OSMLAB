function [populationGrid] = getPopulationGrid(place,gridSize,sigma,averageArea,interpolationMethod)
% Returns the population count bitmap matrix of a given place with input attributes
%
% DETAIL:
%           Retrieves, transforms into a population count bitmap matrix of
%           a given place and smoothens the matrix by sigma
% INPUT:
%           place (String) - name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           averageArea (Boolean) - Use the average area of grid cell
%              (Default: TRUE)
%           interpolationMethod (String) - can be bicubic, bilinear, box, nearest
% OUTPUT:
%           populationGrid(i,j) (Double) - population bitmap matrix
% EXAMPLE:
%           [populationGrid] = getPopulationGrid('London',400,0)

if ~exist('averageArea','var')
    averageArea = true;
end     

if ~exist('interpolationMethod','var')
    interpolationMethod = 'bicubic';    
end    

%% Read Data
[x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat] = getGridParameters(place,gridSize);
[longitude, latitude] = getGridCoordinates(place, gridSize);

% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

population = getPopulation(place);

% 2.5 arc minutes = 0.0416666667 degrees.
unitCell = 0.0416666667;

% Work out the extent
% Includes an extra unitCell/2 because the measure is from centre to centre
% The longitude and latitudes in population(:,1:2) are the centroids
% (+/-)unitCell/2 accounts for the extent of the grid cells
max_pop_lon=max(population(:,1))+unitCell/2;
min_pop_lon=min(population(:,1))-unitCell/2;
max_pop_lat=max(population(:,2))+unitCell/2;
min_pop_lat=min(population(:,2))-unitCell/2;

% Measures the magnitute of the raster map extent
l_lon = max_pop_lon-min_pop_lon;
l_lat = max_pop_lat-min_pop_lat;

% Count of number of cells required to represent the raster map
n_lon = ceil(l_lon/unitCell);
n_lat = ceil(l_lat/unitCell);

% Specify the dimension as we have just worked out
populationDensityGrid = zeros(n_lat,n_lon);

% Allocate the values to the matrix
[p,q]=size(population);
for j = 1:p,
    gridX = ceil((max_pop_lat - population(j,2))/unitCell);
    gridY = ceil((population(j,1) - min_pop_lon)/unitCell);
    populationDensityGrid(gridX,gridY) = population(j,3);
end

% close all;
% figure;
% plot3k(population);
% view(2);
% figure;
% imagesc(populationDensityGrid);

% Convert the raster map to the same resolution to the required resolution
r_lon = ceil(l_lon/u_lon);
r_lat = ceil(l_lat/u_lat);

% Resize the population grid so that it is the same resolution as the 
% resolution required by the input gridsize
resizedPopulationDensityGrid=imresize(populationDensityGrid,[r_lat r_lon],interpolationMethod);

% Determine the start of crop point
min_x = ceil((max_pop_lat - max_lat)/u_lat);
min_y = ceil((min_lon - min_pop_lon)/u_lon);

% Indices of areas of crop
i_x = min_x:(min_x+x_lat-1);
i_y = min_y:(min_y+x_lon-1);

% Crop the population density grid
croppedPopulationDensityGrid = resizedPopulationDensityGrid(i_x,i_y);

% figure;
% imagesc(croppedPopulationDensityGrid);
% colorbar;

% Calculate the average area in advance to speed up the calculation
thisArea = haversineArea(mean(longitude(:))-u_lon/2,mean(latitude(:))-u_lat/2,u_lon,u_lat)/10^6;

%% Convert to population count

populationGrid = zeros(x_lat,x_lon);

% Switch on this area calculation when you are not near the poles to speed up calcs.
% Precalculated average area is normally adequate.
if averageArea
    populationGrid = croppedPopulationDensityGrid * thisArea;
else
    for j = 1:x_lon,
        for i = 1:x_lat,
            thisArea = haversineArea(longitude(i,j)-u_lon/2,latitude(i,j)-u_lat/2,u_lon,u_lat)/10^6;

            % Use the following test routine to check the distance
            %   testPopulation([thisLongitude thisLatitude], population(array_position,1:2));

            % Stores the value in the matrix as population count by multiplying
            % the population density by the area of the grid cell being considered
            % Population in the database is in terms of person/km^2. times by
            % area in km^2 to get the exact number of people in each square
            populationGrid(i,j) = round(thisArea * croppedPopulationDensityGrid(i,j));
        end
    end    
end

[populationGrid, ~] = gsmooth2(populationGrid, sigma, 'same');