%% Initialise
clear;
chdir('~/Google Drive/OSM/urban');

id = 0;
table = [];
labels = [];

% Load the list of cities
fid = fopen('cities.txt');
allData = textscan(fid,'%s','Delimiter','\n');
cities=allData{1};

%%
[id, labels, table] = process_urban(id, 'nodes_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'nodes_after', labels, table, cities);
[id, labels, table] = process_urban(id, 'edges_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'edges_after', labels, table, cities);
%[id, labels, table] = process_urban(id, 'length_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'length_after', labels, table, cities);
%[id, labels, table] = process_urban(id, 'area_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'area_after', labels, table, cities);
%[id, labels, table] = process_urban(id, 'width_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'width_after', labels, table, cities);
[id, labels, table] = process_urban(id, 'mean_degree_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'mean_degree_after', labels, table, cities);
[id, labels, table] = process_urban(id, 'connected_components_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'connected_components_after', labels, table, cities);
[id, labels, table] = process_urban(id, 'network_average_clustering_coefficient_before_unweighted', labels, table, cities);
[id, labels, table] = process_urban(id, 'network_average_clustering_coefficient_after_unweighted', labels, table, cities);
[id, labels, table] = process_urban(id, 'network_average_clustering_coefficient_before_weighted', labels, table, cities);
[id, labels, table] = process_urban(id, 'network_average_clustering_coefficient_after_weighted', labels, table, cities);
[id, labels, table] = process_urban(id, 'nodes_per_connected_components_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'nodes_per_connected_components_after', labels, table, cities);
[id, labels, table] = process_urban(id, 'edges_per_connected_components_before', labels, table, cities);
[id, labels, table] = process_urban(id, 'edges_per_connected_components_after', labels, table, cities);
[id, labels, table] = process_urban(id, 'no_leaf_nodes', labels, table, cities);
[id, labels, table] = process_urban(id, 'no_leaf_edges', labels, table, cities);
[id, labels, table] = process_urban(id, 'fraction_leaf_nodes', labels, table, cities);
[id, labels, table] = process_urban(id, 'fraction_leaf_edges', labels, table, cities);
% [id, labels, table] = process_urban(id, 'mean_path_length', labels, table, cities);
[id, labels, table] = process_urban(id, 'boundary_area', labels, table, cities);
[id, labels, table] = process_urban(id, 'btc_weighted', labels, table, cities);
[id, labels, table] = process_urban(id, 'btc_unweighted', labels, table, cities);

%%
load('../../Dropbox/MassEvac/analysis/features-32-cities-70.mat')
sim = {'population', 'no_destin_nodes', 'no_destin_edges', 'destin_width', 'mean_destin_dist', 'std_destin_dist', 'mean_agents_per_destin', 'std_agents_per_destin', 'T_mu_ff', 'T_sigma_ff', 'T_median_ff', 'T_ninetieth_ff', 'T_mu_ia', 'T_sigma_ia', 'T_median_ia', 'T_ninetieth_ia', 'T_mu_cd', 'T_sigma_cd', 'T_median_cd', 'T_ninetieth_cd','T_mu_ia_ff', 'T_sigma_ia_ff', 'T_median_ia_ff', 'T_ninetieth_ia_ff', 'T_mu_cd_ff', 'T_sigma_cd_ff', 'T_median_cd_ff', 'T_ninetieth_cd_ff', 'T_mu_ia_cd', 'T_sigma_ia_cd', 'T_median_ia_cd', 'T_ninetieth_ia_cd'
};

% Add column from simulations to the table
for i = 1:length(sim)
    id = id + 1;
    table(:,id)=eval(sim{i})';
    sim{i} = [sim{i} '_sim'];
end

% Append the features label to our labels
labels = [labels sim];

disp(table);