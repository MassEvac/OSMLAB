function showHighway(place)

visibleHighways = 1:7;

highwayColours = {'black' 'blue' 'magenta' 'green' 'red' 'cyan' 'yellow'};

highwayResult = getHighway(place);

f1 = figure('units','normalized','outerposition',[0 0 1 1]);
fname = ['Highways in ' place];
set(f1,'name',fname,'numbertitle','off');
set(gca,'FontSize',14);

readyToPlot = false;
first = 1;

tic;
for i = 2:length(highwayResult) + 1
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
            hold on;
            plot(highwayResult(first:last,1),highwayResult(first:last,2),'Color',highwayColours{highwayResult(last,4)});
        end
        first = i;
        readyToPlot = false;
    end 
end

t=toc;
toc;