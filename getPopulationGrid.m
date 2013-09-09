function [populationGrid] = getPopulationGrid(place,gridSize,sigma, averageArea)
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
% OUTPUT:
%           populationGrid(i,j) (Double) - population bitmap matrix
% EXAMPLE:
%           [populationGrid] = getPopulationGrid('Bristol',250,1)

if nargin < 4
    averageArea = true;
end

%% Read Data
[x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat] = getGridParameters(place,gridSize);
[longitude, latitude] = getGridCoordinates(place, gridSize);

% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

population = getPopulation(place);

populationGrid = zeros(x_lat,x_lon);

% 2.5 arc minutes = 0.0416666667 degrees.
halfCell = 0.0416666667/2;

% Calculate the average area in advance to speed up the calculation
thisArea = haversineArea(mean(longitude(:))-u_lon/2,mean(latitude(:))-u_lat/2,u_lon,u_lat)/10^6;

%% Start gridding process
% get the population for each of the gridcell and normalise the population
for j = 1:x_lon,
    for i = 1:x_lat,
        % Calculate the difference between required population data
        % centroid and all available population data centroids
        % ldiff = abs(population(:,2) - latitude(i,j)) .* abs(population(:,1) - longitude(i,j));
        % Find the index of the nearest population data centroid
        % [~, array_position] = min(ldiff);
        % thisPopulation = population(array_position,3);
        
        % Calculate the distance from the centroid in both x and y direction
        dlon = abs(population(:,1) - longitude(i,j));
        dlat = abs(population(:,2) - latitude(i,j));
        % Find the points whose distance from the centroid is less than the
        % half the arc length of each pixel of the raster population data
        plon = find(dlon<=halfCell);
        plat = find(dlat<=halfCell);
        
        thisPopulation = 0;
        
        if plon
            thisPopulation = thisPopulation + sum(population(plon,3))/length(plon);
        end
        
        if plat
            thisPopulation = thisPopulation + sum(population(plat,3))/length(plat);
        end
        
        % Switch off this area calculation when you are not near the poles to speed up calcs.
        % Precalculated average area is adequate.
        
        if ~averageArea
            thisArea = haversineArea(longitude(i,j)-u_lon/2,latitude(i,j)-u_lat/2,u_lon,u_lat)/10^6;
        end
        
        % Use the following test routine to check the distance
        %   testPopulation([thisLongitude thisLatitude], population(array_position,1:2));

        % Stores the value in the matrix as population count by multiplying
        % the population density by the area of the grid cell being considered
        % Population in the database is in terms of person/km^2. times by
        % area in km^2 to get the exact number of people in each square
        populationGrid(i,j) = round(thisArea * thisPopulation);
    end
end

[populationGrid, ~] = gsmooth2(populationGrid, sigma, 'same');