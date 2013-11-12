function [result] = getFileOrQuery(filename,query,varargin)
% Either returns the cache or runs the query and saves it to cache
%
% INPUT:
%           filename (String) - Name of the cache file to read
%           query (String) - Query to execute if the cache doesn't exist
%           varargin (Cell) - Describes special conditions for certain
%               types of queries such as 'highway'
% OUTPUT:
%           result (Cell) - The result from the cache or database
% EXAMPLE:
%           Example too complicated, run one of the following to see if
%           this script works as these are depending on this script:
%               [result] = getHighway('Bristol')
%               [result] = getPopulation('Bristol')
%               [result] = getAmenity('bar', 'Bristol')

filename = [filename '.mat'];

if exist(filename,'file')
    disp(['Reading cache from ' filename '...']);
    load(filename);
else
    disp('Executing query...');
    disp(query);
    result = importDB(query);
    
    % Check if there are special conditions with which to process the result
    if (nargin > 2)
        if (strmatch(varargin{1},'highway'))
            disp('Processing highway...');
            result = getHighwayTagsAsNumbers(result);
        end
    end
   
    result = cell2mat(result);
    disp(['Saving result to cache file ' filename '...']);
    save(filename, 'result'); 
end