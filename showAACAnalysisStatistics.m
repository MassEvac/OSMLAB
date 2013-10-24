function showAACAnalysisStatistics(amenityTags,places,gridSizes,sigmas,saveFigures)
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
%           showAACAnalysisStatistics({'fuel','police','fire_station'},{'London','Manchester', 'Bristol'},[100:100:4000],[0.2:0.2:8],true)

%% Retrieve the data
[manyGridSizesSigmasAAC, ~] = getManyAAC(amenityTags,places,gridSizes,sigmas);

[p,a,~] = size(manyGridSizesSigmasAAC);

clims = [-1 1];

%% Produce images of the correlations
for vsAmenityTag = 1:a
    if saveFigures
        figure;
    else
        figure('units','normalized','outerposition',[0 0 1 1]);
    end

    deviation = zeros(p,a);
    average = ones(p,a);
    crop = 1:20;

    for m = 1:p
        for n = 1:a
            for o = (n+1):a
                i = 0;

                if n == vsAmenityTag
                    i = o;
                elseif o == vsAmenityTag
                    i = n;
                end

                if i
                    this = manyGridSizesSigmasAAC{m,n,o};
                    this = this(crop,crop);                
                    deviation(m,i) = std(this(:));
                    average(m,i) = mean(this(:));
                end
            end
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
        export_fig(['./figures/point_analysis/plot-AACAnalysisStatistics-vs-' amenityTags{vsAmenityTag} '.pdf']);
    end
end