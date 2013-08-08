function showManyPlacesPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted, saveFigures)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{j} (String Cell) - Names of polygon areas in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showManyPlacesPopulationAmenityCorrelation({'bar','atm','hospital'},{'Bristol','London'},250,1,true,true)

if (nargin < 6)
    saveFigures = false;
end

manyPlacesPopulationAmenityCorrelation = getManyPlacesPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted);
figure;
imagesc(manyPlacesPopulationAmenityCorrelation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags))
set(gca,'YTick',1:length(places),'YTickLabel',places)
colorbar;

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/image-manyPlacesPopulationAmenityCorrelation.pdf']);
end