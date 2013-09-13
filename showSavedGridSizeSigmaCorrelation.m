place = 'London';
amenityTag = 'police';
gridSizes = [100:100:4000];
sigmas = [0.2:0.2:8];
crop = 1:20;


fCorr = ['./results/PAC/manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];
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