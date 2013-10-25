function [amenityGrids] = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted)
% Returns amenity count bitmap matrix of a given place with input attributes
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Name of an area polygon in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise amenities by population?
% OUTPUT:
%           amenityGrid(i,j) (Double) - Amenity count bitmap matrix
%           longitude(i,j) (Double) - Longitude of amenityGrid(i,j) in degrees
%           latitude(i,j) (Double) - Latitude of amenityGrid(i,j) in degrees
% EXAMPLE:
%           [amenityGrids] = getAmenityGrids({'fuel'},'London',400,0,true)

[x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat]=getGridParameters(place,gridSize);

% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

n = length(amenityTags);
amenityGrids = [];

for i=1:n
    amenity = getAmenity(amenityTags{i}, place);
    % Create empty matrices with zeroes to count the number of amenities that
    % Fall within the each of the grid
    amenityGrid = zeros(x_lat,x_lon);
    % Number of each of the amenities
    % We are using size here instead of length because sometimes the number
    % of amenities may be less than 2 in which case we dont want to confuse
    % the counter j
    [p,q]=size(amenity);
    for j = 1:p,
        gridX = ceil((max_lat - amenity(j,2))/u_lat);
        gridY = ceil((amenity(j,1) - min_lon)/u_lon);
        amenityGrid(gridX,gridY) = amenityGrid(gridX,gridY) + 1;
    end

    % Smoothen the grid by applying gaussian blurring
    [smoothAmenityGrid, ~] = gsmooth2(amenityGrid, sigma, 'same');
    amenityGrids = [amenityGrids {smoothAmenityGrid}];
end

if (populationWeighted)
    disp('Processing result in terms of amenity/person...');
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
                thisPopulationWeightedAmenity = amenityGrid(i,j) / populationGrid(i,j);
                if (populationGrid(i,j) == 0) 
                    thisPopulationWeightedAmenity = amenityGrid(i,j);
                end   
                populationWeightedAmenityGrid(i,j) = thisPopulationWeightedAmenity;
            end
        end
        result = [result {populationWeightedAmenityGrid}];
    end
    amenityGrids = result;
end