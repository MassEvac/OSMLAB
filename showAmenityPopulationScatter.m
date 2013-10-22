function showAmenityPopulationScatter(amenityTag,place, gridSize, sigma, saveFigures)
% Shows the correlation between amenity count and population count
%
% INPUT:
%           amenityTag (String) - Name of the amenities to consider
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph
% EXAMPLE:
%           showAmenityPopulationScatter('police','London',400,2,true)

populationWeighted = false;

pg = getPopulationGrid(place, gridSize, sigma);
AG = getAmenityGrids({amenityTag},place,gridSize,sigma,populationWeighted); %Not population weighted;
ag = AG{1};
figure;
scatter(pg(:),ag(:));
corrcoef(pg,ag);

xlabel('Population Count');
ylabel('Amenity Count');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/scatter-populationVsAmenity-' amenityTag '-' place '-' num2str(gridSize) '-' num2str(sigma) '.pdf']);
end    