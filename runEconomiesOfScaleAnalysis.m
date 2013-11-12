load('scope/topAmenities.mat','amenityTags');
load('scope/topPlaces.mat','places');
gridSize = 400;
sigma = 2;

%% Read population
p = length(places);

populationCount = zeros(1,p);

for i = 1:p
    place = places{i};
    try
        populationCount(i) = sum(sum(getPopulationGrid(place,gridSize,sigma,true)));
    catch error
        % Do nothing
    end
end

disp([num2str(sum(~populationCount)) ' places could not be resolved.']);

%% Read amenities
[amenityCount] = getAmenityCountByPlace(amenityTags,places);

%% Do calculations
x=log(populationCount(~~populationCount))';
y=[x log(amenityCount(~~populationCount,:))];

doesNotExist = [zeros(length(x),1) ~amenityCount(~~populationCount,:)];

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

legend(legtxt);

xlabel('Population');
ylabel('SPOIs');
lsline;
