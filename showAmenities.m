function showAmenities(amenityTags, place, saveFigures)
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
%           showAmenities({'fuel' 'hospital'},'London',true)
% NOTE:
%           The boundary is more obvious when there are more points to
%           indicate it. Eg. The boundary for London is a lot more obvious
%           than the boundary for Bristol so just be wary of that.

boundary = getBoundary(place);

[max_lon,max_lat,min_lon,min_lat]=getBoundaryLimits(place);

markers = {'.' '+' 'o' '*' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
colours = {'g' 'r' 'b' 'c' 'm' 'y' 'k'};

markerNumber = 1;
colourNumber = 1;

figure;

hold on;
plot(boundary(:,1),boundary(:,2),[colours{colourNumber} markers{markerNumber}]);

for i = 1:length(amenityTags)
    markerNumber = markerNumber + 1;
    colourNumber = colourNumber + 1;

    if markerNumber > length(markers)
        markerNumber = 1;
    end

    if colourNumber > length(colours)
        colourNumber = 1;
    end
    
    amenity = getAmenity(amenityTags{i}, place);
    plot(amenity(:,1),amenity(:,2),[colours{colourNumber} markers{markerNumber}]);
end

legend([place upper(strrep(amenityTags, '_', ' '))],'location','southeast');

axis([min_lon max_lon min_lat max_lat]);
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/plot-' strjoin(amenityTags,'-') '-' place '.pdf']);
end