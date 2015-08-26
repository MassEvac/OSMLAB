function showSummaryPAC(amenityTags,places,gridSizes,sigmas,saveFigures)
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
%           showSummaryPAC({'fuel','police','fire_station'},{'London'},[100:100:4000],[0.2:0.2:8],true)

%% Retrieve the data
[manyPAC, ~] = getManyPAC(amenityTags,places,gridSizes,sigmas);

[p,a] = size(manyPAC);

clims = [-1 1];

deviation = zeros(p,a);
average = zeros(p,a);
crop = 1:20;

%% Do all the calculations
deviation = zeros(p,a,a);
average = ones(p,a,a);

cropLengthSq = length(crop)^2;

corrOfPlaces = zeros(p,a*cropLengthSq);
corrOfAmenities = zeros(a,p*cropLengthSq);

for m = 1:p
    for n = 1:a
        
        this = manyPAC{m,n};
        this = this(crop,crop);
        
        deviation(m,n) = std(this(:));
        average(m,n) = mean(this(:));
        
        corrOfPlaces(m,(n-1)*cropLengthSq+1:(n)*cropLengthSq)=this(:);
        corrOfAmenities(n,(m-1)*cropLengthSq+1:(m)*cropLengthSq)=this(:);
    end
end

%% Produce images of the correlations
figure;

errorbar(average,deviation);
ylabel('Correlation Coefficient');
set(gca,'XTick',1:length(places),'XTickLabel',places);
ylim([-1 1]);
legend(upper(strrep(amenityTags, '_', ' ')),'location','southwest');

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/plot-PACAnalysisStatistics.pdf']);
end

FontSize = 12;

[~,index]=sort(median(corrOfAmenities,2));

%% Average across amenities
figure;
set(gcf,'DefaultTextFontSize', FontSize);
boxplot(corrOfAmenities(index,:)',upper(strrep(amenityTags(index), '_', ' ')),'orientation','horizontal');
xlabel('Correlation Coefficient','FontSize',FontSize);
set(gca,'FontSize',FontSize);

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/boxplot-PACAmenitySummary.pdf']);
end

[~,index]=sort(median(corrOfPlaces,2));

%% Average across places
figure;
set(gcf,'DefaultTextFontSize', FontSize);
boxplot(corrOfPlaces(index,:)',places(index),'orientation','horizontal');
xlabel('Correlation Coefficient','FontSize',FontSize);
set(gca,'FontSize',FontSize);

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/boxplot-PACPlacesSummary.pdf']);
end
