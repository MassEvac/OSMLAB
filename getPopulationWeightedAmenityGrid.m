function [result] = getPopulationWeightedAmenityGrid(amenityGrids,populationGrid)
% number of each of the amenities
[p,q]=size(populationGrid);
[~,n] = size(amenityGrids);
result = [];

for a = 1:n,
    amenityGrid = amenityGrids{a};
    % create empty matrices with zeroes to count the number of amenities that
    % fall within the each of the grid  
    populationWeightedAmenityGrid = zeros(p,q);
    for i = 1:p,
        for j = 1:q,
            this = amenityGrid(i,j) / populationGrid(i,j);
            if (populationGrid(i,j) == 0) 
                this = amenityGrid(i,j);
            end   
            populationWeightedAmenityGrid(i,j) = this;
        end
    end
    result = [result {populationWeightedAmenityGrid}];
end    