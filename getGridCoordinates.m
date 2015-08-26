function [lon, lat] = getGridCoordinates (place, gridSize, asMatrix)
% Gets the longitude, latitude coordinates of the grid of a given place
%
% INPUT:
%           place (String) - name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
% OUTPUT:
%           lon(i,j) (Double) - Longitude of the centroid of grid (i,j)
%           lat(i,j) (Double) - Latitude of the centroid of grid (i,j)
% EXAMPLE:
%           [lon, lat] = getGridCoordinates('Bristol', 400)

%%
[x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat] = getGridParameters(place,gridSize);

lon=min_lon+u_lon/2+u_lon*(1:x_lon);
lat=max_lat-u_lat/2-u_lat*(1:x_lat)';

repmat(lon,x_lat,1)

% Output the variables as vector if matrix has not been specifically requested
if exist('asMatrix','var')
    if asMatrix
        lon = repmat(lon,x_lat,1);
        lat = repmat(lat,1,x_lat);
    end
end