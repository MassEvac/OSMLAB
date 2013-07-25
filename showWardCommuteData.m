function showWardCommuteData(place)
% Show graph of ward commute data
%
% INPUT: (Eventually)
%           place (String) - Name of polygon area in OpenSteetMap
% OUTPUT:
%           Graph view of the census data on commuting
% NOTE:
%           Eventually need to get it to filter a place

[trips, centroids, wardList] = getWardCommuteData;
try
    figure;
    wgPlot(trips,centroids);
catch err
    %
end