function showPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted)
% Shows the correlation between population and amenity
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{i} (String Cell) - Name of the places to consider
%           gridSize (Integer) - approximate grid size we want in metres
%           sigma (Integer) - standard deviation to blur the population
%               data by using Gaussian distribution
%           populationWeighted (Boolean) - Whether to normalise the
%               amenities by population or not
% OUTPUT:
%           Graph of population and amenity correlation
%
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