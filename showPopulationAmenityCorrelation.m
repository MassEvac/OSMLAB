function showPopulationAmenityCorrelation(correlation, amenityTags, places)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Correlation between Population count and Amenity in ' place];
set(f1,'name',fname,'numbertitle','off')
%colormap(gray);
imagesc(correlation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags),'FontSize',14)
set(gca,'YTick',1:length(places),'YTickLabel',upper(places),'FontSize',14)
colorbar;