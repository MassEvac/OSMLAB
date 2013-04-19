function show2Amenities(t1, t2, place)
a1 = getAmenity(t1, place);
a2 = getAmenity(t2, place);
boundary = getBoundary(place);

[max_lon,max_lat,min_lon,min_lat]=getBoundaryLimits(boundary);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Comparison of ' t1 '(x) and ' t2 '(o) in ' place];
set(f1,'name',fname,'numbertitle','off')
hold on;
plot(a1(:,1),a1(:,2),'x','Color','blue');
plot(a2(:,1),a2(:,2),'o','Color','red');
plot(boundary(:,1),boundary(:,2),'.','Color','green');
xlabel('Longitudine (degrees)','FontSize',14); ylabel('Latitude (degrees)','FontSize',14); axis([min_lon max_lon min_lat max_lat]); set(gca,'FontSize',14); 