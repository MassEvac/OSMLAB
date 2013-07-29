function showPopulationGrid(place,gridSize,sigma, saveFigures)
% Plots an image of the population grid of the input place
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph
% EXAMPLE:
%           showPopulationGrid('Bristol',250,1,true)

if (nargin < 4)
    saveFigures = false;
end

populationGrid = getPopulationGrid(place, gridSize, sigma);

if saveFigures
    figure;
else
    figure('units','normalized','outerposition',[0 0 1 1]);
end

imagesc(populationGrid);
colorbar;
xlabel('West-East Cell Units');
ylabel('North-South Cell Units');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/image-Population-' place '.pdf']);
end