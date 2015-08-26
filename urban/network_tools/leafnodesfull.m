function l=leafnodesfull(HAM);

x=logical(HAM);
y=full(x);
z=leaf_nodes(y);
l=length(z);
save('leafnodes.mat','z');

end
