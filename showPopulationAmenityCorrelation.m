function showPopulationAmenityCorrelation(correlation, amenityTags, places)
%f1 = figure('units','normalized','outerposition',[0 0 1 1]);
figure;
fname = ['Correlations between Population count and Amenity'];
set(gcf,'name',fname,'numbertitle','off')
%colormap(gray);
imagesc(correlation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags),'FontSize',14)
set(gca,'YTick',1:length(places),'YTickLabel',places,'FontSize',14)
colorbar('FontSize',14);

set(gcf,'Position', [0, 0, 800, 300]);
savefig('populationAmenityCorrelation.pdf','pdf');