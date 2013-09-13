tic;
close all;

place = 'London';
show2Amenities('fuel','hospital',place,true);hold on; plot3k(getPopulation(place));view(2);

figure;

for i = 1:20
    pop = getPopulationGrid(place, i*250, 1,true);
    imagesc(pop);
    drawnow;
    pause(0.05);
    p(i) = sum(pop(:));
end

x = [1:20] * 250;
y = (p/mean(p)-1)*100;
e = std(y) * ones(1,20);

figure;
errorbar(x,y,e);

toc;