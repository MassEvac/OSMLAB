function [AM, DAM, nodes] = getAM(place)

fNode = ['./cache/highwayNode-' place];
fAM = ['./cache/highwayAM-' place];
fDAM = ['./cache/highwayDAM-' place];

if (and(and(exist(fNode,'file'),exist(fAM,'file')),exist(fDAM,'file')))
    nodes = csvread(fNode);
    AM = resizeAM(spconvert(csvread(fAM)));
    DAM = resizeAM(spconvert(csvread(fDAM)));
else
    tic;
    r = getHighway(place,1:2);

    % removes all duplicate coordinates and makes them individual nodes
    nodes = unique(r(:,1:2),'rows');

    m = length(nodes);
    n = 2;

    thisNode = 0;
    thatNode = 0;

    % process adjacency matrix
    AM = sparse(m,m);
    DAM = sparse(m,m);

    for i = 1:length(r)

        if (r(i,3) == 1)
            thisNode = 0;
        else
            thisNode = thatNode;
        end

        thatNode = find(any(all(bsxfun(@eq,reshape(r(i,1:2).',1,n,[]),nodes),2),3)); % 41.381587 seconds

        if (thisNode && thatNode)
            AM(thisNode,thatNode)=r(i,4);
            DAM(thisNode,thatNode)=haversine([nodes(thisNode,1) nodes(thatNode,1)],[nodes(thisNode,2) nodes(thatNode,2)]);
        end
    end
    
    [m,n,o] = find(AM);
    AM_dump = [m,n,o];
    
    [m,n,o] = find(DAM);
    DAM_dump = [m,n,o];
    
    dlmwrite(fNode, nodes, 'delimiter', ',', 'precision', 10);
    dlmwrite(fAM, AM_dump, 'delimiter', ',', 'precision', 10);
    dlmwrite(fDAM, DAM_dump, 'delimiter', ',', 'precision', 10);
    toc;
end

%gplot(AM,nodes);
