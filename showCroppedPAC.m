function showCroppedPAC(amenityTag, place, gridSizes, sigmas, crop, saveFigures)
% Shows a cropped and uncropped diagram side by side of any given PAC correlation
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
%           showCroppedPAC('police','London',[100:100:4000], [0.2:0.2:8], 1:20, true);


%%

fCorr = ['./results/PAC/manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];
disp(['Showing results from ' fCorr]);
uncropped = csvread(fCorr);

cutout=uncropped(crop,crop);
meanOfCutout=mean(mean(cutout));

cropped = ones(size(uncropped))*meanOfCutout;
cropped(crop,crop)=cutout;

clims = [-1 1];

figure;

subplot(1,2,1);
imagesc(gridSizes, sigmas, uncropped, clims);
ylabel([ 'Original ' place ' ' upper(strrep(amenityTag, '_', ' '))]);
colorbar;

subplot(1,2,2);
imagesc(gridSizes, sigmas, cropped, clims);
ylabel([ 'Cropped ' place ' ' upper(strrep(amenityTag, '_', ' '))]);
colorbar;

if saveFigures
    set(gcf,'Position', [0, 0, 800, 250]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/point/image-CroppedPAC-' amenityTag '-' place '.pdf']);
end