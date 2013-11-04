places = textread('places.txt','%s','delimiter','\n');

p = length(places);

population = zeros(1,p);

populationDoesNotExist = zeros(1,p);

for i = 1:p
    place = places{i};
    try
        population(i) = sum(sum(getPopulationGrid(place,gridSize,sigma,true)));
    catch err
        populationDoesNotExist(i) = true;
    end
end

places(find(populationDoesNotExist))

disp([num2str(length(places(find(populationDoesNotExist)))) ' places could not be resolved.']);

%%
a = length(amenityTags);

amenityCount = zeros(p,a);

amenityDoesNotExist = zeros(p,a);

for i = 1:p
    for j = 1:a
        try
            [amenityCount(i,j),~] = size(getAmenity(amenityTags{j}, places{i}));
        catch err
            amenityDoesNotExist(i,j) = true;
        end
    end
end

%%
plot(log(population(~populationDoesNotExist)),log(amenityCount(~populationDoesNotExist,:)),'.');
xlabel('Population');
ylabel('SPOIs');
lsline;
legend(upper(strrep(amenityTags, '_', ' ')));
