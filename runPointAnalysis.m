% All the components of point analysis in one place
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{i} (String Cell) - Name of the places to consider
%           place (String) - One place to look into more detail
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise amenities by population?
% OUTPUT:
%           Several
%
amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'bar' 'school'}; % 'bar' 'atm'  'library'  'post_box' 
places = { 'London' 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' 'Oxford' 'Cardiff' 'Leeds' 'York' 'Nottingham' 'Chester'}; % Newcastle-upon-Tyne
place = places{5};
gridSize = 250;
sigma = 1;
populationWeighted = true;

showAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);
showPopulationGrid(place, gridSize, sigma);
showAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted);
show2Amenities(amenityTags{1},amenityTags{2},place);
%showPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted);