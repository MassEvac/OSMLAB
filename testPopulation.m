function testPopulation(l1, l2, population, array_position)
% Should display the population data nearest to the given coordinates
%
% INPUTS:   l1 (Double) - Longitude
%           l2 (Double) - Latitude
%           population (3xn Double Double Integer Matrix) - Population
%               density of a list of coordinates
% OUTPUTS:
%           Prints the desired data location
%           Prints the actual data location
%           Prints the distance between the points
% NOTE:
%           The distance between the desired data point and the actual data
%           location depends on the resolution of the data. Currently, the
%           resolution of the currently available data is 2.5 arc minutes.
%
difference = haversine([l1 population(array_position,1)],[l2 population(array_position,2)]);
disp('The population at the following desired location:');
disp([l1 l2]);
disp('is closest to the population count data centroid:');
disp([population(array_position,1) population(array_position,2)]);
disp('The distance between the desired and the actual points in metres is:');
disp(difference);