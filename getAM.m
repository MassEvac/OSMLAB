function [nodes, HAM, DAM, OAM] = getAM(place,simple)
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
%           [nodes, HAM, DAM, OAM] = getAM('Bristol')

if ~exist('simple','var')
    simple = false;
end

fp = ['./cache/highway/' place '/'];
fNodes = [fp 'nodes.mat'];
fHAM = [fp 'HAM.mat'];
fDAM = [fp 'DAM.mat'];
fOAM = [fp 'OAM.mat'];

if ~exist(fp,'file')
    mkdir(fp);
end

if exist(fNodes,'file')&&exist(fHAM,'file')&&exist(fDAM,'file')&&exist(fOAM,'file')
    load(fNodes,'nodes');
    load(fHAM,'HAM');
    load(fDAM,'DAM');
    load(fOAM,'OAM');
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
    OAM = sparse(m,m);

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
            if ~highwayResult(i,5) % If not one-way
                HAM(thatNode,thisNode) = HAM(thisNode,thatNode);
                DAM(thatNode,thisNode) = DAM(thisNode,thatNode);
                OAM(thisNode,thatNode) = 2;                
            else
                OAM(thisNode,thatNode) = 1;
            end
        end
        
        completed = i/nR;
        waitbar(completed,h,[step num2str(completed*100) '%']);        
    end
    close(h);
    
    save(fNodes,'nodes');
    save(fHAM,'HAM');
    save(fDAM,'DAM');
    save(fOAM,'OAM');    
    toc;
end

if (simple)    
    fNodes = [fp 'nodesSimple.mat'];
    fHAM = [fp 'HAMsimple.mat'];
    fDAM = [fp 'DAMsimple.mat'];
    fOAM = [fp 'OAMsimple.mat'];
    if exist(fNodes,'file')&&exist(fHAM,'file')&&exist(fDAM,'file')&&exist(fOAM,'file')
        load(fNodes,'nodes');
        load(fHAM,'HAM');
        load(fDAM,'DAM');
        load(fOAM,'OAM');
    else
        [nodes,HAM,DAM,OAM]=simplifyAM(nodes,HAM,DAM,OAM);
        save(fNodes,'nodes');
        save(fHAM,'HAM');
        save(fDAM,'DAM');
        save(fOAM,'OAM');        
    end
end