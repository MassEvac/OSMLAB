function show2Amenities(tag1, tag2, place)
amenity1 = getAmenity(tag1, place);
amenity2 = getAmenity(tag2, place);
boundary = getBoundary(place);

[max_lon,max_lat,min_lon,min_lat]=getBoundaryLimits(boundary);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Comparison of ' tag1 '(x) and ' tag2 '(o) in ' place];
set(f1,'name',fname,'numbertitle','off')
hold on;
plot(amenity1(:,1),amenity1(:,2),'x','Color','blue');
plot(amenity2(:,1),amenity2(:,2),'o','Color','red');
plot(boundary(:,1),boundary(:,2),'.','Color','green');
legend(upper(tag1),upper(tag2),place);
xlabel('Longitudine (degrees)','FontSize',14); ylabel('Latitude (degrees)','FontSize',14); axis([min_lon max_lon min_lat max_lat]); set(gca,'FontSize',14); 