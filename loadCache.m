%% Instructions
% If you want to load a fresh cache of population and amenity location
% data, simply delete all the amenity folders and _population folder in the
% cache and run this program. You would usually want to do this if you have
% a new version of OSM database on the system which you want to refer to.

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