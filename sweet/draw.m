% Reads the twitter monitoring statistics from a text file and displays it
%
% INPUT:
%           text file with disaster statistics
% OUTPUT:
%           plot of the statistic
%
d = {'earthquake' 'tsunami' 'terror attack' 'volcano' 'avalanche' 'flood' 'cyclone' 'tornado' 'hurricane'};
p = csvread('disaster30.txt');

%set(0,'DefaultAxesColorOrder',[0 0 0],'DefaultAxesLineStyleOrder','-|-.|--|:');

figure;
plot(p(:,1:7),'.');
legend(d,'Location','NorthWest');
set(gcf,'Position', [0, 0, 800, 300]);
set(gca,'FontSize',14);
xlabel('Time(seconds) / 30 seconds');
ylabel('Cumulative Tweets');
savefig('tweets.pdf','pdf');