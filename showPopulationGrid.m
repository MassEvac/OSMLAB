function showPopulationGrid(place,gridSize,sigma)
% Plots an image of the population grid of the input place
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph

populationGrid = getPopulationGrid(place, gridSize, sigma);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Population of ' place];
set(f1,'name',fname,'numbertitle','off')
imagesc(populationGrid);
colorbar;
xlabel('West-East Cell Units','FontSize',14);
ylabel('North-South Cell Units','FontSize',14);
set(gca,'FontSize',14);