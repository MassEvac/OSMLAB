function showPointAnalysisStatistics(amenityTags,places,gridSizes,sigmas,populationWeighted,saveFigures)
% Shows the correlation of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags (String) - Name of the amenities to consider
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           Image of population-amenity correlation in grid format for many
%           places and amenities for different gridSizes and sigmas
% EXAMPLE:
%           showPointAnalysisStatistics({'hospital','bar'},{'Bristol','Manchester'},[150:50:5100],[0.1:0.1:10],true,true)

%% Retrieve the data
[manyGridSizesSigmasPopulationAmenityCorrelations, ~] = getManyGridSizesSigmasPopulationAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted);

[p,a] = size(manyGridSizesSigmasPopulationAmenityCorrelations);

clims = [-1 1];

%% Produce images of the correlations

if saveFigures
    figure;
else
    figure('units','normalized','outerposition',[0 0 1 1]);
end

deviation = zeros(p,a);
average = zeros(p,a);
crop = 1:30;

for m = 1:p
    for n = 1:a
        
        this = manyGridSizesSigmasPopulationAmenityCorrelations{m,n};
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
    export_fig(['./figures/point_analysis/image-pointAnalysisStatistics.pdf']);
end
