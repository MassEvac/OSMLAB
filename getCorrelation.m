function [r, p] = getCorrelation(grids)
% Returns the correlation coefficient and P-value of the input multiple grids
%
% INPUT:
%           grids{i}(j,k) (Double) - i number of Grids with values in (j,k) indices
% OUTPUT:
%           r(i,i) (Double) - Correlation coefficients between grids{i}
%           p(i,i) (Double) - P-values between grids{i}
% EXAMPLE:
%           [r, p] = getCorrelation(getAmenityGrids({'bar','atm','hospital'},'Bristol',250,1,true))

% Establish the number of grids inputted
n = length(grids);

% All grids should be the same size so just measure the size of the first grid
[x, y] = size(grids{1});

% Convert the grids into a series of 1 dimensional arrays
a = zeros(x*y,n);

for i=1:n
    a(:,i) = grids{i}(:);
end

% Find the correlation coefficient and p-value of the matrix
[r, p] = corrcoef(a);