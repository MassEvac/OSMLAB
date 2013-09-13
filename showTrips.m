function showTrips(place,gridSize,sigma,saveFigures)
% Shows graph and histogram of Trips, Max Flow and Shortest Path and their intercorrelation
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Graph view of trips, max-flow and shortest path
%           Histogram of trips, max-flow and shortest path
%           Correlation between trips, max-flow and shortest path
% EXAMPLE:
%           showTrips('Bristol',1000,1,true)
% NOTE:
%           The fourth option is to save the diagrams into cropped PDF files
% ISSUES:
%           At the moment, saving the files into cropped PDF doesn't work
%           properly on Ubuntu machine but works perfectly well on the OSX.
%           The fonts do the appear in the required size and the diagrams
%           are not always cropped.

if (nargin < 4)
    saveFigures = false;
end

% Read the data to be outputted
[TR,MF,SP,ODnodes,HAM,DAM,nodes] = getTrips(place,gridSize,sigma);

% Expand the sparse matrices to full matrices for use in
% correlations and histograms
Sp=full(SP(:));
Tr=full(TR(:));
Mf=full(MF(:));

% Remove all the unresolved shortest paths
SP(SP==Inf)=0;

% Remove all the Max Flows that are zero as well as the corresponding
% indices from Trips and Shortest Path
a=find(Mf==0);
Mf(a) = [];
Sp(a) = [];
Tr(a) = [];

%% Subplots if not saving figures
% Dimension of the Sub-plots
Pi=2; Pj=3;

if ~saveFigures
    figure;
    plot3k([Sp,Tr,Mf]);
end;

%% Correlation - Shortest Path vs Trips
if ~saveFigures
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(Pi,Pj,1);
else
    figure;
end

scatter(log(Sp),log(Tr)); % Draw data points

legend('Raw Data');
xlabel('log(Shortest path (m))');
ylabel('log(Trips (Pi*Pj/Dij))');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/corr-shortestPathVsTrips-' place '.pdf']);
end

%% Correlation - Max Flow vs Shortest Path
% Calculate line of best bit
p = polyfit(Mf,Sp,3);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^3 + p(2) * Mf.^2 + p(3) * Mf.^1 + p(4); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);

% Start drawing
if ~saveFigures 
    subplot(Pi,Pj,2);
else
    figure;
end

hold on;
plot(Mf(i),log(r(i)),'LineWidth',2); % Plot best fit line
scatter(Mf, log(Sp)); % Draw data points
hold off;

legend('Average','Raw Data','Location','SouthEast');
xlabel('Maximum Flow (persons/min)');
ylabel('log(Shortest Path (m))');

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/corr-maxFlowVsShortestPath-' place '.pdf']);
end

%% Correlation - Max Flow vs Trips
% Calculate line of best bit
p = polyfit(Mf,Tr,3);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^3 + p(2) * Mf.^2 + p(3) * Mf.^1 + p(4); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);

% Start Drawing
if ~saveFigures
    subplot(Pi,Pj,3);
else
    figure;
end

hold on;
plot(Mf(i),log(r(i)),'LineWidth',2); % Plot best fit line
scatter(Mf,log(Tr)); % Draw data points
hold off;

legend('Average','Raw Data')
xlabel('Maximum Flow (persons/min)');
ylabel('log(Trips (Pi*Pj/Dij))');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/corr-maxFlowVsTrips-' place '.pdf']);
end

%% Histogram - Shortest Path
if ~saveFigures
    subplot(Pi,Pj,4);
else
    figure;
end

hist(Sp, 15);
xlabel('Shortest Path (m)','FontSize',20);
ylabel('Count','FontSize',20);
if saveFigures
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/hist-shortestPath-' place '.pdf']);
end

%% Histogram - Max Flow
if ~saveFigures
    subplot(Pi,Pj,5);
else
    figure;
end

hist(Mf, 15);
xlabel('Max Flow (cars/min)','FontSize',20);
ylabel('Count','FontSize',20);
if saveFigures
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/hist-maxFlow-' place '.pdf']);
end

%% Histogram - Trips
if ~saveFigures
    subplot(Pi,Pj,6);
else
    figure;
end

hist(Tr, 15);
xlabel('Trips (Pi*Pj/Dij)','FontSize',20);
ylabel('Count','FontSize',20);
if saveFigures
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/hist-trips-' place '.pdf']);
end

%% Graph - Max Flow
figure;
hold on;
gplot(HAM,nodes,'k');
wgPlot(MF,ODnodes);
legend('Max Flow');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 500]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/graph-maxFlow-' place '.pdf']);
end

%% Graph - Trips
figure;
hold on;
gplot(HAM,nodes,'k');
wgPlot(TR,ODnodes);
legend('Trips');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 500]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/graph-trips-' place '.pdf']);
end

%% Graph - Shortest Path
figure;
hold on;
gplot(HAM,nodes,'k');
wgPlot(SP,ODnodes);
legend('Shortest Path');
if saveFigures
    set(gcf,'Position', [0, 0, 800, 500]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/highway_analysis/graph-shortestPath-' place '.pdf']);
end