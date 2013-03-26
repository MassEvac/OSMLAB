filenames = gunzip('sanfranciscos.dem.gz', tempdir); 
demFilename = filenames{1}; 

[lat, lon,Z] = usgs24kdem(demFilename,2); 

% Delete the temporary gunzipped file. 
delete(demFilename); 

% Move all points at sea level to -1 to color them blue. 
Z(Z==0) = -1;

% Compute the latitude and longitude limits for the DEM. 
latlim = [min(lat(:)) max(lat(:))];
lonlim = [min(lon(:)) max(lon(:))];

% Display the DEM values as a texture map. 
figure
usamap(latlim, lonlim)
geoshow(lat, lon, Z, 'DisplayType','texturemap')
demcmap(Z)
daspectm('m',1)

% Overlay black contour lines onto the texturemap.
geoshow(lat, lon, Z, 'DisplayType', 'contour', ...
  'LineColor', 'black');

figure
usamap(latlim, lonlim)
geoshow(lat, lon, Z, 'DisplayType', 'surface')
demcmap(Z)
daspectm('m',1)
view(3)