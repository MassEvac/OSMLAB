credentials.ConsumerKey = '2Ilp7VJlOJU17GtvL2S5Tg';
credentials.ConsumerSecret = 'j77edX0NxgLczr7iWBYYtOMbpXMF6yCqnxQsGzEBo';
credentials.AccessToken = '23425855-TBOpPBQydn1nKqOkMZAmKWQhVBdnGGV2vdSaQDzfR';
credentials.AccessTokenSecret = 'VRCWAZcBL80jqlgRrSKz9zKePWXdAcbJ1yRRNYukc';

disp(credentials);

t = twitty(credentials);

c = [ 51.5171 0.1062 ];
s = cell2mat(t.geoSearch('query','london','coord',c,'granularity','city'));
p = cell2mat(s.result.places);
[~,n] = size(p);


for i = 1:n
    results = p(i).;
    disp(results.text);
end    


% 1. S = tw.search('matlab'); % search twitter.com for messages including the word 'matlab'.
% 2. S = tw.updateStatus('Hello, Twitter!'); % or twit something cooler.
% 3. S = tw.publicTimeline(); % get 20 recent public messages.
% 4. S = tw.userTimeline('screen_name', 'matlab'); % get recent messages posted by the user 'matlab';
% 5. S = tw.trendsDaily(datestr(now-1,'yyyy-mm-dd')); % get yesterday's trends.