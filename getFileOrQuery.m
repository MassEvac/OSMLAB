function [result]=getFileOrQuery(filename,query,varargin)
% Either returns the cache or runs the query and saves it to cache
%
% INPUT:
%           filename (String) - Name of the cache file to read
%           query (String) - Query to execute if the cache doesn't exist
%           varargin (Cell) - Describes special conditions for certain
%               types of queries such as 'highway'
% OUTPUT:
%           result (Cell) - The result from the cache or database
%
if exist(filename,'file')
    result = csvread(filename);
else
    result = importDB(query);
    % Check if there are special conditions with which to process the result
    if (nargin > 2)
        if (strmatch(varargin{1},'highway'))
            result = getHighwayTagsAsNumbers(result);
        end
    end
   
    result = cell2mat(result);
    dlmwrite(filename, result, 'delimiter', ',', 'precision', 10); 
end