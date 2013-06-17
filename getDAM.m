function [DAM] = getDAM(place)
% get the adjacency matrix containing the length of the edges

fDAM = ['./cache/highwayDAM-' place];

if (and(exist(fNode,'file'),exist(fDAM,'file')))
    nodes = csvread(fNode);
    DAM = spconvert(csvread(fDAM));
    
    pSize = length(DAM);
    
    if size(DAM,1) ~= pSize || size(DAM,2) ~= pSize
        DAM(pSize,pSize) = 0;
    end
else
    [AM, nodes] = getAM(place);

    tic;
    [i,j]=find(AM);

    p = nodes(i,1);
    q = nodes(j,1);
    r = nodes(i,2); 
    s = nodes(j,2);

    d=arrayfun(@(w,x,y,z) haversine([w x],[y z]),p,q,r,s);

    DAM=sparse(i,j,d);
    
    [p,q,r] = find(DAM);
    A_dump = [p,q,r];
    
    dlmwrite(fDAM, A_dump, 'delimiter', ',', 'precision', 10);    
    toc;
end