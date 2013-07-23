function showPopulationOnHighway( place, gridSize, sigma )

[population,longitude,latitude]=getSmoothPopulationGrid(place, gridSize, sigma);
[HAM,~,nodes]=getAM(place);

figure
hold on;
gplot(HAM,nodes);
plot3k([longitude(:) latitude(:) log(population(:))]);