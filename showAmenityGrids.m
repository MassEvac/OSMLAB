function showAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted)
% Graphs the highway overlaid with population data of input place
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph
%
amenityGrid = getAmenityGrids(amenityTags, place, gridSize, sigma, populationWeighted);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Amenity distribution for ' place];
set(f1,'name',fname,'numbertitle','off');

n = length(amenityTags);
g = ceil(sqrt(n));

for i=1:n
    subplot(g,g,i);
    imagesc(amenityGrid{i});
    colorbar;
    gname = [ place ' ' upper(amenityTags{i}) ];
    xlabel(gname,'FontSize',14);
    set(gca,'FontSize',14);
end