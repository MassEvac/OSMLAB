function show2Amenities(amenityTag1, amenityTag2, place)
% Returns amenity count bitmap matrix of a given place with input attributes
%
% INPUT:
%           amenityTag1 (String) - Name of the first amenity to consider
%           amenityTag2 (String) - Name of the second amenity to consider
%           place (String) - Name of an area polygon in OpenSteetMap
% OUTPUT:
%           Plot of the 2 amenities overlaid on the plot of the boundary 
% NOTE:
%           The boundary is more obvious when there are more points to
%           indicate it. Eg. The boundary for London is a lot more obvious
%           than the boundary for Bristol so just be wary of that.

amenity1 = getAmenity(amenityTag1, place);
amenity2 = getAmenity(amenityTag2, place);
boundary = getBoundary(place);

[max_lon,max_lat,min_lon,min_lat]=getBoundaryLimits(place);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Comparison of ' amenityTag1 '(x) and ' amenityTag2 '(o) in ' place];
set(f1,'name',fname,'numbertitle','off')
hold on;
plot(amenity1(:,1),amenity1(:,2),'x','Color','blue');
plot(amenity2(:,1),amenity2(:,2),'o','Color','red');
plot(boundary(:,1),boundary(:,2),'.','Color','green');
legend(upper(amenityTag1),upper(amenityTag2),place);
xlabel('Longitudine (degrees)','FontSize',14); ylabel('Latitude (degrees)','FontSize',14); axis([min_lon max_lon min_lat max_lat]); set(gca,'FontSize',14); 