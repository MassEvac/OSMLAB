function [result] = getFileOrQuery(fileName,query,varargin)
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

fileName = [fileName '.mat'];

disp(query);

tic;
if exist(fileName,'file')
    disp(['Reading cache from ' fileName '...']);
    load(fileName);
else
    disp(['File ' fileName ' does not exist...']);
    disp('Executing query...');
    result = importDB(query);
    
    % Check if there are special conditions with which to process the result

    convertToMatrix = true;
    
    if (nargin > 2)
        if strmatch(varargin{1},'highway')
            result = getHighwayTagsAsNumbers(result);
        elseif strmatch(varargin{1},'nocell2mat')
            convertToMatrix = false;
        end
    end

    if convertToMatrix
        disp('Converting cell to matrix...');
        result = cell2mat(result);
    end
    
    disp(['Saving result to cache file ' fileName '...']);
    save(fileName, 'result'); 
end
toc;
