function showAmenityGrid(smoothAmenityGrid, amenityTags,place)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Amenity distribution for ' place];
set(f1,'name',fname,'numbertitle','off');

n = length(amenityTags);
g = ceil(sqrt(n));

for i=1:n
    subplot(g,g,i);
    imagesc(smoothAmenityGrid{i});
    colorbar;
    gname = [ place ' ' upper(amenityTags{i}) ];
    xlabel(gname,'FontSize',14);
    set(gca,'FontSize',14);
end