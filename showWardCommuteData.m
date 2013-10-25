function showWardCommuteData(place, saveFigures)
% Show graph of ward commute data
%
% INPUT: (Eventually)
%           place (String) - Name of polygon area in OpenSteetMap
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Graph view of the census data on commuting
% EXAMPLE:
%           showWardCommuteData('Bristol',true)
% NOTE:
%           Eventually need to get it to filter a place

[trips, centroids, wardList] = getWardCommuteData;
try
    figure;
    hold on;
    wgPlot(trips,centroids);
    legend('Ward Trips');
catch err
    %
end

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    savefig(['./figures/graph-wardTrips-' place '.pdf'],'pdf');
end