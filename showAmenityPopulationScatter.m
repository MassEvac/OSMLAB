function showAmenityPopulationScatter(amenityTags,place, gridSize, sigma, saveFigures)
% Shows the correlation between amenity count and population count between 2 amenities 
%
% INPUT:
%           amenityTag (String) - Name of the amenities to consider
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Graph of population data overlaid on top of the highway graph
% EXAMPLE:
%           showAmenityPopulationScatter({'fuel' 'hospital'},'London',400,2,true)

%%
populationWeighted = false;

pg = getPopulationGrid(place, gridSize, sigma);
AG = getAmenityGrids(amenityTags(1),place,gridSize,sigma,populationWeighted); %Not population weighted;
ag = AG{1};

figure;

subplot(1,2,1);
scatter(pg(:),ag(:));
c = corrcoef(pg,ag);

xlabel('Population Count');
ylabel([ upper(strrep(amenityTags{1}, '_', ' ')) ' Count']);

legend(['R_{PAC} = ' num2str(c(1,2))]);

populationWeighted = true;

AG = getAmenityGrids(amenityTags,place,gridSize,sigma,populationWeighted); %Not population weighted;
ag1 = AG{1};
ag2 = AG{2};

subplot(1,2,2);
scatter(ag1(:),ag2(:));
c=corrcoef(ag1,ag2);

xlabel([ upper(strrep(amenityTags{1}, '_', ' ')) '/Person']);
ylabel([ upper(strrep(amenityTags{2}, '_', ' ')) '/Person']);

legend(['R_{AAC} = ' num2str(c(1,2))]);

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/scatter-populationVsAmenity-' strjoin(amenityTags,'-') '-' place '-' num2str(gridSize) '-' num2str(sigma) '.pdf']);
end    