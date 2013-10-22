function showPopulationVsGridSize(place, gridSizes, sigma, saveFigures)
% Shows a box plot which describes how gridSize affects population accuracy
%
% INPUT:
%           place (String) - Name of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Box plot which describes how gridSize affects population accuracy
% EXAMPLE:
%           showPopulationVsGridSize('London', [100:100:4000], 2, true);

interpolationMethods = {'bicubic' 'bilinear' 'box' 'nearest'};
averageArea = true;

for i = 1:length(interpolationMethods)

    g = length(gridSizes);
    population = zeros(1,g);

    for j = 1:g
        pg = getPopulationGrid(place, gridSizes(j), sigma,averageArea,interpolationMethods{i});
        population(j) = sum(pg(:));
    end

    x = gridSizes;
    y = 100*(population/mean(population)-1);
    e = std(y) * ones(1,g);

    figure;
    errorbar(x,y,e);

    xlabel('Gridcell Size (metres)');
    ylabel('(P/P(average)) - 1) %');

    if saveFigures
        set(gcf,'Position', [0, 0, 400, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/point_analysis/plot-population-vs-gridSize-' interpolationMethods{i} '-sigma-' num2str(sigma) '-' place '.pdf']);
    end
end