close all;

amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'pub' 'school'};
% 'bar' 'atm'  'library'  'post_box' 
places = { 'London' 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' 'Oxford' 'Cardiff' 'Newcastle-upon-Tyne' 'Leeds' 'York' 'Nottingham' 'Chester'};
placeToShow = places{5};

populationAmenityCorrelation = [];

for p = places,
    place = p{1};

%     Now determine the dimension of the grid based on the gridsize specified

%     specify gridsize in metres
    gridSize = 250;
%     standard deviation to use
    sigma = 1;

    smoothAmenityGrid = getSmoothAmenityGrid(amenityTags, place, gridSize, sigma);
    smoothPopulationGrid = getSmoothPopulationGrid(place, gridSize, sigma);
    populationWeightedAmenityGrid = getPopulationWeightedAmenityGrid(smoothAmenityGrid,smoothPopulationGrid);

    populationWeightedAmenityCorrelation = getCorrelation(populationWeightedAmenityGrid);
    populationAmenityCorrelation = [populationAmenityCorrelation; getPopulationAmenityCorrelation(smoothPopulationGrid, populationWeightedAmenityGrid)];
    
    if (strcmp(place,placeToShow))
%         showAmenityGrid(smoothAmenityGrid, amenityTags, place);
         showAmenityGrid(populationWeightedAmenityGrid, amenityTags, [place ' PW']);
         showPopulationGrid(smoothPopulationGrid, place);
         showAmenityCorrelation(populationWeightedAmenityCorrelation, amenityTags, [place ' PW']);
    end

%     savefig(['population-vs-' amenity{:} '.pdf'],f2,'pdf');
end

showPopulationAmenityCorrelation(populationAmenityCorrelation, amenityTags, places);