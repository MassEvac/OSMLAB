function showManyPAC(amenityTags,places,gridSizes,sigmas,saveFigures)
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
%           showManyPAC({'fuel','hospital','fire_station'},{'London','Bristol'},[100:100:4000],[0.2:0.2:8],false,true)

%% Retrieve the data
[manyPAC, manyTimes] = getManyPAC(amenityTags,places,gridSizes,sigmas);

[p,a] = size(manyPAC);

clims = [-1 1];

%% Produce images of the correlations

for m = 1:p

    if saveFigures
        figure;
    else
        figure('units','normalized','outerposition',[0 0 1 1]);
    end
    
    figureCount = 0;
    
    for n = 1:a
        figureCount = figureCount + 1;
        
        subtightplot(1,a,figureCount);
        
        imagesc(gridSizes,sigmas,manyPAC{m,n}, clims);
        colorbar;
        ylabel([ places{m} ' ' upper(strrep(amenityTags{n}, '_', ' '))]);
    end
    
    if saveFigures
        set(gcf,'Position', [0, 0, a*300, 250]);
        set(gcf, 'Color', 'w');
        export_fig(['./figures/point_analysis/PAC/image-manyGridSizesSigmasPAC-' places{m} '.pdf']);
    end
end