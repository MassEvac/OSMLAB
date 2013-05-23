function showAmenityCorrelation(correlation,amenityTags,place)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Correlation between Amenities for ' place];
set(f1,'name',fname,'numbertitle','off')
%colormap(gray);
imagesc(correlation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags),'FontSize',14)
set(gca,'YTick',1:length(amenityTags),'YTickLabel',upper(amenityTags),'FontSize',14)
colorbar;