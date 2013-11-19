load('scope/topAmenities.mat');
load('scope/topPlaces.mat');

%% Load amenity data
for i = 1:length(amenityTags)
    for j = 1:length(places)
        getAmenity(amenityTags{i},places{j});
    end
end

%% Load population data
for j = 1:length(places)
    getPopulation(places{j});
end