[pop,lon,lat]=getSmoothPopulationGrid('Bristol',250,1);
[AM,nodes]=getAM('Bristol');
gplot(AM,nodes,'-*');
hold on;
plot3k([lon(:) lat(:) log(pop(:))]);
%imagesc(population,);
% 1. make a list of origin/destination nodes by comparing the list
% of latitudes and longitudes with the node list and finding the nodes
% closest to them. origins and destination will be p
% 2. calculate the distance from node i's->j's.
% 2. each point represents the number of people in that proximity.
% calculate Tij from i->j by using this value.
% 3. 
