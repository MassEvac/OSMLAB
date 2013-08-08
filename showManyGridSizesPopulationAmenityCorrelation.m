function showManyGridSizesPopulationAmenityCorrelation(amenityTags, place, gridSizes, sigma, populationWeighted, saveFigures)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSizes(j) (Integer Array) - Array of Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showManyGridSizesPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',[50:100:2000],1,true)

if (nargin < 6)
    saveFigures = false;
end

manyPlacesPopulationAmenityCorrelation = getManyGridSizesPopulationAmenityCorrelation(amenityTags, place, gridSizes, sigma, populationWeighted);

figure;
imagesc(manyPlacesPopulationAmenityCorrelation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags))
set(gca,'YTick',1:length(gridSizes),'YTickLabel',gridSizes)
colorbar;

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/image-manyGridSizesPopulationAmenityCorrelation-' place '.pdf']);
end

figure;
plot(manyPlacesPopulationAmenityCorrelation);
legend(upper(amenityTags));
set(gca,'XTick',1:length(gridSizes),'XTickLabel',gridSizes)
xlabel('Cell Grid Size (metres)');
ylabel('Population Amenity Correlation Coefficient');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/corr-manyGridSizesPopulationAmenityCorrelation-' place '.pdf']);
end
