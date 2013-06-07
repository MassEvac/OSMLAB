function getHighwayArray(place)

r = getHighway(place,1:2);

% removes all duplicate coordinates and makes them individual nodes
nodes = unique(r(:,1:2),'rows');

m = length(nodes);
n = 2;

thisNode = 0;
thatNode = 0;

A = sparse(m,m);

tic;
for i = 1:length(r)
    
    if (r(i,3) == 1)
        thisNode = 0;
    else
        thisNode = thatNode;
    end
    
    thatNode = find(any(all(bsxfun(@eq,reshape(r(i,1:2).',1,n,[]),nodes),2),3)); % 41.381587 seconds
    
    if (thisNode && thatNode)
        A(thisNode,thatNode)=r(i,4);
    end
end
t = toc;
toc;

gplot(A,nodes,'k');