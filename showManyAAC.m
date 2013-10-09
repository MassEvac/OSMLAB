function showManyAAC(amenityTags,vsAmenityTag,places,gridSizes,sigmas,saveFigures)
% Shows the correlation of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags (String) - Name of the amenities to consider
%           places (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           Image of population-amenity correlation in grid format for many
%           places and amenities for different gridSizes and sigmas
% EXAMPLE:
%           showManyAAC({'fuel','hospital','fire_station','school'},4,{'London','Bristol'},100:100:4000,0.2:0.2:8,true)

%% Retrieve the data

[manyAAC, ~] = getManyAAC(amenityTags,places,gridSizes,sigmas);

[p,a,~] = size(manyAAC);

clims = [-1 1];

%% Produce images of the correlations
for vsAmenityTag = 1:a

    for m = 1:p
        if saveFigures
            figure;
        else
            figure('units','normalized','outerposition',[0 0 1 1]);
        end

        figureNumber = 0;

        for n = 1:a
            for o = (n+1):a

                i = 0;

                if n == vsAmenityTag
                    i = o;
                elseif o == vsAmenityTag
                    i = n;
                end

                if i
                    figureNumber = figureNumber+1;
                    subtightplot(1,a-1,figureNumber);

                    imagesc(gridSizes,sigmas,manyAAC{m,n,o}, clims);
                    colorbar;
                    ylabel([ places{m} ' ' upper(strrep(amenityTags{n}, '_', ' ')) ' vs ' upper(strrep(amenityTags{o}, '_', ' '))]);
                end            
            end
        end

        if saveFigures
            set(gcf,'Position', [0, 0, (a-1)*300, 250]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/AAC/image-manyGridSizesSigmasAAC-' places{m} '-' amenityTags{vsAmenityTag} '.pdf']);
        end
    end

end