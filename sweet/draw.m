function drawSavedSweet(f)
% Reads the twitter monitoring statistics from a text file and displays it
%
% INPUT:
%           f (String) - Text file with disaster statistics
% OUTPUT:
%           Plot of the statistic
% EXAMPLE:
%           drawSavedSweet('disaster30.txt');

d = {'earthquake' 'tsunami' 'terror attack' 'volcano' 'avalanche' 'flood' 'cyclone' 'tornado' 'hurricane'};
p = csvread(f);

figure;
plot(p(:,1:7),'.');
legend(d,'Location','NorthWest');
set(gcf,'Position', [0, 0, 800, 300]);
set(gca,'FontSize',14);
xlabel('Time(seconds) / 30 seconds');
ylabel('Cumulative Tweets');
savefig('tweets.pdf','pdf');