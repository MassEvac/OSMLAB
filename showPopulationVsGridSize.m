tic;

for i = 1:20
    pop = getPopulationGrid('London', i*250, 1);
    p(i) = sum(pop(:));
end

x = [1:20] * 250;
y = (p/mean(p)-1)*100;
e = std(y) * ones(1,20);

figure;
errorbar(x,y,e);

toc;