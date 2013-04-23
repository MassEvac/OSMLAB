function showPopulationGrid(name, populationGrid)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Population of ' name];
set(f1,'name',fname,'numbertitle','off')
imagesc(populationGrid);
colorbar;
xlabel(fname,'FontSize',14);
set(gca,'FontSize',14);