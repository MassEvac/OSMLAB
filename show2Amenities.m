function show2Amenities(amenityTag1, amenityTag2, place, saveFigures)
% Returns amenity count bitmap matrix of a given place with input attributes
%
% INPUT:
%           amenityTag1 (String) - Name of the first amenity to consider
%           amenityTag2 (String) - Name of the second amenity to consider
%           place (String) - Name of an area polygon in OpenSteetMap
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Plot of the 2 amenities overlaid on the plot of the boundary 
% EXAMPLE:
%           show2Amenities('fuel','hospital','London',true)
% NOTE:
%           The boundary is more obvious when there are more points to
%           indicate it. Eg. The boundary for London is a lot more obvious
%           than the boundary for Bristol so just be wary of that.

if (nargin < 4)
    saveFigures = false;
end

amenity1 = getAmenity(amenityTag1, place);
amenity2 = getAmenity(amenityTag2, place);
boundary = getBoundary(place);

[max_lon,max_lat,min_lon,min_lat]=getBoundaryLimits(place);

if saveFigures
    figure;
else
    figure('units','normalized','outerposition',[0 0 1 1]);
end

hold on;
plot(amenity1(:,1),amenity1(:,2),'x','Color','blue');
plot(amenity2(:,1),amenity2(:,2),'o','Color','red');
plot(boundary(:,1),boundary(:,2),'.','Color','green');
legend(upper(strrep(amenityTag1, '_', ' ')),upper(strrep(amenityTag2, '_', ' ')),place,'location','southeast');
axis([min_lon max_lon min_lat max_lat]);
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/plot-' amenityTag1 '-' amenityTag2 '-' place '.pdf']);
end