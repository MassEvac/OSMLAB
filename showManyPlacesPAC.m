function showManyPlacesPAC(amenityTags, places, gridSize, sigma, saveFigures)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{j} (String Cell) - Names of polygon areas in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showManyPlacesPAC({'bar','atm','hospital'},{'London','Bristol'},400,2,true)

if (nargin < 5)
    saveFigures = false;
end

manyPAC = getManyPlacesPAC(amenityTags, places, gridSize, sigma);
figure;
imagesc(manyPAC);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')))
set(gca,'YTick',1:length(places),'YTickLabel',places)
xlabel('Amenity');
ylabel('Place');
colorbar;

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/image-manyPlacesPAC.pdf']);
end