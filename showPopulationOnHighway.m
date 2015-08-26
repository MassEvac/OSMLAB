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
%           showPopulationOnHighway('Bristol',400,2,true)

populationWeighted = true;

pg = getPopulationGrid(place,gridSize,sigma);
ag = getAmenityGrids({'fuel'}, place, gridSize, sigma, populationWeighted);
ag=ag{1};

[lon, lat] = getGridCoordinates (place, gridSize);

agFactor = max(ag(:))-min(ag(:));
ag = (ag - min(ag(:)))/agFactor + 1;

pgFactor = max(pg(:))-min(pg(:));
pg = (pg - min(pg(:)))/pgFactor + 2;

figure;
hold on;

line([lon(1) lon(end)],[lat(1) lat(1)],[0 0],'LineStyle','--');
line([lon(1) lon(end)],[lat(end) lat(end)],[0 0],'LineStyle','--');
line([lon(1) lon(1)],[lat(1) lat(end)],[0 0],'LineStyle','--');
line([lon(end) lon(end)],[lat(1) lat(end)],[0 0],'LineStyle','--');

line([lon(1) lon(1)],[lat(1) lat(1)],[0 pg(1,1)],'LineStyle','-.');
line([lon(end) lon(end)],[lat(1) lat(1)],[0 pg(1,end)],'LineStyle','-.');
line([lon(1) lon(1)],[lat(end) lat(end)],[0 pg(end,1)],'LineStyle','-.');
line([lon(end) lon(end)],[lat(end) lat(end)],[0 pg(end,end)],'LineStyle','-.');

[nodes,HAM] = getAM(place,true);% true = We want simple AM

HAM(HAM==7)=0;
HAM(HAM==6)=0;

wgPlot(HAM,nodes,'vertexMarker','none');
% showHighway(place,false);

surf(lon,lat,ag,'EdgeColor','none');
surf(lon,lat,pg,'EdgeColor','none');
alpha(.3);
colormap jet;
view(3);
axis auto;
set(gcf,'Position', [0, 0, 600, 600]);
set(gcf, 'Color', 'w');

if saveFigures
    export_fig(['./figures/highway/graph-PopulationOnHighway-' place '.pdf']);
end