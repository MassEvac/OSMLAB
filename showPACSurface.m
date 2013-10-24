function showPACSurface(amenityTag, place, gridSizes, sigmas, crop, saveFigures)
% Shows a surface diagram of any given PAC correlation
%
% INPUT:
%           place (String) - Name of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas (i) (Float Array) - Standard deviation to use for gaussian blurring
%           crop (Integer Array) - Indicate the indices to crop for use
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Box plot which describes how gridSize affects population accuracy
% EXAMPLE:
%           showPACSurface('police','London',[100:100:4000], [0.2:0.2:8], 1:20, true);

if ~exist('saveFigures','var')
    saveFigures = true;
end

if ~exist('crop','var')
    crop = 1:20;
end

fCorr = ['./results/PAC/manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];
disp(['Showing results from ' fCorr]);
p = csvread(fCorr);

p = p(crop,crop);

figure;
surf(gridSizes(crop), sigmas(crop), p);
xlabel('Grid Cell Size');
ylabel('Sigma');
zlabel('Correlation Coefficient');

colorbar;

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point_analysis/surface-PAC-' amenityTag '-' place '.pdf']);
end