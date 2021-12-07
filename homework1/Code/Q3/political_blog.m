clear
clc
close all

% load the data
political_blog_nodes = import_dataset('nodes.txt') ;
nodes = political_blog_nodes.node ; % import nodes
labels = political_blog_nodes.label ; % import labels
edges = table2array(readtable('edges.txt')) ; % import edges

%% part (2)
k = 2 ; % set number of clusters
[majority_index, mismatch_rate] = spectral_clustering(nodes, labels, edges, k);

% %% part (3)
% for k = 1:200
%     k
%     [~, mismatch_rate(k)] = spectral_clustering(nodes, labels, edges, k);
% end
% 
% figure(1)
% plot(1:200, mismatch_rate)

    




