close all;
clear;
[TR,MF,SP,ODnodes] = getTrips('Manchester',1000,1);

% a=find(SP==Inf);
% SP(SP==Inf)=0;

Sp=full(SP(:));
Tr=full(TR(:));
Mf=full(MF(:));

a=find(Sp==Inf);
Sp(a) = [];
Tr(a) = [];
Mf(a) = [];

Pi=2;
Pj=2;

% Plot the nodes in the network
subplot(Pi,Pj,1);
plot3k([Sp,Tr,Mf]);

subplot(Pi,Pj,2);
plot(Sp,Tr,'.')
xlabel('Shortest path')
ylabel('Trips')

subplot(Pi,Pj,3);
hold on;
p = polyfit(Mf,Sp,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^2 + p(2) * Mf + p(3); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);
plot(Mf(i), r(i), '-','Color','r');
%plot(Mf,Sp,'.')
%boxplot(Sp,Mf);
xlabel('Maximum flow');
ylabel('Shortest path');

subplot(Pi,Pj,4);
hold on;
p = polyfit(Mf,Tr,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) * Mf.^2 + p(2) * Mf + p(3); % compute a new vector r that has matching datapoints in x
[~,i]=sort(Mf);
plot(Mf(i), r(i), '-','Color','r');
%plot(Mf,Tr,'.')
%boxplot(Tr,Mf);
xlabel('Maximum flow');
ylabel('Trips');

figure;
wgPlot(MF,ODnodes);
legend('Max Flow');

figure;
wgPlot(TR,ODnodes);
legend('Trips');

SP(SP==Inf)=0;

figure;
wgPlot(SP,ODnodes);
legend('Shortest Path')
