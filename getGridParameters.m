function [height,width,x_lon,x_lat,u_lon,u_lat]=getGridParameters(boundary,gridSize)

[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(boundary);

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