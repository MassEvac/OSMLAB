function [amenityGrids] = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted)
% Retrieves, transforms into an amenity count bitmap matrix of a given place
% and smoothens the matrix by sigma
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Name of the place to consider
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise amenities by population?
% OUTPUT:
%           smoothAmenityGrid(i,j) (Double) - smoothened amenity count bitmap matrix
%           longitude(i,j) (Double) - longitude value matrix of the bitmap
%               value in smoothPopulationGrid(i,j) in degrees
%           latitude(i,j) (Double) - latitude value matrix of the bitmap
%               value in smoothPopulationGrid(i,j) in degrees
%
if (nargin < 5)
    populationWeighted = false;
end

boundary = getBoundary(place);
[height,width,x_lon,x_lat,u_lon,u_lat]=getGridParameters(boundary,gridSize);
[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(boundary);

% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

n = length(amenityTags);
amenityGrids = [];

for i=1:n
    amenity = getAmenity(amenityTags{i}, place);
    % Create empty matrices with zeroes to count the number of amenities that
    % Fall within the each of the grid
    amenityGrid = zeros(x_lat,x_lon);
    % Number of each of the amenities
    [m,~]=size(amenity);
    for i = 1:m,
        g1 = ceil((amenity(i,1) - min_lon)/u_lon);
        g2 = ceil((max_lat - amenity(i,2))/u_lat);
        amenityGrid(g2,g1) = amenityGrid(g2,g1) + 1;
    end

    % Smoothen the grid by applying gaussian blurring
    [smoothAmenityGrid, ~] = gsmooth2(amenityGrid, sigma, 'same');
    amenityGrids = [amenityGrids {smoothAmenityGrid}];
end

if (populationWeighted)
    populationGrid = getPopulationGrid(place, gridSize, sigma);

    % Number of each of the amenities
    [p, q]=size(populationGrid);
    n = length(amenityGrids);
    result = [];

    for a = 1:n,
        amenityGrid = amenityGrids{a};
        % Create empty matrices with zeroes to count the number of amenities that
        % Fall within the each of the grid
        populationWeightedAmenityGrid = zeros(p,q);
        for i = 1:p,
            for j = 1:q,
                this = amenityGrid(i,j) / populationGrid(i,j);
                if (populationGrid(i,j) == 0) 
                    this = amenityGrid(i,j);
                end   
                populationWeightedAmenityGrid(i,j) = this;
            end
        end
        result = [result {populationWeightedAmenityGrid}];
    end        
end