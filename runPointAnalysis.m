%% All the components of point analysis in one place
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

populationWeighted = true;
saveFigures = true;

%
amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'school' 'atm' 'post_box'}; % 'bar' 'atm'  'library'  'post_box' 
places = { 'London' 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' 'Oxford' 'Cardiff' 'Leeds' 'York' 'Nottingham' 'Chester'}; % Newcastle-upon-Tyne

% DO NOT CHANGE
gridSizes = [100:100:4000];
sigmas = [0.2:0.2:8];

% Plural Attributes
% amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'bar' 'school'};
% places = { 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' }; % Newcastle-upon-Tyne

% Singular Attributes
amenityTag = amenityTags{1};    % = 'fuel'
place = places{1};              % = 'Bristol'
gridSize = gridSizes(4);         % = 300
sigma = sigmas(30);             % = 3

%%
% show2Amenities(amenityTags{1},amenityTags{2},place, saveFigures);
% 
% showPopulationGrid(place, gridSize, sigma, saveFigures);
% 
% showAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures);
% showAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures);

% showManyPlacesPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted, saveFigures);
% showManyGridSizesPopulationAmenityCorrelation(amenityTags,places(1),gridSizes,sigma,populationWeighted,saveFigures);    

% showManySigmasPopulationAmenityCorrelation(amenityTags,places(2),gridSize,sigmas,populationWeighted,saveFigures);    

showManyGridSizesSigmasPopulationAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted,saveFigures);

showManyGridSizesSigmasAmenityAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted,saveFigures);

% showPointAnalysisStatistics(amenityTags,places,gridSizes,sigmas,populationWeighted,saveFigures);