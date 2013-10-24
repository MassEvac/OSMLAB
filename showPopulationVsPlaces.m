function showPopulationVsPlaces(places,gridSize,sigma,saveFigures)
% Shows an image of the population across many cities according to GPWv3 Future Estimates
%
% INPUT:
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of the population across many cities according to GPWv3 Future Estimates
% EXAMPLE:
%           showPopulationVsPlaces({'London','Manchester', 'Bristol'},400,2,true)


p = length(places);

population = zeros(1,p);

for i = 1:p
    place = places{i};
    populationGrid = getPopulationGrid(place,gridSize,sigma,true);
    population(i) = sum(sum(populationGrid));
end

barh(population);
set(gca,'YTick',1:length(places),'YTickLabel',upper(strrep(places, '_', ' ')));
ylabel('Places');
xlabel('Population');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/bar-populationVsPlaces-' num2str(gridSize) '-' num2str(sigma) '.pdf']);
end
