function [manyPlacesPAC] = getManyPlacesPAC(amenityTags, places, gridSize, sigma)
% Returns the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{j} (String Cell) - Names of polygon areas in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           manyPlacesPAC(i,j) (Double) - Correlation of amenity
%               map of amenityTags{i} and population of places{j} in grid format
% EXAMPLE:
%           [manyPlacesPAC] = getManyPlacesPAC({'bar','atm','hospital'},{'Bristol','London'},250,1)

p = length(places);
a = length(amenityTags);
manyPlacesPAC = zeros(p,a);

for i=1:p
    place = places{i};
    manyPlacesPAC(i,:) = getPAC(amenityTags, place, gridSize, sigma);
end