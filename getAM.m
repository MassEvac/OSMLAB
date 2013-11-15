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

fpRoot = './cache/_highway/';
fpNodes = [fpRoot 'nodes/'];
fpHAM = [fpRoot 'HAM/'];
fpDAM = [fpRoot 'DAM/'];
fNodes = [fpNodes place '.mat'];
fHAM = [fpHAM place '.mat'];
fDAM = [fpDAM place '.mat'];


if ~exist(fpRoot,'file')
    mkdir(fpRoot);
end

if ~exist(fpNodes,'file')
    mkdir(fpNodes);
end

if ~exist(fpHAM,'file')
    mkdir(fpHAM);
end

if ~exist(fpDAM,'file')
    mkdir(fpDAM);
end

if (and(and(exist(fNodes,'file'),exist(fHAM,'file')),exist(fDAM,'file')))
    load(fNodes,'nodes');
    load(fHAM,'HAM');
    load(fDAM,'DAM');
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

    nR = length(highwayResult);
    step = 'Converting result to AM...';
    h = waitbar(0,step);
    for i = 1:nR

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
        
        completed = i/nR;
        waitbar(completed,h,[step num2str(completed*100) '%']);        
    end
    close(h);
    
    save(fNodes,'nodes');
    save(fHAM,'HAM');
    save(fDAM,'DAM');
    toc;
end

% figure; gplot(AM,nodes);