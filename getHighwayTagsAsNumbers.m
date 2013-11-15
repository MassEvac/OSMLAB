function [highwayQueryResult] = getHighwayTagsAsNumbers(highwayQueryResult)
% Converts highway tags to their highway class equivalent defined by highwayClass
%
% INPUT:
%           highwayQueryResult(:,1:2) (Doubles) - Longitude and Latitude
%           highwayQueryResult(:,3) (Integer) - Index of a given path
%           highwayQueryResult(:,4) (String) - Highway tag
% OUTPUT:
%           highwayQueryResult(:,1:2) (Doubles) - Longitude and Latitude
%           highwayQueryResult(:,3) (Integer) - Index of a given path
%           highwayQueryResult(:,4) (Integer) - Highway class
% EXAMPLE:
%           [highwayQueryResult] = getHighwayTagsAsNumbers({1.0 1.1 1 'motorway'})
% NOTE:
%           Limitation of 7 highway classes due to 7 available colours but
%           not a good enough reason, need to see if there is a more 
%           suitable alternative. Talk to Anders about this.

% The following tags are all the known highway tags:
% motorway, motorway_link
% trunk, trunk_link
% primary, primary_link
% secondary, secondary_link
% tertiary, tertiary_link
% residential, unclassified, road
% pedestrian, service, footway, path
% living_street
% raceway
% track, bridleway
% platform
% proposed, construction
%     'access'
%     'access_ramp'
%     'bridleway'
%     'byway'
%     'construction'
%     'consultation'
%     'conveyor'
%     'crossing'
%     'depot'
%     'disused'
%     'elevator'
%     'escalator'
%     'footpath'
%     'no'
%     'private'
%     'proposed'
%     'raceway'
%     'subway'
%     'track'
%     'unsurfaced'

% also option for tunnel = 'yes'
% http://wiki.openstreetmap.org/wiki/Key:highway

% They will be arbitrarily classed as follows due to common characteristics
highwayClass{1} = {'motorway' 'motorway_link'};
highwayClass{2} = {'trunk' 'trunk_link'};
highwayClass{3} = {'primary' 'primary_link'};
highwayClass{4} = {'secondary' 'secondary_link'};
highwayClass{5} = {'tertiary' 'tertiary_link'};
highwayClass{6} = {'residential' 'unclassified' 'road' 'bus_guideway' 'living_street'};
highwayClass{7} = {'pedestrian' 'service' 'footway' 'path' 'cycleway' 'steps' 'subway' 'footpath' 'elevator' 'escalator' };

highways = [];
highwayType = [];

for i = 1:7
    try
        highways = [highways highwayClass{i}];
        highwayType = [highwayType repmat(i,1,length(highwayClass{i}))];
    catch err
        % Can't really do anything if there is an error
    end
end

highwayTags=highwayQueryResult(:,4);

% Replace the highway tag with its numerical equivalent as defined by highwayClass
highwayQueryResult(:,4)=cellfun(@(x) highwayType(strmatch(x,highways,'exact')),highwayQueryResult(:,4),'UniformOutput',false);
pp=cellfun(@isempty,highwayQueryResult(:,4));
[i,~] = find(pp);

if(i)
    % If the results are being processed for the first time and
    % no numerical equivalent is found for the tag present in
    % the database, it is displayed so that the person
    % processing can make note of it and assess whether it is
    % worth considering or not.
    disp('Omitting the following tags:');
    disp(unique(highwayTags(i)));
    highwayQueryResult(i,:)=[];
end
