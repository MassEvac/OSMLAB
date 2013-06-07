smoothPopulationGrid = getSmoothPopulationGrid('Bristol', 250, 1);
showPopulationGrid(smoothPopulationGrid, 'Bristol');
[AM,nodes]=getAM('Bristol');
% gplot(AM,nodes);
% hold on;
imagesc(smoothPopulationGrid);
