function [AM] = getResizedAM(AM,AMLength)
% Makes the spare matrix square so that both i and j dimensions are equal
%
% INPUT:
%           AM(i,j) (Double) - Value of adjacency matrix at index i, j
%           AMLength (Integer) - Size of the adjacency matrix (Optional)
% OUTPUT:
%           AM(i,j) (Double) - Resized square adjacency matrix
% EXAMPLE:
%           [AM] = getResizedAM(sparse(4,6),7)
% NOTE:
%           Not very sophisticated but currently does the job.
%           Define AMLength only if the matrix is supposed to be bigger
%           than the length of the inputted adjacency matrix

% If AMLength is not defined, assign the length of the matrix to it

if size(AM,1) ~= AMLength || size(AM,2) ~= AMLength
    AM(AMLength,AMLength) = 0;
end