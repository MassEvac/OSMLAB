function showManyGridSizesSigmasPopulationAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted,saveFigures)
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
%           showManyGridSizesSigmasPopulationAmenityCorrelation({'hospital','bar'},{'Bristol','Manchester'},[100:100:5000],[1:10],true)

%% Retrieve the data
[manyGridSizesSigmasPopulationAmenityCorrelations, manyTimes] = getManyGridSizesSigmasPopulationAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted);

[p,a] = size(manyGridSizesSigmasPopulationAmenityCorrelations);

clims = [-1 1];

%% Produce images of the correlations

if saveFigures
    figure;
else
    figure('units','normalized','outerposition',[0 0 1 1]);
end

figureCount = 1;

for m = 1:p
    for n = 1:a
        subtightplot(p,a,figureCount);
        
        imagesc(gridSizes,sigmas,manyGridSizesSigmasPopulationAmenityCorrelations{m,n}, clims);
        colorbar;
        ylabel([ places{m} ' ' upper(strrep(amenityTags{n}, '_', ' '))]);
        
        figureCount = figureCount + 1;
    end
end

if saveFigures
    set(gcf,'Position', [0, 0, p*400, a*300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/image-manyGridSizesSigmasPAC.pdf']);
end

%% Produce figures of the time taken
figure; figureCount = 1;

for m = 1:p
    for n = 1:a
        subtightplot(p,a,figureCount);
        
        imagesc(gridSizes,sigmas,log(manyTimes{m,n}));
        colorbar;
        ylabel([ places{m} ' ' upper(strrep(amenityTags{n}, '_', ' '))]);
        
        figureCount = figureCount + 1;
    end
end
