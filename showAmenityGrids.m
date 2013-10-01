function showAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures)
% Shows image of amenities of a given place with the required attributes
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of amenities of a given place with the input attributes
% EXAMPLE:
%           showAmenityGrids({'fuel'},'London',400,0,true,true)

if (nargin < 6)
    saveFigures = false;
end

amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);

n = length(amenityTags);

for i=1:n
    figure;

    imagesc(amenityGrids{i});
    colorbar;
    xlabel('West-East Cell Units');
    ylabel('North-South Cell Units');
    set(gcf,'name',[ place ' ' upper(strrep(amenityTags{i}, '_', ' ')) ],'numbertitle','off')

    if saveFigures
        set(gcf,'Position', [0, 0, 800, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/point_analysis/image-amenityGrid-' place '-' amenityTags{i} '-gridSize-' num2str(gridSize) '-sigma-' num2str(sigma) '.pdf']);
    end    
end

