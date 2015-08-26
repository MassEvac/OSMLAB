function [meanbcnX]=betweenessfull(HAM,DAM,nodes,x)
%Run simplifyAM
sHAM=simplifyAM(HAM,DAM,nodes);
save('sHAM.mat', 'sHAM');
%Run betweenness Centrality code
bcX=betweenness_centrality(sHAM);
%normalise the result
n=length(bcX);
bcnX=bcX/(((n-1)*(n-2))/2);

meanbcnX=mean(bcnX);
BC(x,1)=meanbcnX;
end