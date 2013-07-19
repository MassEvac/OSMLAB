function [smoothAmenityGrid] = getSmoothAmenityGrid(amenityTags, place, gridSize, sigma)
% Retrieves, transforms into an amenity count bitmap matrix of a given place
% and smoothens the matrix by sigma
% INPUT:
%           place (String) - name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
%           sigma (Integer) - standard deviation to blur the population
%               data by using Gaussian distribution
% OUTPUT:
%           smoothAmenityGrid(i,j) (Double) - smoothened amenity count bitmap matrix
%           longitude(i,j) (Double) - longitude value matrix of the bitmap
%               value in smoothPopulationGrid(i,j) in degrees
%           latitude(i,j) (Double) - latitude value matrix of the bitmap
%               value in smoothPopulationGrid(i,j) in degrees

boundary = getBoundary(place);
[height,width,x_lon,x_lat,u_lon,u_lat]=getGridParameters(boundary,gridSize);
[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(boundary);
% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

n = length(amenityTags);
smoothAmenityGrid = [];

for i=1:n
    amenity = getAmenity(amenityTags{i}, place);
    % create empty matrices with zeroes to count the number of amenities that
    % fall within the each of the grid
    amenityGrid = zeros(x_lat,x_lon);
    % number of each of the amenities
    [m,~]=size(amenity);
    for i = 1:m,
        g1 = ceil((amenity(i,1) - min_lon)/u_lon);
        g2 = ceil((max_lat - amenity(i,2))/u_lat);
        amenityGrid(g2,g1) = amenityGrid(g2,g1) + 1;
    end

    % smoothen the grid
    [smoothAmenityGrid, ~] = gsmooth2(amenityGrid, sigma, 'same');
    smoothAmenityGrid = [smoothAmenityGrid {smoothAmenityGrid}];
end