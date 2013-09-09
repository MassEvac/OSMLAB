place = 'Bristol';
amenityTag = 'atm';

fCorr = ['./results/manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];
p = csvread(fCorr);
figure;
surf([150:50:5100],[0.1:0.1:10],gsmooth2(p,0,'same'));
view(2);
p(21:100,21:100)=0;
figure;
hist(p(p(:)~=0));
% figure;
% imagesc(p,[-1 1]);
% colorbar;