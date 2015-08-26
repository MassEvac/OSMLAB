function [amenityCount] = getPopulationAmenityTable(amenityTags,places,gridSize,sigma,texFile)
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
%           getPopulationAmenityTable({'bar','hospital','atm'},{'London','Bristol'},400,2,'testTable.tex')

p = length(places);
a = length(amenityTags);

amenityCount = zeros(p,a);

population = zeros(p,1);

for i = 1:p
    for j = 1:a
        [amenityCount(i,j),~] = size(getAmenity(amenityTags{j}, places{i}));
    end
    populationGrid = getPopulationGrid(places{i},gridSize,sigma);
    population(i) = round(sum(sum(populationGrid)));    
end

latextable([population amenityCount],'format','%0.0f','horiz',['population'; amenityTags],'vert',places,'name',texFile,'Hline',[1],'Vline',[1])