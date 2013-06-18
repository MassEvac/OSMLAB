[~, name] = system('hostname');

if (strcmp(name(1:13),'bharat-ubuntu'))
    userpath('/insertUbuntuPathHere/OSM');
else
    userpath('/Users/bharatkunwar/OSM');
end