function showAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures)
% Shows image of the correlation between amenities of a given place with input attributes
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of the correlation between amenities of a given place with input attributes
% EXAMPLE:
%           showAmenityCorrelation({'atm','police'},'Bristol',250,1,true,true)

amenityCorrelation = getAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted);

% Make the diagonal zero so that the other correlations appear clearly
amenityCorrelation(eye(size(amenityCorrelation))~=0) = 0;

figure;

imagesc(amenityCorrelation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')))
set(gca,'YTick',1:length(amenityTags),'YTickLabel',upper(strrep(amenityTags, '_', ' ')))
xlabel('Amenity');
ylabel('Amenity');
colorbar;

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/image-amenityCorrelation-' place '.pdf']);
end