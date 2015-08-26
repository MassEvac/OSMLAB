function showGridSizeVsTime(amenityTags, places, gridSizes, sigmas, saveFigures)
% Produces a figure to show how avg. processing time across many cities is affected by grid size
%
% INPUT:
%           amenityTags (String) - Name of the amenities to consider
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of a gridsize vs avg. processing time across many cities
% EXAMPLE:
%           showGridSizeVsTime({'fuel','police','fire_station'},{'London','Manchester', 'Bristol'},[100:100:4000],[0.2:0.2:8],true)

[~, manyTimes] = getManyPAC(amenityTags, places, gridSizes, sigmas);

a = length(amenityTags);
p = length(places);

theMean = zeros(a,length(gridSizes));

for i = 1:p
    for j = 1:a
        theMean(j,:) = theMean(j,:) + 100*sum(manyTimes{i,j},2)'./sum(sum(manyTimes{i,j}));
    end
end

theMean = theMean./p;

plot(gridSizes,theMean);
legend(upper(strrep(amenityTags, '_', ' ')));

xlabel('Grid cell size (metres)');
ylabel('Time (% of total processing time)');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/plot-gridSizeVsTime.pdf']);
end