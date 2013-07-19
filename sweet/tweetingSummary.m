function tweetingSummary(twty,S)
% Compute some descriptive statistics summarizing users tweeting activity.
%
% This is an example of a twitty's output function which can be used to process the statuses
% retrieved from the Twitter platform via its Search or (in particular) Streaming API.
% The function monitors the tweeters activity by keeping track of some descriptive statistics
% accumulated over a user-defined number of tweets, twitty_obj.sampleSize.
% The results are stored in the dedicated variable, the twitty_obj.data structure;
%
% The statistics are the following:
%  - tweetscnt:   number of genuine tweets (not, e.g., deleted statuses);
%  - originalcnt: number of "origianal tweets", i.e., tweets not mentioning or retweeting other users;
%  - mentionscnt: a 2-element vector: (1) number of "genuine replies mentions" (not retweets), 
%                                     (2) number of retweets mentions;
%  - hashtagscnt: number of tweets containing at least one hashtag;
%  - urlscnt:     number of tweets containing an URL link. 
%
% Usage: tweetingSummary(twty,S)
% INPUT:
%  twty - the instance of the twitty class.
%  S    - cell array of structures containing the tweets to analyse. 
% OUTPUT: none. 
%         Computed statistics are stored in the twitty's designated property: 'twty.data'.
%
% Example: 
%  tw=twitty; tw.sampleSize = 3000; tw.outFcn = @tweetingSummary; tw.sampleStatuses; tw.data;
%
% NB: you can continue to keep track of those statistics by running 'tw.sampleStatuses' again.
%     In case, you would like to start over, you have to deinitialize the output function by
%     setting  'tw.data.outFcnInitialized = 0'.

% Check the input:
narginchk(2, 2);

% Parse input:
if length(S)==1 && isfield(S{1}, 'statuses')
    T = S{1}.statuses;
else
    T = S;
end

% Initialization:
if ~twty.data.outFcnInitialized
    twty.data.tweetscnt = 0;   % general number of tweets.
    twty.data.originalcnt = 0; % number of original tweets (not retweets or mentioning others).
    twty.data.mentionscnt = [0, 0]; % number of mentions: replies and retweets.    
    twty.data.hashtagscnt = 0;  % number of tweets containing a hashtag.
    
    twty.data.urlscnt = 0;      % number of tweet containing an url link.
    
    % Initialization done.
    twty.data.outFcnInitialized = 1; 
end

% Process tweets:
for ii=1:length(T)
    if isfield(T{ii},'entities')
        twty.data.tweetscnt = twty.data.tweetscnt+1;
        if ~isempty(T{ii}.entities.hashtags), twty.data.hashtagscnt = twty.data.hashtagscnt+1; end
        if ~isempty(T{ii}.entities.user_mentions)
            if strfind(T{ii}.text,'RT @') 
                twty.data.mentionscnt(2) = twty.data.mentionscnt(2)+1;
            else
                twty.data.mentionscnt(1) = twty.data.mentionscnt(1)+1;
            end
        else
            twty.data.originalcnt = twty.data.originalcnt+1;
        end
        if ~isempty(T{ii}.entities.urls), twty.data.urlscnt = twty.data.urlscnt+1; end
    end
end

% Display a "progress bar":
clc;
disp(['Tweets processed: ' num2str(twty.data.tweetscnt) ' (out of ' num2str(twty.sampleSize) ').']);
end

