function [manyGridSizesPopulationAmenityCorrelation] = getManyGridSizesPopulationAmenityCorrelation(amenityTags, place, gridSizes, sigma, populationWeighted)
% Returns the correlation of different granularities of gridSizes and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSizes(j) (Integer Array) - Array of Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           populationAmenityCorrelationForManyGridSizes(i,j) (Double) - Correlation of amenity
%               map of amenityTags{i} and population of given place in grid
%               format for various grid sizes
% EXAMPLE:
%           [manyGridSizesPopulationAmenityCorrelation] = getManyGridSizesPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',[50:100:2000],1,true)

g = length(gridSizes);
a = length(amenityTags);
manyGridSizesPopulationAmenityCorrelation = zeros(g,a);

for i=1:g
    gridSize = gridSizes(i);
    manyGridSizesPopulationAmenityCorrelation(i,:) = getPopulationAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted);
end