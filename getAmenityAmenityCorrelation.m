function [AAC] = getAmenityAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted)
% Returns the correlation between 2 amenities as a single value for a single place
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to
%              consider (2 values only, i=1 and i=2)
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           amenityAmenityCorrelation (Double) - A single value which
%               represents the degree of correlation between 2 amenities
% EXAMPLE:
%           [AAC] = getAmenityAmenityCorrelation({'bar','atm','hospital'},'Bristol',250,1,true)

amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
AAC = getCorrelation(amenityGrids);
AAC = AAC(1,2);