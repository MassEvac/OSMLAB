function showManyGridSizesSigmasAmenityAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted,saveFigures)
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
%           showManyGridSizesSigmasAmenityAmenityCorrelation({'hospital','bar'},{'Bristol','Manchester'},[100:100:5000],[1:10],true)

%% Retrieve the data
[manyGridSizesSigmasPopulationAmenityCorrelations, ~] = getManyGridSizesSigmasAmenityAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted);

[p,a,~] = size(manyGridSizesSigmasPopulationAmenityCorrelations);

clims = [-1 1];

%% Produce images of the correlations

for m = 1:p
    if saveFigures
        figure;
    else
        figure('units','normalized','outerposition',[0 0 1 1]);
    end
    
    for n = 1:a
        for o = (n+1):a
            
            figureNumber = (n-1)*(a-1) + (o-1)
            subtightplot(a-1,a-1,figureNumber);

            imagesc(gridSizes,sigmas,manyGridSizesSigmasPopulationAmenityCorrelations{m,n,o}, clims);
            colorbar;
            ylabel([ places{m} ' ' upper(strrep(amenityTags{n}, '_', ' ')) ' vs ' upper(strrep(amenityTags{o}, '_', ' '))]);
        end
    end
    
    if saveFigures
        set(gcf,'Position', [0, 0, (a-1)*400, (a-1)*300]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/AAC/image-manyGridSizesSigmasAAC-' places(m) '.pdf']);
    end
end