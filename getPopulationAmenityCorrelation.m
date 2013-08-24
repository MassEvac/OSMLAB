function [populationAmenityCorrelation] = getPopulationAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted)
% Returns the correlation between population and amenity in grid format for a single place and various amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           populationAmenityCorrelation(i,j) (Double) - Correlation of amenity
%               map of amenityTags{i} and population of places{j} in grid format
% EXAMPLE:
%           [populationAmenityCorrelation] = getPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',250,1,true)

amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
populationGrid = getPopulationGrid(place, gridSize, sigma);
populationAmenityCorrelation = getCorrelation([amenityGrids {populationGrid}]);
populationAmenityCorrelation = populationAmenityCorrelation(length(populationAmenityCorrelation),1:length(amenityGrids));