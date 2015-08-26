function [id,labels,table] = process_urban(id,label,labels,table,cities)
    %% Create a working pool
    if matlabpool('size') == 0 
        matlabpool;    
    end
    
    id = id + 1;

    labels{id} = label;

    file = ['./urban/metrics/' label '.mat'];
    try
        load(file)
        disp([label ': loaded from file.']);
    catch err
        col = zeros(length(cities),1);
        parfor i = 1:length(cities)
            try
                fh = str2func(label);
                col(i) = fh(cities{i});
                disp([cities{i} ':' label ': loaded.']);
            catch err
                col(i) = NaN;
                disp([cities{i} ':' label ': failed. ' err.message]);
            end
        end
        save(file, 'col');
    end
    table(:,id) = col;
end

%% Determine number of nodes before
function [result] = nodes_before(place)
    simple = false;
    [nodes,~,~,~] = getAM(place,simple);
    result = length(nodes);
end

%% Determine number of nodes after 
function [result] = nodes_after(place)
    simple = true;
    [nodes,~,~,~] = getAM(place,simple);
    result = length(nodes);
end

%% Determine number of edges before
function [result] = edges_before(place)
    simple = false;
    [~,HAM,~,~] = getAM(place,simple);
    result = nnz(HAM);
end

%% Determine number of edges after 
function [result] = edges_after(place)
    simple = true;
    [~,HAM,~,~] = getAM(place,simple);
    result = nnz(HAM);
end

%% Total network length before
function [result] = length_before(place)
    simple = false;
    [~,~,DAM,~] = getAM(place,simple);
    result = full(sum(sum(DAM)));
end

%% Total network length after
function [result] = length_after(place)
    simple = true;
    [~,~,DAM,~] = getAM(place,simple);
    result = full(sum(sum(DAM)));
end

%% Total network area before
function [result] = area_before(place)
    simple = false;
    [~,HAM,DAM,~] = getAM(place,simple);
    C = 2.5;
    result = sum(totalnetworkarea(DAM,getCAM(HAM,C)));
end

%% Total network area after
function [result] = area_after(place)
    simple = true;
    [~,HAM,DAM,~] = getAM(place,simple);
    C = 2.5;
    result = sum(totalnetworkarea(DAM,getCAM(HAM,C)));
end

%% Average width before
function [result] = width_before(place)
    simple = false;
    [~,HAM,DAM,~] = getAM(place,simple);
    C = 2.5;
    area = sum(totalnetworkarea(DAM,getCAM(HAM,C)));
    length = full(sum(sum(DAM)));
    result = area/length;
end

%% Average width after
function [result] = width_after(place)
    simple = true;
    [~,HAM,DAM,~] = getAM(place,simple);
    C = 2.5;
    area = sum(totalnetworkarea(DAM,getCAM(HAM,C)));
    length = full(sum(sum(DAM)));
    result = area/length; 
end

%% Average degree of the city road network before simplification
function [result] = mean_degree_before(place)
    simple = false;
    [~,~,DAM,~] = getAM(place,simple);
    result = average_degree(DAM);
end

%% Average degree of the city road network after simplification
function [result] = mean_degree_after(place)
    simple = true;
    [~,~,DAM,~] = getAM(place,simple);
    result = average_degree(DAM);
end

%% Connected components of a network before simplification
function [result] = connected_components_before(place)
    simple = false;
    [~,~,DAM,~] = getAM(place,simple);
    result = graphconncomp(DAM);
end

%% Connected components of a network after simplification
function [result] = connected_components_after(place)
    simple = true;
    [~,~,DAM,~] = getAM(place,simple);
    result = graphconncomp(DAM);
end

%% Average number of nodes per connected components of a network before simplification
function [result] = nodes_per_connected_components_before(place)
    simple = false;
    [~,~,DAM,~] = getAM(place,simple);
    result = length(DAM)/graphconncomp(DAM);
end

%% Average number of nodes per connected components of a network after simplification
function [result] = nodes_per_connected_components_after(place)
    simple = true;
    [~,~,DAM,~] = getAM(place,simple);
    result = length(DAM)/graphconncomp(DAM);
end

%% Average number of nodes per connected components of a network before simplification
function [result] = edges_per_connected_components_before(place)
    simple = false;
    [~,~,DAM,~] = getAM(place,simple);
    result = nnz(DAM)/graphconncomp(DAM);
end

%% Average number of edges per connected components of a network after simplification
function [result] = edges_per_connected_components_after(place)
    simple = true;
    [~,~,DAM,~] = getAM(place,simple);
    result = nnz(DAM)/graphconncomp(DAM);
end

%% Network average clustering coefficient before simplification unweighted
function [result] = network_average_clustering_coefficient_before_unweighted(place)
    simple = false;
    [~,HAM,~,~] = getAM(place,simple);
    result = mean(clustering_coefficients(logical(HAM)));
end

%% Network average clustering coefficient after simplification unweighted
function [result] = network_average_clustering_coefficient_after_unweighted(place)
    simple = true;
    [~,HAM,~,~] = getAM(place,simple);
    result = mean(clustering_coefficients(logical(HAM)));
end

%% Network average clustering coefficient before simplification weighted
function [result] = network_average_clustering_coefficient_before_weighted(place)
    simple = false;
    [~,HAM,~,~] = getAM(place,simple);
    C = 2.5;
    result = mean(clustering_coefficients(getCAM(HAM,C)));
end

%% Network average clustering coefficient after simplification weighted
function [result] = network_average_clustering_coefficient_after_weighted(place)
    simple = true;
    [~,HAM,~,~] = getAM(place,simple);
    C = 2.5;
    result = mean(clustering_coefficients(getCAM(HAM,C)));
end

%% Betweenness centrality weighted
function [result] = btc_weighted(place)
    [btc] = getBetweennessCentrality(place, true);
    result = mean(btc);
end

%% Betweenness centrality unweighted
function [result] = btc_unweighted(place)
    [btc] = getBetweennessCentrality(place, false);
    result = mean(btc);
end

%% Number of leaf nodes
function [result] = no_leaf_nodes(place)
    simple = true;
    [~,HAM,~,~] = getAM(place,simple);
    result = length(leaf_nodes(HAM));
end

%% Number of leaf edges
function [result] = no_leaf_edges(place)
    simple = true;
    [~,HAM,~,~] = getAM(place,simple);
    result = length(leaf_edges(HAM));
end

%% Percent of nodes that are leaf nodes
function [result] = fraction_leaf_nodes(place)
    leaves = no_leaf_nodes(place);
    nodes = nodes_after(place);
    result = leaves/nodes;
end

%% Number of edges that are leaf edges
function [result] = fraction_leaf_edges(place)
    leaves = no_leaf_edges(place);
    edges = edges_after(place);
    result = leaves/edges;
end

%% Average path length of the city road network
function [result] = mean_path_length(place)
    simple = true;
    [~,~,DAM,~] = getAM(place,simple);
    result = ave_path_length(DAM);
end

%% Area of the city boundary
function [result] = boundary_area(place)
    result = getBoundaryArea(place);
end