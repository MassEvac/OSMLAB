function showGridSizeVsCells(places,gridSizes,saveFigures)
% Produces a figure to show how the ratio of x_lat and x_lon grid cells varies with grid size assignment across cities
%
% INPUT:
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of a cities vs average ratio of total lon/lat grid cells
%              with standard deviation indicated
% EXAMPLE:
%           showGridSizeVsCells({'London','Manchester','Bristol'},[100:100:4000],true)

sigma = 0;

p = length(places);
g = length(gridSizes);

cells = zeros(g,p);

for i = 1:p
    for j = 1:g
        [m,n] = size(getPopulationGrid(places{i},gridSizes(j),sigma));
        cells(j,i) = n/m;
    end
end

figure;
boxplot(cells,places);

xlabel('Place');
ylabel('x_{lon}/x_{lat}');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/plot-gridSizeVsCells.pdf']);
end
