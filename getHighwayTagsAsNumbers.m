function [highwayQueryResult] = getHighwayTagsAsNumbers(highwayQueryResult)
% Converts highway tags to their highway class equivalent defined by highwayClass
%
% INPUT:
%           highwayQueryResult(:,1:2) (Doubles) - Longitude and Latitude
%           highwayQueryResult(:,3) (Integer) - Index of a given path
%           highwayQueryResult(:,4) (String) - Highway tag
%           highwayQueryResult(:,5) (String) - Oneway or not
% OUTPUT:
%           highwayQueryResult(:,1:2) (Doubles) - Longitude and Latitude
%           highwayQueryResult(:,3) (Integer) - Index of a given path
%           highwayQueryResult(:,4) (Integer) - Highway class
%           highwayQueryResult(:,4) (Boolean) - Oneway or not
% EXAMPLE:
%           [highwayQueryResult] = getHighwayTagsAsNumbers({1.0 1.1 1 'motorway'})
% NOTE:
%           Limitation of 7 highway classes due to 7 available colours but
%           not a good enough reason, need to see if there is a more 
%           suitable alternative. Talk to Anders about this.

% Load the highway classification file
% Note that '7' is assigned to all the highway tags not described in the highway classification
disp('Processing highway...');

tic;
load('scope/highwayClassification.mat','highwayClassification');
highways = highwayClassification(:,1);
highwayType = cell2mat(highwayClassification(:,2));

% Replace the highway tag with its numerical equivalent as defined by highwayClass
highwayQueryResult(:,4)=cellfun(@(x) highwayType(strmatch(x,highways,'exact')),highwayQueryResult(:,4),'UniformOutput',false);

% Find all the blank cells and assign highway class 7 to them
pp=cellfun(@isempty,highwayQueryResult(:,4));
[i,~] = find(pp);
highwayQueryResult(i,4)=num2cell(7);

oneway = zeros(1,length(highwayQueryResult));
oneway(strmatch('yes',highwayQueryResult(:,5),'exact')) = 1;

% Replace the original column with the numerated column
highwayQueryResult(:,5) = num2cell(oneway);
toc;
