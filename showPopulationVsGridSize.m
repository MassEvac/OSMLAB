tic;
close all;

place = 'London';
sigma = 2;
% show2Amenities('fuel','hospital',place,true);hold on; plot3k(getPopulation(place));view(2);
% figure;

steps = 40;
gridSizeInterval = 100;

for i = 1:steps
    pop = getPopulationGrid(place, i*gridSizeInterval, sigma,true);
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

xlabel('Gridcell Size (metres)');
ylabel('(P/P(average)) - 1) %');


set(gcf,'Position', [0, 0, 400, 300]);
set(gcf, 'Color', 'w');
export_fig(['./figures/point_analysis/plot-population-vs-gridSize-box-sigma-' num2str(sigma) '-' place '.pdf']);

toc;