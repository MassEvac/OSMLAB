%function [r,s,x1,x2] = query(t1,t2,place)

amenityTags = {'fuel' 'police' 'fire_station' 'hospital'};
% 'bar' 'atm' 'pub' 'library' 'school' 'post_box' 
places = { 'London' 'Manchester' 'Birmingham' 'Liverpool' 'Bristol' 'Oxford' 'Cardiff' 'Newcastle-upon-Tyne' 'Leeds' 'York' 'Nottingham' 'Chester'};

populationAmenityCorrelation = [];

for p = places,
    place = p{1};

    % Now determine the dimension of the grid based on the gridsize specified

    % specify gridsize in metres
    gridSize = 250;
    % standard deviation to use
    sigma = 1;

    smoothAmenityGrid = getSmoothAmenityGrid(amenityTags, place, gridSize, sigma);
    smoothPopulationGrid = getSmoothPopulationGrid(place, gridSize, sigma);
    populationWeightedAmenityGrid = getPopulationWeightedAmenityGrid(smoothAmenityGrid,smoothPopulationGrid);

    amenityCorrelation = getCorrelation(populationWeightedAmenityGrid);
    populationAmenityCorrelation = [populationAmenityCorrelation; getPopulationAmenityCorrelation(smoothPopulationGrid, populationWeightedAmenityGrid)];
    
    close all;

    % showAmenityGrid([place], smoothAmenityGrid, amenityTags);
    % showAmenityGrid([place ' PW'], populationWeightedAmenityGrid, amenityTags);
    % showPopulationGrid(place, smoothPopulationGrid);
    % compare2Amenities(t1, t2, place);
    % showAmenityCorrelation(amenityCorrelation, amenityTags, place);
    
    % savefig([fname '.pdf'],f1,'pdf');

    % f2 = figure;
    % %colormap(gray);
    % bar(d);
    % legend (city,'Location','NorthWest');
    % set(f2,'Position', [0, 0, 800, 300]);
    % set(gca,'XTickLabel',upper(amenity),'FontSize',14)
    % savefig(['population-vs-' amenity{:} '.pdf'],f2,'pdf');
end

showPopulationAmenityCorrelation(populationAmenityCorrelation, amenityTags, places);