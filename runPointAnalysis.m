% All the components of point analysis in one place
%
% DETAIL:
%           Point analysis encompasses anything to do with looking at static
%           points of interests. In this context, it primarily refers to
%           amenities presented on OpenStreetMap database.
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{i} (String Cell) - Names of polygon areas in OpenSteetMap
%           place (String) - Name of polygon area we want more information on
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise amenities by population?
% OUTPUT:
%           Several depending on what is required

amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'bar' 'school'}; % 'bar' 'atm'  'library'  'post_box' 
places = { 'London' 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' 'Oxford' 'Cardiff' 'Leeds' 'York' 'Nottingham' 'Chester'}; % Newcastle-upon-Tyne
place = places{1};
gridSizes = [250:250:2000]
gridSize = 250;
sigma = 1;
populationWeighted = true;
saveFigures = true;

% show2Amenities(amenityTags{1},amenityTags{2},place, saveFigures);
% 
% showPopulationGrid(place, gridSize, sigma, saveFigures);
% 
% showAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures);
% showAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures);

% showManyPlacesPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted, saveFigures);

showManyGridSizesPopulationAmenityCorrelation(amenityTags,place,gridSizes,1,populationWeighted,saveFigures)
