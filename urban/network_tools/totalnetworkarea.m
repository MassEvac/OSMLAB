function [area]=totalnetworkarea(DAM,CAM)
[~,~,d] = find(DAM);
[~,~,c] = find(CAM);

area = zeros(length(d),1);

for i = 1:length(d)
    area(i) = d(i)*c(i);
end