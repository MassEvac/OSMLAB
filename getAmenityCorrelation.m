function [amenityCorrelation] = getAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted)
% Returns the correlation between amenities for a place with given attributes
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Name of an area polygon in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise amenities by population?
% OUTPUT:
%           amenityCorrelation(i,i) (Double) - Correlation between
%               amenities defined by amenityTags{i}

amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
amenityCorrelation = getCorrelation(amenityGrids);