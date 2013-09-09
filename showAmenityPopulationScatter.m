pg = getPopulationGrid('London', 500, 1);
PW=getAmenityGrids({'fire_station'},'London',500,1,true);pw=PW{1};
figure;
scatter(pg(:),pw(:));
corrcoef(pg,pw)
