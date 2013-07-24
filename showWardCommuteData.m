function showWardCommuteData(place)
% Show graph of ward commute data
%
% Eventually need to get it to filter a place
%
% INPUT: (Eventually)
%           place (String) - Name of polygon area in OpenSteetMap
% OUTPUT:
%           Graph view of the census data on commuting
%
[wardList, centroids, trips] = getWardData;
try
    figure;
    wgPlot(trips,centroids);
catch err
    %
end