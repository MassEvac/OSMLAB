function showManyGridSizesPopulationAmenityCorrelation(amenityTags, places, gridSizes, sigma, populationWeighted, saveFigures)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(j) (Integer Array) - Array of Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?% OUTPUT:
% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showManyGridSizesPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',[100:100:2000],1,true)

if (nargin < 6)
    saveFigures = false;
end

for i = 1:length(places)
    place = places{i};
    
    [manyGridSizesPopulationAmenityCorrelation] = getManyGridSizesPopulationAmenityCorrelation(amenityTags, place, gridSizes, sigma, populationWeighted);
    a = manyGridSizesPopulationAmenityCorrelation';
    b = bsxfun(@rdivide, a,a(1,:));
    unitManyGridSizesPopulationAmenityCorrelation = b';

    %%
    figure;
    imagesc(1,gridSizes,manyGridSizesPopulationAmenityCorrelation,[-1 1]);
    set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')));
    xlabel('Amenity');
    ylabel('Cell Grid Size (metres)');
    colorbar;

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/image-manyGridSizesPopulationAmenityCorrelation-' place '.pdf']);
    end

    %%
    figure;
    plot(gridSizes, manyGridSizesPopulationAmenityCorrelation);
    legend(upper(strrep(amenityTags, '_', ' ')));

    xlabel('Cell Grid Size (metres)');
    ylabel('Population Amenity Correlation Coefficient');

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/corr-manyGridSizesPopulationAmenityCorrelation-' place '.pdf']);
    end

    %%
    figure;
    plot(gridSizes, unitManyGridSizesPopulationAmenityCorrelation);
    legend(upper(strrep(amenityTags, '_', ' ')));
    xlabel('Cell Grid Size (metres)');
    ylabel(['Correlation Coefficient / ' upper(strrep(amenityTags{1}, '_', ' ')) ' CorrCoef']);

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/corr-unitManyGridSizesPopulationAmenityCorrelation-' place '.pdf']);
    end

end