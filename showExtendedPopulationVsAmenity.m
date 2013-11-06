amenityTags = textread('scopeAmenities.txt','%s','delimiter','\n');
places = textread('places.txt','%s','delimiter','\n');
gridSize = 400;
sigma = 2;

%% Read population
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

disp([num2str(length(places(find(populationDoesNotExist)))) ' places could not be resolved.']);

%% Read amenities
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

%% Do calculations
x=log(population(~populationDoesNotExist))';
y=[x log(amenityCount(~populationDoesNotExist,:))];

doesNotExist = [zeros(length(x),1) amenityDoesNotExist(~populationDoesNotExist,:)];

tags = {'symmetry' amenityTags{:}};

[~,m]=size(y);

legtxt = cell(m,1);

markers = {'.' '+' 'o' '*' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
colours = {'k' 'g' 'r' 'b' 'c' 'm' 'y'};

markerNumber = 1;
colourNumber = 1;

figure;

hold on;

for n = 1:m
    if markerNumber > length(markers)
        markerNumber = 1;
    end

    if colourNumber > length(colours)
        colourNumber = 2;
    end
        
    thisX = x(~doesNotExist(:,n));
    thisY = y(~doesNotExist(:,n),n);
    
    p = polyfit(thisX,thisY,1);
    
    k(n) = p(1); % Gradient
    legtxt{n}=[ num2str(k(n),'%0.2f') ' = {\beta}_{' strrep(tags{n}, '_', ' ') '}'];    

    plot(thisX,thisY,[colours{colourNumber} markers{markerNumber}]);    
    
    markerNumber = markerNumber + 1;
    colourNumber = colourNumber + 1;
end

lsline;

legend(legtxt(index));

xlabel('Population');
ylabel('SPOIs');
lsline;
