function showPopulationOnHighway( place, gridSize, sigma )
% Plots a graph of the highway overlaid with population data of the input place
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph

[population,longitude,latitude]=getSmoothPopulationGrid(place, gridSize, sigma);
[HAM,~,nodes]=getAM(place);

figure
hold on;
gplot(HAM,nodes);
plot3k([longitude(:) latitude(:) log(population(:))]);