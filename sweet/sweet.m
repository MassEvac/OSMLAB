% Twitter feed monitoring script
% Monitors twitter feed with the tags described by d in realtime
%
% INPUT
%           d{i} (String) - disaster related tag to monitor
% OUTPUT
%           dc(i) (Integer Matrix) - count of tweets corresponding to d{i}
%           Live graph plot of the tweet counts
%           Bar chart of the cumulative number of tweets
% KNOWN ISSUES
%           At the moment, the API stops working due to query rate limits.
%           Perhaps need to increase interval before it works reliably.
%           ERROR 429
%
credentials.ConsumerKey = '2Ilp7VJlOJU17GtvL2S5Tg';
credentials.ConsumerSecret = 'j77edX0NxgLczr7iWBYYtOMbpXMF6yCqnxQsGzEBo';
credentials.AccessToken = '23425855-5nje1f6D0LFeQLk6WobpcWFPOJB9uADhLCHRIZiJc';
credentials.AccessTokenSecret = 'M6FuusFhfOWbOLNBic3si7UOHcK5KGTyvGkT50EHf0M';

t = twitty(credentials);

London = '51.5171,0.1062,100mi';
Bristol = '51.4600,-2.6000,10mi';

% Interval to check twitter in seconds
interval = 60;

% Disasters
d = {'earthquake' 'tsunami' 'terror attack' 'volcano' 'avalanche' 'flood' 'cyclone' 'tornado' 'hurricane'};
[~,ds] = size(d);

if ~exist('since')
    since(1:ds) = {'0'};
end

if ~exist('dc')
    dc = zeros(1,ds);
end

if ~exist('output')
    output = zeros(1,ds);
end

hold on;

% Get the first result to search from
for disaster = 1:ds
    s = cell2mat(t.search(d(disaster),'rpp','1','since_id',since(disaster)));
    p = s.statuses;
    if ~isempty(p)
        results = cell2mat(p(1));
        since(disaster) = {results.id_str};
    end
end

% Loop forever to find tweets related to the search tags
while 1
    for disaster = 1:ds
        s = cell2mat(t.search(d(disaster),'rpp','10','since_id',since(disaster)));
        p = s.statuses;

        if ~isempty(p)
            [~,n] = size(p);
            for i = n:-1:1
                results = cell2mat(p(i));
                disp([results.created_at ' : ' results.text]);
                dc(disaster) = dc(disaster) + 1;
            end    
            if ~strcmp(since(disaster),results.id_str)
%                 disp(['Displaying results since ' since(disaster)]); 
                disp(['News for ' d(disaster)]);
                since(disaster) = {results.id_str};
            end
        end
    end
    output = [output;dc];
%     dc = zeros(1,ds);
    subplot(2,1,1);
    plot(output);
    legend(d,'Location','NorthWest');
    subplot(2,1,2);    
    bar(output(end,:))
    set(gca,'XTickLabel',d,'FontSize',14)    
    pause(interval);
end

% 1. S = tw.search('matlab'); % search twitter.com for messages including the word 'matlab'.
% 2. S = tw.updateStatus('Hello, Twitter!'); % or twit something cooler.
% 3. S = tw.publicTimeline(); % get 20 recent public messages.
% 4. S = tw.userTimeline('screen_name', 'matlab'); % get recent messages posted by the user 'matlab';
% 5. S = tw.trendsDaily(datestr(now-1,'yyyy-mm-dd')); % get yesterday's trends.
