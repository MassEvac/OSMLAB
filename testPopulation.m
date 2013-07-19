function testPopulation(l1, l2, population, array_position)
% Should display the population data nearest to the given coordinates
%
% INPUTS:   l1 (Double) - Longitude
%           l2 (Double) - Latitude
%           population (3xn Double Double Integer Matrix) - Population
%               density of a list of coordinates
%
disp(haversine([l2 population(array_position,2)],[l1 population(array_position,1)]));
disp([l1 l2]);
disp('corresponds to:');
disp([p4(array_position,1) p4(array_position,2)]);
