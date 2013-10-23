% All the components of highway analysis in one place
%
% DETAIL:
%           Highway analysis looks at road networks on OpenStreetMaps and performs
%           analysis to calculate Trips, Maximum Flow and Shortest path. The
%           objective of this part of the program is to see how well these
%           correlate across different geographical locations and how well
%           the results we find match up with census data.
% INPUT:
%           places{i} (String Cell) - Names of polygon areas in OpenSteetMap
%           place (String) - Name of polygon area we want more information on
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (Boolean) - Save figures to file where option is available?
% OUTPUT:
%           Several depending on what is required

places = { 'London' 'Birmingham' 'Leeds' 'Manchester'  'Liverpool' 'York' 'Nottingham' 'Bristol' 'Cardiff' 'Oxford' 'Chester'}; % Newcastle-upon-Tyne
place = places{1};
gridSize = 1000;
sigma = 2;
saveFigures = true;

% showPopulationOnHighway(place,gridSize,sigma,saveFigures);
% showHighway(place,saveFigures);
showTrips(place,gridSize,sigma,saveFigures);
% showWardCommuteData(place,saveFigures);