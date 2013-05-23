function showPopulationGrid(populationGrid, place)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Population of ' place];
set(f1,'name',fname,'numbertitle','off')
imagesc(populationGrid);
colorbar;
xlabel('West-East Cell Units','FontSize',14);
ylabel('North-South Cell Units','FontSize',14);
set(gca,'FontSize',14);