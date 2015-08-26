% edge_connectivity.m
% Ray Byrne
% 7/29/05
% function edge_connectivity(A) returns the edge connectivity of a
% graph G described by the adjacency matrix A
function k_edge = edge_connectivity(A)
N = length(A);
% check 0 connectivity
if (graph_connected(A))
else
k_edge = 0;
return
end % else
% count edges, store edges in I,J
I = [];
J = [];
for i = 2:N % i is row index
for j = 1:(i-1) % j is column index
if (A(i,j) ~= 0) % check neq 0 to allow weighted edges
I = [I; i]; % store list of edges
J = [J; j]; % store list of edges
end % for
end % for
end % for
edge_count = length(I);
for K = 1:edge_count % % check K connectivity
C = nchoosek( 1:edge_count, K); % calculate all combinations
num_tests = length(C);
for j = 1:num_tests
del_list = C(j,:); % pull out a row of C
A_temp = A;
for k = 1: length(del_list)
A_temp(I(del_list(k)),J(del_list(k))) = 0; % delete edges
A_temp(J(del_list(k)),I(del_list(k))) = 0; % delete edges
end
if ( ~graph_connected(A_temp) )
k_edge = K;
for k = 1: length(del_list) % list out set of edges that breaks connectivity
broken_I = I(del_list(k))
broken_J = J(del_list(k))
end % for
return;
end % if
end % for
end % for
return;