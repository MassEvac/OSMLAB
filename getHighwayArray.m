%function getHighwayArray

clear;
close all;

place = 'Cardiff';

visibleHighways = 1:7;

loadHighwayDefinition;

r = getHighway(highways,highwayType,place);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Highways in ' place];
set(f1,'name',fname,'numbertitle','off');
set(gca,'FontSize',14);

%nodeArray = 

readyToPlot = false;
first = 1;
for i = 2:length(r) + 1
    try
        if (r(i,3) == 1)
            last = i - 1;
            readyToPlot = true;
        end
    catch err
        last = i - 1;
        readyToPlot = true;
    end  

    if (readyToPlot)
        if (find(visibleHighways == r(last,4)))
            hold on;
            plot(r(first:last,1),r(first:last,2),'Color',highwayColours{r(last,4)});
        end
        first = i;
        readyToPlot = false;
    end
    
end