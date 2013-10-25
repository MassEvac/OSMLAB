function showPACAnalysisStatistics(amenityTags,places,gridSizes,sigmas,saveFigures)
% Shows the correlation of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags (String) - Name of the amenities to consider
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of population-amenity correlation in grid format for many
%           places and amenities for different gridSizes and sigmas
% EXAMPLE:
%           showPACAnalysisStatistics({'fuel','police','fire_station'},{'London'},[100:100:4000],[0.2:0.2:8],true)

%% Retrieve the data
[manyPAC, ~] = getManyPAC(amenityTags,places,gridSizes,sigmas);

[p,a] = size(manyPAC);

clims = [-1 1];

%% Produce images of the correlations

figure;

deviation = zeros(p,a);
average = zeros(p,a);
crop = 1:20;

for m = 1:p
    for n = 1:a
        
        this = manyPAC{m,n};
        this = this(crop,crop);
        
        deviation(m,n) = std(this(:));
        average(m,n) = mean(this(:));
    end
end

%%
errorbar(average,deviation);
ylabel('Correlation Coefficient');
set(gca,'XTick',1:length(places),'XTickLabel',places);
ylim([-1 1]);
legend(upper(strrep(amenityTags, '_', ' ')),'location','southwest');


%%
if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/plot-PACAnalysisStatistics.pdf']);
end
