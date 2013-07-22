function showWardData(place)
% Gets the list of ward data and shows a graphical plot of the trips
% Eventually need to get it to filter a place
%
% INPUT: (Eventually)
%           place (String) - name of an area polygon in OpenSteetMap
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