function [populationAmenityCorrelation] = getPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted)

p = length(places);
a = length(amenityTags);
populationAmenityCorrelation = zeros(p,a);

for i=1:p
    place = places{i};
    amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
    populationGrid = getPopulationGrid(place, gridSize, sigma);
    correlation = getCorrelation([amenityGrids {populationGrid}]);
    correlation = correlation(length(correlation),1:length(amenityGrids));    
    populationAmenityCorrelation(i,:) = correlation;   
end