function [Sp,Tr,Mf] = trips(place,gridSize,sigma)

configuration = [ num2str(gridSize) '-' num2str(sigma) '-' place];

fSP = ['./cache/highwayShortestPath-' configuration];
fMF = ['./cache/highwayMaxFlow-' configuration];
fTR = ['./cache/highwayTrips-' configuration];

disp(['Processing trips for ' place '...']);

tic;
disp(['Processing adjacency matrix...']);
[AM,DAM,nodes]=getAM(place);
nAM = length(AM);

% Cars per lane per minute
C = 25;

% Undirected network
AM(AM==1)=C*3;
AM(AM==2)=C*2;
AM(AM==3)=C*1;
AM(AM==4)=C*0.8;
AM(AM==5)=C*0.6;
AM(AM==6)=C*0.4;
AM(AM==7)=C*0.2;

AM = AM + AM';
DAM = DAM + DAM';
toc;

tic;
disp(['Processing population grid...']);
[pop,l1,l2]=getSmoothPopulationGrid(place,gridSize,sigma);
l1=l1(:);   % longitude
l2=l2(:);   % latitude
pop=pop(:); % population
toc;

tic;
disp('Processing origin/destination vector..');

nOD=length(pop);

% origin/destination matrix
OD=zeros(nOD,1);

halfGridSize = gridSize/2;

for i=1:nOD
    % find the nodes nearest to the centroid
    ldiff = abs(nodes(:,1) - l1(i)) .* abs(nodes(:,2) - l2(i));
    [~, pos] = min(ldiff);

    % calculated the distances of the nodes from the centroid in x and y direction
    dist1=haversine([l1(i) nodes(pos,1)], [l2(i) l2(i)]);
    dist2=haversine([l1(i) l1(i)], [l2(i) nodes(pos,2)]);

    % assign the node nearest to the centroid of the grid to the OD matrix
    % if it is within a given gridbox, which omits the nodes outside the gridbox
    if (dist1<halfGridSize && dist2<halfGridSize)
        OD(i)=pos;
    end
end

% remove all the nodes that are not within the gridSize
a=find(OD==0);
OD(a) = [];
l1(a) = [];
l2(a) = [];
pop(a) = [];
toc;

% recalculate OD since the matrix dimension has now changed
nOD=length(OD);

tic;
step = 'Processing graph shortest path...';
disp(step);
if exist(fSP,'file')
    SP = spconvert(csvread(fSP));
else  
    h = waitbar(0,step);
    SP = sparse(nOD,nOD);
    for i = 1:nOD
        for j = 1:nOD
            if (i ~= j)
                [SP(i,j),path]=graphshortestpath(DAM,OD(i),OD(j));
                completed = (i-1+j/nOD)/nOD;
                waitbar(completed,h,[step num2str(completed*100) '%']);
            end
        end
    end
    close(h);
    
    [m,n,o] = find(SP);
    SP_dump = [m,n,o];
    dlmwrite(fSP, SP_dump, 'delimiter', ',', 'precision', 10);       
end
toc;

tic;
step = 'Processing max flow...';
disp(step);
if exist(fMF,'file')
    MF = spconvert(csvread(fMF));
else    
    h = waitbar(0,step);
    MF = sparse(nOD,nOD);
    for i = 1:nOD
        for j = 1:nOD
            if (i ~= j)
                MF(i,j)=max_flow(AM,OD(i),OD(j));
                completed = (i-1+j/nOD)/nOD;
                waitbar(completed,h,[step num2str(completed*100) '%']);
            end
        end
    end
    close(h);
    
    [m,n,o] = find(MF);
    MF_dump = [m,n,o];
    dlmwrite(fMF, MF_dump, 'delimiter', ',', 'precision', 10);      
end    
toc;

tic;
step = 'Processing trips...';
disp(step);
if exist(fTR,'file')
    TR = spconvert(csvread(fTR));
else    
    h = waitbar(0,step);
    TR = sparse(nOD,nOD);
    for i = 1:nOD
        for j = 1:nOD
            if i~=j
                TR(i,j)=(pop(i)*pop(j))/SP(i,j);
                completed = (i-1+j/nOD)/nOD;
                waitbar(completed,h,[step num2str(completed*100) '%']);
            end
        end
    end
    close(h);
    
    [m,n,o] = find(TR);
    TR_dump = [m,n,o];
    dlmwrite(fTR, TR_dump, 'delimiter', ',', 'precision', 10);
end
toc;

Sp=full(SP(:));
Tr=full(TR(:));
Mf=full(MF(:));

a=find(Tr==0);
Sp(a) = [];
Tr(a) = [];
Mf(a) = [];

%Tij = (pop(i) x pop(j))/(dist(i,j))^2

%sum(dist==Inf)/length(dist)*100

%b=graphshortestpath(AM,od)

% gplot(AM,nodes,'-*');
% hold on;
% plot3k([nodes(od,1) nodes(od,2) log(pop)]);
% plot3k([l1(:) l2(:) log(pop(:))]);