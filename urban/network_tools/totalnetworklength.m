function [dist]=totalnetworklength(DAM)

x=sum(DAM);
dist=sum(x);
disp(['Total Network Length = ' num2str(dist)]); 