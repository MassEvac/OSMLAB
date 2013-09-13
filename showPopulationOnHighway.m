function showPopulationOnHighway( place, gridSize, sigma, saveFigures )
% Plots a graph of the highway overlaid with population data of the input place
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph
% EXAMPLE:
%           showPopulationOnHighway('Bristol',250,1,true)

if (nargin < 4)
    saveFigures = false;
end

population = getPopulationGrid(place, gridSize, sigma);
[longitude,latitude] = getGridCoordinates(place, gridSize);
[HAM,~,nodes]=getAM(place);

figure;
hold on;
gplot(HAM,nodes);
plot3k([longitude(:) latitude(:) log(population(:))]);
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    view(2);
    export_fig(['./figures/point_analysis/graph-PopulationOnHighway-' place '.pdf']);
end