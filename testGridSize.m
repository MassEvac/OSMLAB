function testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat)
% Gives the longitudinal and latitudinal size (in metres) of a grid from the
% coordinates of the corners
% INPUT:
%           mat_lon (Double) - Most eastern longitude in degrees
%           max_lat (Double) - Most northern latitude in degrees
%           min_lon (Double) - Most western longitude in degrees
%           min_lat (Double) - Most southern latitude in degrees
%           u_lon (Double) - Longitudinal unit grid size in degrees
%           u_lat (Double) - Latitudinal unit grid size in degrees
% OUTPUT (Printed Only):
%           tdist_lon (Double) - Longitudinal size of top grid in metres
%           tdist_lat (Double) - Latitudinal size of top grid in metres
%           bdist_lon (Double) - Longitudinal size of bottom grid in metres
%           bdist_lat (Double) - Latitudinal size of bottom grid in metres
            
tdist_lon = haversine([(max_lat) (max_lat + u_lat)] , [(max_lon) (max_lon)]);
tdist_lat = haversine([(max_lat) (max_lat)] , [(max_lon) (max_lon + u_lon)]);
bdist_lon = haversine([(min_lat) (min_lat - u_lat)] , [(min_lon) (min_lon)]);
bdist_lat = haversine([(min_lat) (min_lat)] , [(min_lon) (min_lon + u_lon)]);

disp('The dimension of the top left cell and the bottom right cell is:');
disp ([ tdist_lon tdist_lat ; bdist_lon bdist_lat ]);