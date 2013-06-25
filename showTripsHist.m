figure;
hist(Sp, 15);
xlabel('Shortest Path (m)','FontSize',20);
ylabel('Count','FontSize',20);
set(gca,'FontSize',18);
savefig(['hist-shortestPath-' thisPlace '.pdf'],gcf,'pdf');

figure;
hist(Mf, 15);
xlabel('Max Flow (cars/min)','FontSize',20);
ylabel('Count','FontSize',20);
set(gca,'FontSize',18);
savefig(['hist-maxFlow-' thisPlace '.pdf'],gcf,'pdf');

figure;
hist(Tr, 15);
xlabel('Trips (Pi*Pj/Dij)','FontSize',20);
ylabel('Count','FontSize',20);
set(gca,'FontSize',18);
savefig(['hist-trips-' thisPlace '.pdf'],gcf,'pdf');
