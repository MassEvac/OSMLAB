function [HAM,DAM,nodes]=jam(HAM,DAM,nodes,nodenumber)

h = waitbar(0,['CALCULATING JAM']);

jHAM=jamtheunconnectednodes(HAM,DAM,nodes,nodenumber);

waitbar(0.5,h,['CALCULATING BETWEENESS CENTRALITY']);

bc=betweenness_centrality(jHAM);

%normalise the result
n=length(bc);
bcn=bc/(((n-1)*(n-2))/2);

meanbcn=mean(bcn);
disp(['Mean Betweenness Centrality = ' num2str(meanbcn)]);

waitbar(0.75,h,['CALCULATING LEAF NODES']);

l=leafnodesfull(jHAM);

waitbar(1,h);
close(h);

disp(['Number of Leaf Nodes = ' num2str(l)]);
disp(['Total number of nodes = ' num2str(length(jHAM))]);