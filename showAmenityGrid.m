function showAmenityGrid(place, smoothAmenityGrid, amenityTags)
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
% set(f1, 'Position', [0 0 800 600]);
fname = [place ' amenity'];
set(f1,'name',fname,'numbertitle','off');

[~, n] = size(amenityTags);
g = ceil(sqrt(n));

for i=1:n
    %disp(t);
    subplot(g,g,i);
    imagesc(smoothAmenityGrid{i});
    colorbar;
    gname = [ place ' ' amenityTags{i} 's' ];
    xlabel(gname,'FontSize',14);
    set(gca,'FontSize',14);
end
