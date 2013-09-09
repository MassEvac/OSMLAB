tic;

for i = 1:20
    pop = getPopulationGrid('Manchester', 500, i*0.5);
    p(i) = sum(pop(:));
end

x = [1:20] * 0.5;
y = (p/mean(p)-1)*100;
e = std(y) * ones(1,20);

figure;
errorbar(x,y,e);

toc;