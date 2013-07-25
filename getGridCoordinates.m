function [longitudeGrid, latitudeGrid] = getGridCoordinates (place, gridSize)
% Gets the longitude, latitude coordinates of the grid of a given place
%
% INPUT:
%           place (String) - name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
% OUTPUT:
%           longitude(i,j) (Double) - Longitude of index (i,j) in the grid
%           latitude(i,j) (Double) - Latitude of index (i,j) in the grid
% EXAMPLE:
%           [longitudeGrid, latitudeGrid] = getGridCoordinates ('Bristol', 250)

[x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat] = getGridParameters(place,gridSize);

for j = 1:x_lon,
    for i = 1:x_lat,
        thisLongitude = (min_lon + j * u_lon); % Longitude
        thisLatitude = (max_lat - i * u_lat); % Latitude
        longitudeGrid(i,j) = thisLongitude;
        latitudeGrid(i,j) = thisLatitude;
    end
end