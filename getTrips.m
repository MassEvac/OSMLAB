function [TR,MF,SP,SPlist,ODnodes,HAM,DAM,TAM,nodes] = getTrips(place,gridSize,sigma)
% Returns Trips, Max-flow, Shortest path and Node-list of a given place
%
% DETAIL:
%           The script calculates Trips, Max-flow & Shortest path of a given
%           place based on Gravity model and arbitary road capacity assigned
%           to roads on OpenStreetMap for the input place.
% INPUT:
%           place (String) - Name of an area polygon in OpenSteetMap
%           gridSize (Integer) - approximate grid size we want in metres
%           sigma (Integer) - standard deviation to blur the population
%               data by using Gaussian distribution
% OUTPUT:
%           TR(i,j) (Sparse) - Number of Trips between nodes i and j
%           MF(i,j) (Sparse) - Maximum flow between nodes i and j calculated
%               using Boost's implementation of Goldberg's push relabel algorithm
%           SP(i,j) (Sparse) - Shortest path between nodes i and j calculated
%               using Dijkstra algorithm
%           ODnodes (Double x 2) - Origin and destination node longitude and
%               latitude of the array index for reference by TR, MF and SP
%           HAM(i,j) (Sparse) - Adjacency matrix containing the highway
%               class between nodes i and j
%           DAM(i,j) (Sparse) - Adjacency matrix containing the distance
%               information between nodes i and j
%           nodes (Double x 2) - Node longitude and latitude of the array
%               index for reference by HAM & DAM
% EXAMPLE:
%           [TR,MF,SP,ODnodes,HAM,DAM,nodes] = getTrips('Bristol',1000,1)
% NOTE:
%           The arbitrary road capacity applied to roads based on the
%           assumption that 25 cars/minutes can travel on a lane needs to
%           be examined and verified as they were purely assumed.

load('global');

configuration = [num2str(gridSize) '-' num2str(sigma)];

fp = ['./cache/highway/' DBase '/' place '/'];
fSP = [fp 'SP-' configuration '.mat'];
fSPlist = [fp 'SPlist-' configuration '.mat'];
fOD = [fp 'OD-' configuration '.mat'];
fODnodes = [fp 'ODnodes-' configuration '.mat'];
fODpop = [fp 'ODpop-' configuration '.mat'];
fMF = [fp 'MF-' configuration '.mat'];
fTR = [fp 'TR-' configuration '.mat'];
fTAM = [fp 'TAM-' configuration '.mat'];

if ~exist(fp,'file')
    mkdir(fp);
end

stateFile = ['./state/getTrips-' place '-' configuration '.mat'];

step = ['Running getTrips.m for ' place '...'];
disp(step);
email(step);

tic;
step = ['Processing adjacency matrix for ' place '...'];
disp(step);
[nodes,HAM,DAM]=getAM(place);

% Cars per lane per minute
C = 25;

% Undirected network
CAM = getCAM(HAM, C);
toc;

tic;
step = ['Processing origin/destination vector for ' place '...'];
disp(step);
if exist(fOD,'file')&&exist(fODnodes,'file')&&exist(fODpop,'file')
    load(fOD,'OD');
    load(fODnodes,'ODnodes');
    load(fODpop,'ODpop');
else
    populationGrid=getPopulationGrid(place,gridSize,sigma);
    [longitudeGrid, latitudeGrid] = getGridCoordinates(place, gridSize, 'true'); % Request as matrix
    longitude=longitudeGrid(:);   % longitude
    latitude=latitudeGrid(:);   % latitude
    ODpop=populationGrid(:); % population

    nOD=length(ODpop);

    % origin/destination matrix
    OD=zeros(nOD,1);

    halfGridSize = gridSize/2;

    for i=1:nOD
        % find the nodes nearest to the centroid
        ldiff = abs(nodes(:,1) - longitude(i)) .* abs(nodes(:,2) - latitude(i));
        [~, pos] = min(ldiff);

        % calculated the distances of the nodes from the centroid in x and y direction
        dist1=haversine([longitude(i) nodes(pos,1)], [latitude(i) latitude(i)]);
        dist2=haversine([longitude(i) longitude(i)], [latitude(i) nodes(pos,2)]);

        % assign the node nearest to the centroid of the grid to the OD matrix
        % if it is within a given gridbox, which omits the nodes outside the gridbox
        if (dist1<halfGridSize && dist2<halfGridSize)
            OD(i)=pos;
        end
    end

    % remove all the nodes that are not within the gridSize
    a=find(OD==0);
    OD(a) = [];
    longitude(a) = [];
    latitude(a) = [];
    ODnodes = [longitude latitude];

    % Remove mopulation not within the gridSize
    ODpop(a) = [];
    
    save(fOD,'OD');
    save(fODnodes,'ODnodes');
    save(fODpop,'ODpop');
