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
x=log(populationCount(logical(populationCount)))';
y=[x log(amenityCount(logical(populationCount),:))];

%%
exists = [true(length(x),1) logical(amenityCount(logical(populationCount),:))];

%%
tags = {'symmetry' amenityTags{:}};

[~,m]=size(y);

markers = {'.' '+' 'o' '*' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
colours = {'k' 'g' 'r' 'b' 'c' 'm' 'y'};

markerNumber = 1;
colourNumber = 1;
plotNumber = 1;

range = [1 (1:10)+1];
legtxt = cell(length(range),1);

figure;

hold on;

[~,index]=sort(sum(exists,1),'descend');

for n = 1:m
    
    thisX = x(exists(:,n));
    thisY = y(exists(:,n),n);    
    
    if length(thisX) > 1
        p = polyfit(thisX,thisY,1);
        r = corrcoef(thisX,thisY);
        k(n) = p(1); % Gradient
        c(n) = r(2);
    else
        k(n) = 0;
        c(n) = 0;
    end
    
    if find(ismember(range,n))
        
        if markerNumber > length(markers)
            markerNumber = 1;
        end

        if colourNumber > length(colours)
            colourNumber = 2;
        end
        
        legtxt{plotNumber}=[ num2str(k(n),'%0.2f') ' = {\beta}_{' strrep(tags{n}, '_', ' ') '}'];

        plot(thisX,thisY,[colours{colourNumber} markers{markerNumber}]);    
    
        markerNumber = markerNumber + 1;
        colourNumber = colourNumber + 1;
        plotNumber = plotNumber + 1;
    end
end

legend(legtxt,'location','nw');

xlabel('log (Population)');
ylabel('log (SPOIs)');
lsline;

saveFigures = true;

if saveFigures
    set(gcf,'Position', [0, 0, 600, 500]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/loglog-PopulationVsAmenity.pdf']);
end

%%
x1=populationCount(logical(populationCount))';
y1=[x1 amenityCount(logical(populationCount),:)];
p1=places(logical(populationCount));
texFile = 'extendedAmenity.tex';
latextable(y1(:,1:11),'format','%0.0f','horiz',strcat('\rotatebox{90}{', strrep(tags(1:11), '_', '\_')','}'),'vert',p1,'name',texFile,'Hline',[1],'Vline',[1]);

%%
[~,index]=sort(k,'descend');
texFile = 'gradient.tex';
latextable([k(index)' c(index)'],'format','%0.2f','vert',strcat('$\beta_{', strrep(tags(index)', '_', '\_')','}$'),'name',texFile,'Vline',[1]);