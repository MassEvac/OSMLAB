% Return the leaf nodes of the graph - degree 1 nodes
% Note: For a directed graph, leaf nodes are those with a single incoming edge
% Note 2: There could be other definitions of leaves ex: farthest away from a given root node
% Note 3: Nodes with self-loops are not considered leaf nodes.
% Input: adjacency matrix
% Output: indexes of leaf nodes
% Last updated: Mar 25, 2011, by GB

function leaves=leaf_nodes(adj)

% adj=int8(adj>0);
adj=adj>0;
% Commenting this out because for some reason, int8 produces error in this version of matlab

leaves=find(sum(adj)==1);