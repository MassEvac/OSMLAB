[~, name] = system('hostname');

if (strcmp(name(1:13),'bharat-ubuntu'))
    userpath('/home/bk12369/OSM');
else
    userpath('/Users/bharatkunwar/OSM');
end