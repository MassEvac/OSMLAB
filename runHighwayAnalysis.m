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

cd ~/Dropbox/Coding/MATLAB/OSM;

load('scope/topPlaces.mat','places');

place = places{12};
gridSize = 1000;
sigma = 2;
saveFigures = true;

%showTrips('Chester',gridSize,sigma,saveFigures);

% showPopulationOnHighway(place,gridSize,sigma,saveFigures);
% showHighway(place,saveFigures);


for i = 1:length(places)
    % showTrips(places{i},gridSize,sigma,saveFigures);
    try
        getTrips(places{i},gridSize,sigma);
    catch err
        %
    end
end

% showTrips(place,gridSize,sigma,saveFigures);

% showWardCommuteData(place,saveFigures);