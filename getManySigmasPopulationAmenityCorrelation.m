function [manySigmasPopulationAmenityCorrelation] = getManySigmasPopulationAmenityCorrelation(amenityTags, place, gridSize, sigmas, populationWeighted)
% Returns the correlation of different granularities of sigmas and amenities
%
% INPUT:
%           amenityTags{j} (String Cell) - Name of the amenities to consider
%           place (String) - Names of a polygon area in OpenSteetMap
%           gridSize (Integer) - Array of Grid granularity in metres
%           sigmas(i) (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           manySigmasPopulationAmenityCorrelation(i,j) (Double) - Correlation of amenity
%               map of amenityTags{i} and population of given place in grid
%               format for various grid sizes
% EXAMPLE:
%           [manySigmasPopulationAmenityCorrelation] = getManySigmasPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',[50:100:2000],1,true)

fCorr = ['./results/manySigmasPopulationAmenityCorrelation-' place];
    
if exist(fCorr, 'file')
    manySigmasPopulationAmenityCorrelation = csvread(fCorr);
else
    s = length(sigmas);
    a = length(amenityTags);
    manySigmasPopulationAmenityCorrelation = zeros(s,a);

    for i=1:s
        sigma = sigmas(i);
        manySigmasPopulationAmenityCorrelation(i,:) = getPopulationAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted);
    end

    disp(['Saving results to file ' fCorr '...']);
    csvwrite(fCorr,manySigmasPopulationAmenityCorrelation);
end