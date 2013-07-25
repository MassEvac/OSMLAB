function testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat)
% Prints the longitudinal and latitudinal size (in metres) of corner grid cells
%
% INPUT:
%           mat_lon (Double) - Most eastern longitude in degrees
%           max_lat (Double) - Most northern latitude in degrees
%           min_lon (Double) - Most western longitude in degrees
%           min_lat (Double) - Most southern latitude in degrees
%           u_lon (Double) - Longitudinal unit grid size in degrees
%           u_lat (Double) - Latitudinal unit grid size in degrees
% OUTPUT (Printed Only):
%           [tdist_lon (Double) tdist_lat (Double)] - Size of top grid
%               cell in metres
%           [bdist_lon (Double) bdist_lat (Double)] - Size of bottom grid
%               cell in metres
   
tdist_lon = haversine([(max_lon) (max_lon)] , [(max_lat) (max_lat + u_lat)]);
tdist_lat = haversine([(max_lon) (max_lon + u_lon)] , [(max_lat) (max_lat)]);
bdist_lon = haversine([(min_lon) (min_lon)] , [(min_lat) (min_lat - u_lat)]);
bdist_lat = haversine([(min_lon) (min_lon + u_lon)] , [(min_lat) (min_lat)]);

disp('The dimension of the top left cell and the bottom right cell is:');
disp ([ tdist_lon tdist_lat ; bdist_lon bdist_lat ]);