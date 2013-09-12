place = 'Leeds';
amenityTag = 'hospital';
gridSizes = 150:50:5100;
sigmas = 0.1:0.1:10;
crop = 1:40;


fCorr = ['./results/manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];
p = csvread(fCorr);
figure;


surf(gridSizes,sigmas,p);
view(2);
p = p(crop,crop);

% p(1:7,1:7)=0;
figure;
hist(p(p(:)~=0));
figure;
surf(gridSizes(crop), sigmas(crop), p);
% colorbar;