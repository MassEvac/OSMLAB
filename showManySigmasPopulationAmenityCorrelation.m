function showManySigmasPopulationAmenityCorrelation(amenityTags, places, gridSize, sigmas, populationWeighted, saveFigures)
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
%           showManySigmasPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',300,[1:10],true)

if (nargin < 6)
    saveFigures = false;
end

for i = 1:length(places)
    place = places{i};
    
    [manySigmasPopulationAmenityCorrelation] = getManySigmasPopulationAmenityCorrelation(amenityTags, place, gridSize, sigmas, populationWeighted);
    a = manySigmasPopulationAmenityCorrelation';
    b = bsxfun(@rdivide, a,a(1,:));
    unitManySigmasPopulationAmenityCorrelation = b';

    %%
    figure;
    imagesc(1,sigmas,manySigmasPopulationAmenityCorrelation,[-1 1]);
    set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')));
    xlabel('Amenity');
    ylabel('Sigma');
    colorbar;

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/image-manySigmasPopulationAmenityCorrelation-' place '.pdf']);
    end

    %%
    figure;
    plot(sigmas, manySigmasPopulationAmenityCorrelation);
    legend(upper(strrep(amenityTags, '_', ' ')));

    xlabel('Sigma');
    ylabel('Population Amenity Correlation Coefficient');

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/corr-manySigmasPopulationAmenityCorrelation-' place '.pdf']);
    end

    %%
    figure;
    plot(sigmas, unitManySigmasPopulationAmenityCorrelation);
    legend(upper(strrep(amenityTags, '_', ' ')));
    xlabel('Sigma');
    ylabel(['Correlation Coefficient / ' upper(strrep(amenityTags{1}, '_', ' ')) ' CorrCoef']);

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/corr-unitManySigmasPopulationAmenityCorrelation-' place '.pdf']);
    end

end