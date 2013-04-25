function [r, s] = getCorrelation(grid)
n = length(grid);

[o, p] = size(grid{1});

a = zeros(o*p,n);

for i=1:n
    a(:,i) = grid{i}(:);
end

[r, s] = corrcoef(a);