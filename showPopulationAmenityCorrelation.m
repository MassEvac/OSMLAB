function showPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{j} (String Cell) - Names of polygon areas in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showPopulationAmenityCorrelation({'bar','atm','hospital'},{'Bristol','London'},250,1,true)

populationAmenityCorrelation = getPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted);
figure;
fname = ['Correlations between Population count and Amenity'];
set(gcf,'name',fname,'numbertitle','off')
imagesc(populationAmenityCorrelation);
set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(amenityTags),'FontSize',14)
set(gca,'YTick',1:length(places),'YTickLabel',places,'FontSize',14)
colorbar('FontSize',14);
set(gcf,'Position', [0, 0, 800, 300]);
savefig('populationAmenityCorrelation.pdf','pdf');