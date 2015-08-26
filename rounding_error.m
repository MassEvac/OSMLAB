H1=sprand(1000,1000,.4);
g=sprand(1000,1,.5);
x=H1*g;
H2=full(H1);
x2=full(x);

g1=H1\x;
g2=H2\x2;

difference=norm(g1-g2,Inf)
errorSparse=norm(g1-g,Inf)
errorFull=norm(g2-g,Inf)
