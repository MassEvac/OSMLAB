tic;
close all;

place = 'Bristol';
show2Amenities('fuel','hospital',place,true);hold on; plot3k(getPopulation(place));view(2);

figure;
steps = 40;
gridSizeInterval = 100;

for i = 1:steps
    pop = getPopulationGrid(place, i*gridSizeInterval, 1,true);
%     imagesc(pop);
%     drawnow;
%     pause(0.05);
    p(i) = sum(pop(:));
end

x = [1:steps] * gridSizeInterval;
y = (p/mean(p)-1)*100;
e = std(y) * ones(1,steps);

figure;
errorbar(x,y,e);

toc;