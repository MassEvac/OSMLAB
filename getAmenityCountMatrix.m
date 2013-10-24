function [amenityCount] = getAmenityCountMatrix(amenityTags,places,texFile)
% Spits out the amenity count in each city in latex table format
%
% INPUT:
%           places(i) (String) - Names of polygon areas in OpenSteetMap
%           amenityTags(j) (String) - Name of the amenities to consider
%           texFile (String) - Name of the tex file to save the output to
% OUTPUT:
%           File defined by texFile which contains the latex table
%           amenityCount(i,j) - which is the number of amenityTags(j)
%              amenities in places(i)
% EXAMPLE:
%           getAmenityCountMatrix({'London','Bristol'},{'bar','hospital','atm'},'table.txt')

p = length(places);
a = length(amenityTags);

amenityCount = zeros(p,a);

for i = 1:p
    for j = 1:a
        [amenityCount(i,j),~] = size(getAmenity(amenityTags{j}, places{i}));
    end
end

latextable(amenityCount,'horiz',amenityTags,'vert',places,'name',texFile,'Hline',[1],'Vline',[1])