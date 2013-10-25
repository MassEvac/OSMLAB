function [HAM, DAM, nodes] = getAM(place)
% Outputs highway class & distance adjacency sparse matrix and node list
%
% DETAIL:
%           Converts the results from the database and converts it into 
%           appropriate adjacency matrix containing highway class information,
%           another adjacency matrix with distance between the nodes and a 
%           separate list of reference nodes.
% INPUT:
%           place (String) 
% OUTPUT:
%           HAM(i,j) (Sparse) - Adjacency matrix containing the highway
%               class between nodes i and j
%           DAM(i,j) (Sparse) - Adjacency matrix containing the distance
%               information between nodes i and j
%           nodes (Double x 2) - Node longitude and latitude of the array
%               index for reference by HAM & DAM
% EXAMPLE:
%           [HAM, DAM, nodes] = getAM('Bristol')

fNode = ['./cache/highwayNode-' place];
fAM = ['./cache/highwayHAM-' place];
fDAM = ['./cache/highwayDAM-' place];

if (and(and(exist(fNode,'file'),exist(fAM,'file')),exist(fDAM,'file')))
    nodes = csvread(fNode);
    HAM = getResizedAM(spconvert(csvread(fAM)),length(nodes));
    DAM = getResizedAM(spconvert(csvread(fDAM)),length(nodes));
else
    tic;
    highwayResult = getHighway(place);

    % removes all duplicate coordinates and makes them individual nodes
    nodes = unique(highwayResult(:,1:2),'rows');

    m = length(nodes);
    n = 2;

    thisNode = 0;
    thatNode = 0;

    % process adjacency matrix
    HAM = sparse(m,m);
    DAM = sparse(m,m);

    for i = 1:length(highwayResult)

        if (highwayResult(i,3) == 1)
            thisNode = 0;
        else
            thisNode = thatNode;
        end

        thatNode = find(any(all(bsxfun(@eq,reshape(highwayResult(i,1:2).',1,n,[]),nodes),2),3)); % 41.381587 seconds

        if (thisNode && thatNode)
            HAM(thisNode,thatNode)=highwayResult(i,4);
            DAM(thisNode,thatNode)=haversine([nodes(thisNode,1) nodes(thatNode,1)],[nodes(thisNode,2) nodes(thatNode,2)]);
        end
    end
    
    [m,n,o] = find(HAM);
    HAM_dump = [m,n,o];
    
    [m,n,o] = find(DAM);
    DAM_dump = [m,n,o];
    
    dlmwrite(fNode, nodes, 'delimiter', ',', 'precision', 10);
    dlmwrite(fAM, HAM_dump, 'delimiter', ',', 'precision', 10);
    dlmwrite(fDAM, DAM_dump, 'delimiter', ',', 'precision', 10);
    toc;
end

% figure; gplot(AM,nodes);