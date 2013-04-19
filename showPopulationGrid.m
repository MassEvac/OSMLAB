function showPopulationGrid(place, pg)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Population of ' place];
set(f1,'name',fname,'numbertitle','off')
imagesc(pg);
colorbar;
xlabel(fname,'FontSize',14);
set(gca,'FontSize',14);