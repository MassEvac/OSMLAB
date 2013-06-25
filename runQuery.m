close all;

amenityTags = {'fuel' 'police' 'fire_station' 'hospital' 'bar' 'school'};
% 'bar' 'atm'  'library'  'post_box' 
places = { 'London' 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' 'Oxford' 'Cardiff' 'Leeds' 'York' 'Nottingham' 'Chester'};
% Newcastle-upon-Tyne
placeToShow = '';%places{5};

populationAmenityCorrelation = [];

for p = places,
    thisplace = p{1};

%     Now determine the dimension of the grid based on the gridsize specified

%     specify gridsize in metres
    gridSize = 250;
%     standard deviation to use
    sigma = 1;

    smoothAmenityGrid = getSmoothAmenityGrid(amenityTags, thisplace, gridSize, sigma);
    smoothPopulationGrid = getSmoothPopulationGrid(thisplace, gridSize, sigma);
    populationWeightedAmenityGrid = getPopulationWeightedAmenityGrid(smoothAmenityGrid,smoothPopulationGrid);

    populationWeightedAmenityCorrelation = getCorrelation(populationWeightedAmenityGrid);
    populationAmenityCorrelation = [populationAmenityCorrelation; getPopulationAmenityCorrelation(smoothPopulationGrid, populationWeightedAmenityGrid)];
    
    if (strcmp(thisplace,placeToShow))
%         showAmenityGrid(smoothAmenityGrid, amenityTags, place);
         showAmenityGrid(populationWeightedAmenityGrid, amenityTags, [thisplace ' PW']);
         showPopulationGrid(smoothPopulationGrid, thisplace);
         showAmenityCorrelation(populationWeightedAmenityCorrelation, amenityTags, [thisplace ' PW']);
    end

%     savefig(['population-vs-' amenity{:} '.pdf'],f2,'pdf');
end

showPopulationAmenityCorrelation(populationAmenityCorrelation, amenityTags, places);