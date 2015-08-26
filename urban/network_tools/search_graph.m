% search_graph.m
% Ray Byrne, 7/29/05
% Dept 15234
% the function search_graph.m is a recursive function
% used in a DFS search of a graph to determine if
% all nodes are connected
function [DFS_number, DFS, visited] = search_graph(I, DFS_number, DFS, visited, A)
DFS_number = DFS_number + 1;
DFS(I) = DFS_number;
visited(I) = 1;
A_row = A(I,:);
N = length(A_row);
for i=1:N
if (A_row(i) > 0) && (visited(i) == 0) % check > 0 to allow weighted connections
[DFS_number, DFS, visited] = search_graph(i,DFS_number, DFS, visited,A);
end % if
end % for