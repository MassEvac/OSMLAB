function [PAC] = getPAC(amenityTags, place, gridSize, sigma)
% Returns the correlation between population and amenity in grid format for a single place and various amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           PAC(i,j) (Double) - Correlation of amenity
%               map of amenityTags{i} and population of places{j} in grid format
% EXAMPLE:
%           [PAC] = getPAC({'bar','atm','hospital'},'Bristol',250,1)

% We do not want the amenities weighted by population
populationWeighted = false;

amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
populationGrid = getPopulationGrid(place, gridSize, sigma);
PAC = getCorrelation([amenityGrids {populationGrid}]);
PAC = PAC(length(PAC),1:length(amenityGrids));