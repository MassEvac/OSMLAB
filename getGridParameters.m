function [x_lon,x_lat,u_lon,u_lat,max_lon,max_lat,min_lon,min_lat]=getGridParameters(place,gridSize)
% Returns the parameters of a grid of the given place for a given grid size
%
% INPUT:
%           place (String) - Name of an area polygon in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
% OUTPUT:
%           x_lon (Integer) - Number of cells in longitudinal direction
%           x_lat (Integer) - Number of cells in latitudinal direction
%           u_lon (Double) - Longitudinal unit grid size in degrees
%           u_lat (Double) - Latitudinal unit grid size in degrees
%           mat_lon (Double) - Most eastern longitude in degrees
%           max_lat (Double) - Most northern latitude in degrees
%           min_lon (Double) - Most western longitude in degrees
%           min_lat (Double) - Most southern latitude in degrees

[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(place);

% calculate the height and width of the bounding box
height = haversine([(max_lon) (max_lon)] , [(max_lat) (min_lat)]);
twidth = haversine([(max_lon) (min_lon)] , [(max_lat) (max_lat)]);
bwidth = haversine([(max_lon) (min_lon)] , [(min_lat) (min_lat)]);
width = (twidth + bwidth) / 2;

% number of cells in longitudinal and latitudinal direction
x_lon = round (width  / gridSize);
x_lat = round (height / gridSize);

% delta of min and max longitudes
d_lon = max_lon - min_lon;
d_lat = max_lat - min_lat;

% size of each unit cell in degrees
u_lon = d_lon / x_lon;
u_lat = d_lat / x_lat;