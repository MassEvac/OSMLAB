%% Analyses Trips and outputs visualisations of the results
close all;
clear;
thisPlace = 'Bristol';
saveFigures = false;

[TR,MF,SP,ODnodes,AM,nodes] = getTrips(thisPlace,1000,1);

% a=find(SP==Inf);
% SP(SP==Inf)=0;

Sp=full(SP(:));
Tr=full(TR(:));
Mf=full(MF(:));

SP(SP==Inf)=0;

a=find(Mf==0);
Sp(a) = [];
Tr(a) = [];
Mf(a) = [];

Pi=2;
Pj=2;

%% Subplots
if ~saveFigures
    subplot(Pi,Pj,1);
    plot3k([Sp,Tr,Mf]);
end;

%%
if ~saveFigures
    subplot(Pi,Pj,2);
else
    figure;
end

scatter(log(Sp),log(Tr));

set(gca,'FontSize',14);
xlabel('log(Shortest path (m))','FontSize',14);
ylabel('log(Trips (Pi*Pj/Dij))','FontSize',14);

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    savefig(['graph-shortestPathVsTrips-' thisPlace '.pdf'],'pdf');
end

%%
p = polyfit(Mf,Sp,3);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^3 + p(2) * Mf.^2 + p(3) * Mf.^1 + p(4); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);

if ~saveFigures 
    subplot(Pi,Pj,3);
else
    figure;
end

hold on;
plot(Mf(i),log(r(i)),'LineWidth',2);
scatter(Mf, log(Sp));
hold off;

set(gca,'FontSize',14);
legend('Average','Raw Data','Location','SouthEast');
xlabel('Maximum Flow (persons/min)');
ylabel('log(Shortest Path (m))');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    savefig(['graph-maxFlowVsShortestPath-' thisPlace '.pdf'],'pdf');
end

%%
p = polyfit(Mf,Tr,3);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^3 + p(2) * Mf.^2 + p(3) * Mf.^1 + p(4); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);

if ~saveFigures
    subplot(Pi,Pj,4);
else
    figure;
end

hold on;
plot(Mf(i),log(r(i)),'LineWidth',2);
scatter(Mf,log(Tr));
hold off;

set(gca,'FontSize',14);
legend('Average','Raw Data')
xlabel('Maximum Flow (persons/min)','FontSize',14);
ylabel('log(Trips (Pi*Pj/Dij))','FontSize',14);
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    savefig(['graph-maxFlowVsTrips-' thisPlace '.pdf'],gcf,'pdf');
end
%% Graph drawings

figure;
hold on;
gplot(AM,nodes,'k');
wgPlot(MF,ODnodes);
legend('Max Flow');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 500]);
    set(gca,'FontSize',14);
    saveas(gcf,['graph-maxFlow-' thisPlace '.pdf'],'pdf');
end

figure;
hold on;
gplot(AM,nodes,'k');
wgPlot(TR,ODnodes);
legend('Trips');
set(gcf,'Position', [0, 0, 800, 500]);
if saveFigures
    set(gcf,'Position', [0, 0, 800, 500]);
    set(gca,'FontSize',14);
    saveas(gcf,['graph-trips-' thisPlace '.pdf'],'pdf');
end

figure;
hold on;
gplot(AM,nodes,'k');
wgPlot(SP,ODnodes);
legend('Shortest Path');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 500]);
    set(gca,'FontSize',14);
    saveas(gcf,['graph-shortestPath-' thisPlace '.pdf'],'pdf');
end

figure;
hist(Sp, 15);
xlabel('Shortest Path (m)','FontSize',20);
ylabel('Count','FontSize',20);
set(gca,'FontSize',18);
if saveFigures
    savefig(['hist-shortestPath-' thisPlace '.pdf'],gcf,'pdf');
end

figure;
hist(Mf, 15);
xlabel('Max Flow (cars/min)','FontSize',20);
ylabel('Count','FontSize',20);
set(gca,'FontSize',18);
if saveFigures
    savefig(['hist-maxFlow-' thisPlace '.pdf'],gcf,'pdf');
end

figure;
hist(Tr, 15);
xlabel('Trips (Pi*Pj/Dij)','FontSize',20);
ylabel('Count','FontSize',20);
set(gca,'FontSize',18);
if saveFigures
    savefig(['hist-trips-' thisPlace '.pdf'],gcf,'pdf');
end
