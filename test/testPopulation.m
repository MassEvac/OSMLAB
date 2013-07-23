function testPopulation(requiredCoordinates, actualCoordinates)
% Should display the population data nearest to the given coordinates
%
% INPUT:   
%           l1 (Double) - Longitude
%           l2 (Double) - Latitude
%           population (3xn Double Double Integer Matrix) - Population
%               density of a list of coordinates
% OUTPUT (Printed Only):
%           The co-ordinate of desired population data
%           The co-ordinate of nearest population data
%           The distance between the desired and the nearest point in metre
% NOTE:
%           The distance between the desired data point and the actual data
%           location depends on the resolution of the data. Currently, the
%           resolution of the currently available data is 2.5 arc minutes.
%
difference = haversine([requiredCoordinates(1) actualCoordinates(1)],[requiredCoordinates(2) actualCoordinates(2)]);
disp('The population at the following required location:');
disp([requiredCoordinates(1) requiredCoordinates(2)]);
disp('is closest to the population count data centroid:');
disp([actualCoordinates(1) actualCoordinates(2)]);
disp('The distance between the desired and the actual points in metres is:');
disp(difference);