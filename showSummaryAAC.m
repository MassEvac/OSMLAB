function showSummaryAAC(amenityTags,places,gridSizes,sigmas,saveFigures)
% Shows the correlation of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags (String) - Name of the amenities to consider
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of amenity-amenity correlation in grid format for many
%               places and amenities for different gridSizes and sigmas
% EXAMPLE:
%           showSummaryAAC({'fuel','police','fire_station'},{'London','Manchester', 'Bristol'},[100:100:4000],[0.2:0.2:8],true)

%% Retrieve the data
[manyAAC, ~] = getManyAAC(amenityTags,places,gridSizes,sigmas);

[p,a,~] = size(manyAAC);

clims = [-1 1];
crop = 1:20;

%% Do all the calculations
deviation = zeros(p,a,a);
average = ones(p,a,a);
averageOfPlaces = zeros(p,a*(a-1)/2);

for m = 1:p
    for n = 1:a
        for o = 1:a
            if (n ~= o)
                this = manyAAC{m,n,o};
                this = this(crop,crop);                
                deviation(m,n,o) = std(this(:));
                average(m,n,o) = mean(this(:));
            end
        end
    end
    thisPlace = squeeze(average(m,:,:));
    thisPlace = thisPlace - triu(thisPlace);
    averageOfPlaces(m,:)=thisPlace(thisPlace~=0);
end

%% Produce images of the correlations
for o = 1:a
    figure;

    errorbar(squeeze(average(:,:,o)),squeeze(deviation(:,:,o)));
    ylabel('Correlation Coefficient');
    set(gca,'XTick',1:length(places),'XTickLabel',places);
    ylim([-1 1]);
    legend(upper(strrep(amenityTags, '_', ' ')),'location','southwest');

    if saveFigures
        set(gcf,'Position', [0, 0, 900, 300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/point_analysis/plot-AACAnalysisStatistics-vs-' amenityTags{o} '.pdf']);
    end
end

%% Average across amenities
figure;
averageOfAmenities = squeeze(mean(average,3));
boxplot(averageOfAmenities(:,end:-1:1),upper(strrep(amenityTags(end:-1:1), '_', ' ')),'orientation','horizontal');
xlabel('Correlation Coefficient');

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/boxplot-AACAmenitySummary.pdf']);
end

%% Average across places
figure;
boxplot(averageOfPlaces(:,end:-1:1)',places(end:-1:1),'orientation','horizontal');
xlabel('Correlation Coefficient');

if saveFigures
    set(gcf,'Position', [0, 0, 900, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/boxplot-AACPlacesSummary.pdf']);
end