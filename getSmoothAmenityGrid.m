function [result] = getSmoothAmenityGrid(amenityTags, place, gridSize, sigma)

boundary = getBoundary(place);
[height,width,x_lon,x_lat,u_lon,u_lat]=getGridParameters(boundary,gridSize);
[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(boundary);
% testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat);

[~, n] = size(amenityTags);
result = [];

for i=1:n
    amenity = getAmenity(amenityTags{i}, place);
    % create empty matrices with zeroes to count the number of amenities that
    % fall within the each of the grid
    amenity_grid = zeros(x_lat,x_lon);
    % number of each of the amenities
    [n,~]=size(amenity);
    for i = 1:n,
        g1 = ceil((amenity(i,1) - min_lon)/u_lon);
        g2 = ceil((max_lat - amenity(i,2))/u_lat);
        amenity_grid(g2,g1) = amenity_grid(g2,g1) + 1;
    end

    % smoothen the grid
    [smoothAmenityGrid, ~] = gsmooth2(amenity_grid, sigma, 'same');
    result = [result {smoothAmenityGrid}];
end