function [correlation] = getPopulationAmenityCorrelation(populationGrid, amenityGrid)
    correlation = getCorrelation([amenityGrid {populationGrid}]);
    correlation = correlation(length(correlation),1:length(amenityGrid));