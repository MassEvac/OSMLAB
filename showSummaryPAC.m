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

corrPlacesPosition = 1;
corrAmenitiesPosition = 1;

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
    export_fig(['./figures/point_analysis/plot-PACAnalysisStatistics.pdf']);
end

%% Average across amenities
figure;
boxplot(corrOfAmenities(:,end:-1:1)',upper(strrep(amenityTags(end:-1:1), '_', ' ')),'orientation','horizontal');
xlabel('Correlation Coefficient');

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/boxplot-PACAmenitySummary.pdf']);
end

%% Average across places
figure;
boxplot(corrOfPlaces(end:-1:1,:)',places(end:-1:1),'orientation','horizontal');
xlabel('Correlation Coefficient');

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/boxplot-AACPlacesSummary.pdf']);
end
