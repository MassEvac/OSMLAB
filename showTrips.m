close all;
clear;
thisPlace = 'Manchester';
saveFigures = true;

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

if ~saveFigures
    subplot(Pi,Pj,2);
else
    figure;
end
plot(Sp,Tr,'.')
xlabel('Shortest path','FontSize',14)
ylabel('Trips','FontSize',14)
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gca,'FontSize',14);
    savefig(['graph-shortestPathVsTrips-' thisPlace '.pdf'],gcf,'pdf');
end

if ~saveFigures
    subplot(Pi,Pj,3);
else
    figure;
end
hold on;
p = polyfit(Mf,Sp,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^2 + p(2) * Mf + p(3); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);
plot(Mf(i), r(i), '-','Color','r');
%plot(Mf,Sp,'.')
%boxplot(Sp,Mf);
xlabel('Maximum flow','FontSize',14);
ylabel('Shortest path','FontSize',14);
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gca,'FontSize',14);
    savefig(['graph-maxFlowVsShortestPath-' thisPlace '.pdf'],gcf,'pdf');
end

%%
if ~saveFigures
    subplot(Pi,Pj,4);
else
    figure;
end
hold on;
p = polyfit(Mf,Tr,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^2 + p(2) * Mf + p(3); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);
[AX,H1,H2]=plotyy(Mf(i), r(i), Mf(i), Tr(i));
set(H1,'LineStyle','-');
set(H2,'LineStyle','.');
%plot(Mf,Tr,'.')
%boxplot(Tr,Mf);
xlabel('Maximum flow','FontSize',14);
ylabel('Trips','FontSize',14);
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gca,'FontSize',14);
    savefig(['graph-maxFlowVsTrips-' thisPlace '.pdf'],gcf,'pdf');
end

%% Graph drawings

figure;
wgPlot(MF,ODnodes);
legend('Max Flow');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gca,'FontSize',14);
    savefig(['graph-maxFlow-' thisPlace '.pdf'],gcf,'pdf');
end

figure;
wgPlot(TR,ODnodes);
legend('Trips');
set(gcf,'Position', [0, 0, 800, 300]);
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gca,'FontSize',14);
    savefig(['graph-trips-' thisPlace '.pdf'],gcf,'pdf');
end

figure;
wgPlot(SP,ODnodes);
legend('Shortest Path');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gca,'FontSize',14);
    savefig(['graph-shortestPath-' thisPlace '.pdf'],gcf,'pdf');
end