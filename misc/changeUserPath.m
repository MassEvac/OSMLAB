[~, name] = system('hostname');

if (strcmp(name(1:(length(name)-1)),'IT050339'))
    userpath('/home/bk12369/OSM');
else
    userpath('/Users/bharatkunwar/OSM');
end