function [AAC] = getAAC(amenityTags, place, gridSize, sigma)
% Returns the correlation between 2 Amenity/Person as a single value for a single place
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to
%              consider (2 values only, i=1 and i=2)
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           AAC (Double) - A single value which
%               represents the degree of correlation between 2 amenities
% EXAMPLE:
%           [AAC] = getAAC({'bar','atm','hospital'},'Bristol',250,1)

% We want amenity to be weighted by population
populationWeighted = true;

amenityGrids = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
AAC = getCorrelation(amenityGrids);
AAC = AAC(1,2);