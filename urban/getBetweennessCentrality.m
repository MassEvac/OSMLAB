function [btc] = getBetweennessCentrality(city, weighted)
    load('global');
    if weighted
        filePath = ['./cache/btc_weighted/' DBase '/'];
    else
        filePath = ['./cache/btc_unweighted/' DBase '/'];
    end
    
    if ~exist(filePath,'file');
        mkdir(filePath);
    end
    
    fileName = [filePath city];
    
    try
        load(fileName);
    catch exception
        disp(['Calculating betweenness centrality for ' city '...'])
        [~,HAM] = getAM(city,true);

        if weighted
            C = 1;
            btc = betweenness_centrality(getCAM(HAM, C));
        else
            HAM(HAM>0) = 1;
            btc = betweenness_centrality(HAM);
        end
        
        save(fileName,'btc');
    end
end