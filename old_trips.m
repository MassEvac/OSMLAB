function [Tr,Mf] = trips(place)

fMF = ['./cache/highwayMaxFlow-' place];
fTR = ['./cache/highwayTrips-' place];

if (and(exist(fMF,'file'),exist(fTR,'file')))
    MF = spconvert(csvread(fMF));
    TR = spconvert(csvread(fTR));
else    
    tic;
    disp(['Reading adjacency matrix for ' place '...']);
    gridSize = 500; % Need to do a significance testing to see if this is viable
    sigma = 1;

    [pop,l1,l2]=getSmoothPopulationGrid(place,gridSize,sigma);
    [AM,DAM,nodes]=getAM(place);

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
    disp('Processing origin/destination vector..');
    l1=l1(:);
    l2=l2(:);   
    pop=pop(:);

    nOD=length(pop);

    % origin/destination matrix
    od=zeros(nOD,1);

    halfGridSize = gridSize/2;

    for i=1:nOD
        ldiff = abs(nodes(:,1) - l1(i)) .* abs(nodes(:,2) - l2(i));
        [~, pos] = min(ldiff);

        dist1=haversine([l1(i) nodes(pos,1)], [l2(i) l2(i)]);
        dist2=haversine([l1(i) l1(i)], [l2(i) nodes(pos,2)]);

        if (dist1<halfGridSize && dist2<halfGridSize)
            od(i)=pos;
        end
    end

    a=find(od==0);
    od(a) = [];
    l1(a) = [];
    l2(a) = [];
    pop(a) = [];
    toc;

    tic;
    disp('Processing graph shortest path and max flow...');

    nOD = length(od);
    nAM = length(AM);
    b = 1.5;

    % Shortest path
    SP = sparse(nOD,nOD);
    % Max capacity on the shortest route
    MF = sparse(nOD,nOD);
    for i = 1:nOD
        % calculating the original shortest path
        for j = 1:nOD
            if (i ~= j)
                [SP(i,j),path]=graphshortestpath(DAM,od(i),od(j));
    %             this = D(i,j);
    %             L = b * this; % Longest path distance
    %             % duplicate the adjacency matrix so that
    %             % the edges with the minimal flow can be removed
    %             dDAM = DAM;
    %             isolatedAM = spalloc(nAM,nAM,0);
    %             while (this < L || this ~= Inf)
    %                 origin=path(1:end-1);
    %                 destin=path(2:end);
    %                 nThis = length(origin);
    %                 
    %                 % clear this AM
    %                 thisAM = spalloc(nAM,nAM,0);
    % 
    %                 for k = 1:nThis
    %                     % copy the edges to a new sparse matrix for use in Ford
    %                     % Fulkerson algorithm                
    %                     thisAM(origin(k),destin(k)) = AM(origin(k),destin(k));
    %                     isolatedAM(origin(k),destin(k)) = thisAM(origin(k),destin(k));
    %                 end
    %                 
    %                 % extract the values of this AM
    %                 [~,~,o]=find(thisAM);
    %                 % find the maximum values of this AM
    %                 [m,n]=find(thisAM==max(o));
    %                 % remove the maximum values from this AM
    %                 dDAM(m,n)=0;
    %                 % recalculate the shortest path and the nodes from the path
    %                 [this,path]=graphshortestpath(dDAM,od(i),od(j));
    %             end
    %           CP(i,j)=max_flow(isolatedAM,od(i),od(j));
                MF(i,j)=max_flow(AM,od(i),od(j));

                disp([num2str((i-1+j/nOD)/nOD*100) '%']);
            end
        end
        %disp([num2str(i/nOD*100) '%']);
    end
    toc;

    tic;
    disp('Processing trips...');
    TR = sparse(nOD,nOD);
    for i = 1:nOD
        for j = 1:nOD
            if i==j
                TR(i,j)=0;
            else
                TR(i,j)=(pop(i)*pop(j))/SP(i,j);
            end
        end
    end
    toc;

    tic;
    disp('Writing Max Flow and Trips to file...');
    [m,n,o] = find(MF);
    MF_dump = [m,n,o];
    
    [m,n,o] = find(TR);
    TR_dump = [m,n,o];
    
    dlmwrite(fMF, MF_dump, 'delimiter', ',', 'precision', 10);
    dlmwrite(fTR, TR_dump, 'delimiter', ',', 'precision', 10);
    toc;
end

Tr=full(TR(:));
Mf=full(MF(:));

a=find(Tr==0);
Tr(a) = [];
Mf(a) = [];

%Tij = (pop(i) x pop(j))/(dist(i,j))^2

%sum(dist==Inf)/length(dist)*100

%b=graphshortestpath(AM,od)

% gplot(AM,nodes,'-*');
% hold on;
% plot3k([nodes(od,1) nodes(od,2) log(pop)]);
% plot3k([l1(:) l2(:) log(pop(:))]);