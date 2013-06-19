[Sp1,Tr1,Mf1] = getTrips('Bristol',1000,1);
[Sp2,Tr2,Mf2] = getTrips('Cardiff',1000,1);
f1 = boxplot(log(Tr1),Mf1);
figure;
f2 = boxplot(log(Tr2),Mf2);