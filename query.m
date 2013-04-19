%function [r,s,x1,x2] = query(t1,t2,place)

amenityTags = {'bar' 'atm' 'hospital' 'pub'};
place = 'Bristol';

% Now determine the dimension of the grid based on the gridsize specified

% specify gridsize in metres
gridSize = 250;
% standard deviation to use
sigma = 1;

smoothAmenityGrid = getSmoothAmenityGrid(amenityTags, place, gridSize, sigma);
smoothPopulationGrid = getSmoothPopulationGrid(place, gridSize, sigma);

% showAmenityGrid(place, smoothAmenityGrid, amenityTags)

populationWeightedAmenityGrid = getPopulationWeightedAmenityGrid(smoothAmenityGrid,smoothPopulationGrid);

showAmenityGrid(place, populationWeightedAmenityGrid, amenityTags)

% showPopulationGrid(place, smoothPopulationGrid);

% compare2Amenities(t1, t2, place);

% savefig([fname '.pdf'],f1,'pdf');

% [r,s] = corrcoef([as1(:),as2(:),ps(:)]);

