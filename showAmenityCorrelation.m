function showAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted)
% Shows image of the correlation between amenities of a given place with input attributes
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           Image of the correlation between amenities of a given place with input attributes
% EXAMPLE:
%           showAmenityCorrelation({'atm','police'},'Bristol',250,1,1)

amenityCorrelation = getAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted);
figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Correlation between Amenities for ' place];
set(gcf,'name',fname,'numbertitle','off')
imagesc(amenityCorrelation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags),'FontSize',14)
set(gca,'YTick',1:length(amenityTags),'YTickLabel',upper(amenityTags),'FontSize',14)
colorbar;