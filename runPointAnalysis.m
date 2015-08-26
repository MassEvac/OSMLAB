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

cd ~/OSM;

populationWeighted = true;
saveFigures = true;

%
load('scope/7Amenities.mat','amenityTags');
load('scope/11Places.mat','places');

% DO NOT CHANGE
gridSizes = [100:100:4000];
sigmas = [0.2:0.2:8];

% Plural Attributes
% amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'bar' 'school'};
% places = { 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' }; % Newcastle-upon-Tyne

% Singular Attributes
amenityTag = amenityTags{1};    % = 'fuel'
place = places{1};              % = 'Bristol'
gridSize = gridSizes(4);         % = 400
sigma = sigmas(10);             % = 2
XSectionOf = 'gridSize';
XSectionAt = 400;
texFile = 'table.tex';
crop = 1:20;

%% I have already talked about these in SPOI
% showGridSizeVsTime(amenityTags, places, gridSizes, sigmas, saveFigures);
% showGridSizeVsPopulation(places, gridSizes, sigma, saveFigures);
% showGridSizeVsCells(places,gridSizes,saveFigures);
%
getPopulationAmenityTable(amenityTags,places,gridSize,sigma,texFile);
% showAmenities(amenityTags(1:2),place, saveFigures);
% showAmenityPopulationScatter(amenityTag,place, gridSize, sigma, saveFigures);
% 
% showPopulationGrid(place, gridSize, sigma, saveFigures);
% showPopulationVsPlaces(places,gridSize,sigma,saveFigures);
% 
% showAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures);
% showAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted, saveFigures);
%
% showManyPlacesPAC(amenityTags, places, gridSize, sigma, saveFigures);
% showManyXSectionPAC(amenityTags, places, gridSizes, sigmas, XSectionOf, XSectionAt, saveFigures);
%
% showCroppedPAC(amenityTag, place, gridSizes, sigmas, crop, saveFigures);
% showManyPAC(amenityTags,places,gridSizes,sigmas,saveFigures);
% showSummaryPAC(amenityTags,places,gridSizes,sigmas,saveFigures);
%
% showManyAAC(amenityTags,places,gridSizes,sigmas,saveFigures);
% showSummaryAAC(amenityTags,places,gridSizes,sigmas,saveFigures);