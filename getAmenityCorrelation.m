function [amenityCorrelation] = getAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted)
amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
amenityCorrelation = getCorrelation(amenityGrids);