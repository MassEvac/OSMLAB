function [populationGrid] = getPopulationGrid(place,gridSize,sigma)
% Returns the population count bitmap matrix of a given place with input attributes
%
% DETAIL:
%           Retrieves, transforms into a population count bitmap matrix of
%           a given place and smoothens the matrix by sigma
% INPUT:
%           place (String) - name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           populationGrid(i,j) (Double) - population bitmap matrix

[x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat] = getGridParameters(place,gridSize);
[longitude, latitude] = getGridCoordinates(place, gridSize);

% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

population = getPopulation(place);

populationGrid = zeros(x_lat,x_lon);
% get the population for each of the gridcell and normalise the population
for j = 1:x_lon,
    for i = 1:x_lat,
        % Calculate the difference between required population data
        % centroid and all available population data centroids
        ldiff = abs(population(:,2) - latitude(i,j)) .* abs(population(:,1) - longitude(i,j));
        % Find the index of the nearest population data centroid
        [~, array_position] = min(ldiff);
        % Use the following test routine to check the distance
        %   testPopulation([thisLongitude thisLatitude], population(array_position,1:2));
        % Stores the value in the matrix as population count by multiplying
        % the population density by the area of the grid cell being considered
        populationGrid(i,j) = round(haversineArea(longitude(i,j),latitude(i,j),u_lon,u_lat)/10^6 * population(array_position,3));
        % Population in the database is in terms of person/km^2. times by
        % area in km^2 to get the exact number of people in each square
    end
end

[populationGrid, ~] = gsmooth2(populationGrid, sigma, 'same');