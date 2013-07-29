function showHighway(place, saveFigures)
% Plots the graph of highway of input place with colours to distinguish highway classes
%
% INPUT:
%           place (String) - Name of polygon area in OpenSteetMap
% OUTPUT:
%           Graph of the highway with different colours for different classes
%               as defined by highwayColours legend described by highwayLegend.
%           saveFigures (boolean) - Optional boolean switch for saving figures
% EXAMPLE:
%           showHighway('Bristol',false)

if (nargin < 2)
    saveFigures = false;
end

visibleHighways = 1:7;

highwayColours = {'black' 'blue' 'magenta' 'green' 'red' 'cyan' 'yellow'};
highwayLegend = {'Motorway', 'Trunk', 'Primary', 'Secondary', 'Tertiary', 'Residential', 'Pedestrian'};

highwayResult = getHighway(place);

if saveFigures
    figure;
else
    figure('units','normalized','outerposition',[0 0 1 1]);
end

fname = ['Highways in ' place];
set(gcf,'name',fname,'numbertitle','off');

hold on;

readyToPlot = false;
first = 1;

noOfPoints = length(highwayResult);
h = zeros(1,noOfPoints);

disp('Plotting highways...');
tic;
for i = 2:noOfPoints + 1
    try
        if (highwayResult(i,3) == 1)
            last = i - 1;
            readyToPlot = true;
        end
    catch err
        last = i - 1;
        readyToPlot = true;
    end  

    if (readyToPlot)
        if (find(visibleHighways == highwayResult(last,4)))
            plot(highwayResult(first:last,1),highwayResult(first:last,2),'Color',highwayColours{highwayResult(last,4)});
        end
        first = i;
        readyToPlot = false;
    end 
end

for i = visibleHighways
    r = findobj('Color',highwayColours{i});
    v(i) = r(1);
end

legend(v,highwayLegend)

toc;

xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');

[max_lon,max_lat,min_lon,min_lat] = getBoundaryLimits(place);

axis([min_lon max_lon min_lat max_lat])

if saveFigures
    set(gcf,'Position', [0, 0, 800, 300]);
    set(gcf, 'Color', 'w');
    export_fig(['./figures/graph-Highway-' place '.pdf']);
end