end
nOD=length(OD);
toc;

tic;
step = ['Processing graph shortest path for ' place '...'];
disp(step);
if exist(fSP,'file')&&exist(fSPlist,'file')
    load(fSP,'SP');
    load(fSPlist,'SPlist');
else  
    i = 1;
    try
        load(stateFile);
    catch err
        % Not a problem if the state file is not found.
    end
    h = waitbar(0,step);
    SP = sparse(nOD,nOD);
    SPlist = cell(nOD,nOD);
    for i = i:nOD
        save(stateFile);
        for j = 1:nOD
            if (OD(i) ~= OD(j))
                [SP(i,j),SPlist{i,j}]=graphshortestpath(DAM,OD(i),OD(j));         
                completed = (i-1+j/nOD)/nOD;
                waitbar(completed,h,[step num2str(completed*100) '%']);
            end
        end
    end
    close(h);
    
    % Delete the saved state file since there were no issues    
    delete(stateFile);
    
    save(fSP,'SP');
    save(fSPlist,'SPlist');
    email([step 'complete.']);
end
toc;

tic;
step = ['Processing max flow for ' place '...'];
disp(step);
if exist(fMF,'file')
    load(fMF,'MF');
else
    i = 1;
    try
        load(stateFile);
    catch err
        % Not a problem if the state file is not found.
    end
    h = waitbar(0,step);
    MF = sparse(nOD,nOD);
    for i = i:nOD
        save(stateFile);   
        for j = 1:nOD
            if (OD(i) ~= OD(j))
                MF(i,j)=max_flow(CAM,OD(i),OD(j));
                completed = (i-1+j/nOD)/nOD;
                waitbar(completed,h,[step num2str(completed*100) '%']);
            end
        end
    end
    close(h);
    
    % Delete the saved state file since there were no issues    
    delete(stateFile);
    
    save(fMF,'MF');   
    email([step 'complete.']);
end    
toc;

tic;
step = ['Processing trips for ' place '...'];
disp(step);
if exist(fTR,'file')&&exist(fTAM,'file')
    load(fTR,'TR');
    load(fTAM,'TAM');
else
    i = 1;
    try
        load(stateFile);
    catch err
        % Not a problem if the load file is not found.
    end
    h = waitbar(0,step);
    TR = sparse(nOD,nOD);
    for i = i:nOD
        save(stateFile);        
        for j = 1:nOD
            if (OD(i) ~= OD(j))
                TR(i,j)=(ODpop(i)*ODpop(j))/SP(i,j);        
                completed = (i-1+j/nOD)/nOD;
                waitbar(completed,h,[step num2str(completed*100) '%']);
            end
        end
    end
    close(h);
    
    % Delete the saved state file since there were no issues    
    delete(stateFile);
    
    save(fTR,'TR');
    %save(fTR,'TAM');
    email([step 'complete.']);
end
% recalculate OD since the matrix dimension has now changed
nOD=length(OD);
toc;

% [length(SP) length(TR) length(MF)]
% [length(Sp) length(Tr) length(Mf)]

%Tij = (pop(i) x pop(j))/(dist(i,j))^2

%sum(dist==Inf)/length(dist)*100

%b=graphshortestpath(AM,od)

% gplot(AM,nodes,'-*');
% hold on;
% plot3k([nodes(od,1) nodes(od,2) log(pop)]);
% plot3k([l1(:) l2(:) log(pop(:))]);