function [pOverPAvgMinusOne] = showGridSizeVsPopulation(places, gridSizes, sigma, saveFigures)
% Shows box plots that describes how gridSize affects population accuracy for different methods of interpolation
%
% INPUT:
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Box plot which describes how gridSize affects population accuracy
% EXAMPLE:
%           showGridSizeVsPopulation({'London','Birmingham','Manchester','Bristol'}, [100:100:4000], 2, true);
%%
interpolationMethods = {'bicubic' 'bilinear' 'box' 'nearest'};
averageArea = true;

p = length(places);
n = length(interpolationMethods);
g = length(gridSizes);

pOverPAvgMinusOne = zeros(p,g,n);

for i = 1:p
    for j = 1:n

        g = length(gridSizes);
        population = zeros(1,g);

        for k = 1:g
            pg = getPopulationGrid(places{i}, gridSizes(k),sigma,averageArea,interpolationMethods{j});
            population(k) = sum(pg(:));
        end

        pOverPAvgMinusOne(i,:,j) = 100*(population/mean(population)-1);
    end
    
    figure;

    boxplot(squeeze(pOverPAvgMinusOne(i,:,:)),interpolationMethods);

    xlabel('Interpolation Method');
    ylabel('(P/P(average)) - 1) %');
    
    if saveFigures
        set(gcf,'Position', [0, 0, 400, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/point/boxplot-GridSizeVsPopulation-' num2str(sigma) '-' places{i} '.pdf']);
    end
end

figure;

boxplot(squeeze(mean(pOverPAvgMinusOne)),interpolationMethods);

xlabel('Interpolation Method');
ylabel('(P/P(average)) - 1) %');

if saveFigures
    set(gcf,'Position', [0, 0, 400, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/boxplot-GridSizeVsPopulation-' num2str(sigma) '-' places{1} '-' places{p} '-overall.pdf']);
end