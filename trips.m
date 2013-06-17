clear;

tic;
disp('Reading adjacency matrix..');
gridSize = 500;
sigma = 1;

[pop,l1,l2]=getSmoothPopulationGrid('Bristol',gridSize,sigma);
[AM,DAM,nodes]=getAM('Bristol');

% Undirected network
AM = AM + AM';
DAM = DAM + DAM';
toc;

tic;
disp('Processing origin/destination vector..');
l1=l1(:);
l2=l2(:);   
pop=pop(:);

n=length(pop);

% origin/destination matrix
od=zeros(n,1);

halfGridSize = gridSize/2;

for i=1:n
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

n = length(od);

% Shortest path
D = sparse(n,n);
% Max capacity on the shortest route
F = sparse(n,n);
for i = 1:n
    disp([num2str(i/n*100) '%']);
    [D(i,:),path]=graphshortestpath(DAM,od(i),od);
    for j = 1:n
        if ~(i == j)
            thisPath = path{j};
            [~,~,k]=find(AM(thisPath(1:end-1),thisPath(2:end)));
            if k
                minimumFlow=max(k);
                F(i,j)=minimumFlow;
            end
        end
    end
end
toc;

tic;
disp('Processing trips...');
T = sparse(n,n);
for i = 1:n
    for j = 1:n
        if i==j
            T(i,j)=0;
        else
            T(i,j)=(pop(i)*pop(j))/D(i,j);
        end
    end
end
toc;

Tt=full(T(:));
Ff=full(F(:));

a=find(Tt==0);
Tt(a) = [];
Ff(a) = [];

boxplot(log(Tt),Ff);

%Tij = (pop(i) x pop(j))/(dist(i,j))^2

%sum(dist==Inf)/length(dist)*100

%b=graphshortestpath(AM,od)

% gplot(AM,nodes,'-*');
% hold on;
% plot3k([nodes(od,1) nodes(od,2) log(pop)]);
%plot3k([l1(:) l2(:) log(pop(:))]);



%imagesc(population,);
% 1. make a list of origin/destination nodes by comparing the list
% of latitudes and longitudes with the node list and finding the nodes
% closest to them. origins and destination will be p
% 2. calculate the distance from node i's->j's.
% 2. each point represents the number of people in that proximity.
% calculate Tij from i->j by using this value.
% 3. 

