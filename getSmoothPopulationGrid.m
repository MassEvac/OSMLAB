function [smoothPopulationGrid,longitude,latitude] = getSmoothPopulationGrid(place,gridSize,sigma)
% Retrieves, transforms into a population count bitmap matrix of a given place
% and smoothens the matrix by sigma
% INPUT:
%           place (String) - name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
%           sigma (Integer) - standard deviation to blur the population
%               data by using Gaussian distribution
% OUTPUT:
%           smoothPopulationGrid(i,j) (Double) - smoothened population bitmap matrix
%           longitude(i,j) (Double) - longitude value matrix of the bitmap
%               value in smoothPopulationGrid(i,j) in degrees
%           latitude(i,j) (Double) - latitude value matrix of the bitmap
%               value in smoothPopulationGrid(i,j) in degrees

boundary = getBoundary(place);
[height,width,x_lon,x_lat,u_lon,u_lat]=getGridParameters(boundary,gridSize);
[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(boundary);
% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

population = getPopulation(place);

populationGrid = zeros(x_lat,x_lon);
% get the population for each of the gridcell and normalise the population
for i = 1:x_lon,
    for j = 1:x_lat,
        l1 = (min_lon + i * u_lon); % Longitude
        l2 = (max_lat - j * u_lat); % Latitude
        longitude(j,i) = l1;
        latitude(j,i) = l2;
        ldiff = abs(population(:,2) - l2) .* abs(population(:,1) - l1);
        [~, array_position] = min(ldiff);
        % testPopulation(l1, l2, population, array_position);
        % a = [a; l1 l2 p4(array_position,3)];
        populationGrid(j,i) = round(haversine_area(l1,l2,u_lon,u_lat)/10^6 * population(array_position,3));
        % Population in the database is in terms of person/km^2. times by
        % area in km^2 to get the exact number of people in each square
    end
end

[smoothPopulationGrid, ~] = gsmooth2(populationGrid, sigma, 'same');