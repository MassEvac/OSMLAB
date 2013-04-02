function area=haversine_area(lat,lon,height,width)

height = haversine([lat (lat+height)],[lon lon]);
width = haversine([lat lat],[lon (lon+width)]);

area = height * width;