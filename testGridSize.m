function testGridSize(max_lon,max_lat,min_lon,min_lat,u_lon,u_lat)

tdist_lon = haversine([(max_lat) (max_lat + u_lat)] , [(max_lon) (max_lon)]);
tdist_lat = haversine([(max_lat) (max_lat)] , [(max_lon) (max_lon + u_lon)]);
bdist_lon = haversine([(min_lat) (min_lat - u_lat)] , [(min_lon) (min_lon)]);
bdist_lat = haversine([(min_lat) (min_lat)] , [(min_lon) (min_lon + u_lon)]);

disp('The dimension of the top left cell and the bottom right cell is:');
disp ([ tdist_lon tdist_lat ; bdist_lon bdist_lat ]);