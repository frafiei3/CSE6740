function [majority_label, mismatch_rate] = spectral_clustering(n, l, e, k)

% n : nodes
% l : labels
% e : edges
% k : # of clusters

nodes = n ;
labels = l ; 
edges = e ;

% construct the adjacency matrix
num_blogs = length(nodes) ;
adj_matrix = zeros(num_blogs, num_blogs) ;
for i =1:size(edges,1)
    adj_matrix(edges(i,1), edges(i,2)) = 1 ;
    adj_matrix(edges(i,2), edges(i,1)) = 1 ;
end

% remove isolated nodes
adj_matrix = adj_matrix(any(adj_matrix,2),:);
adj_matrix = adj_matrix(:,any(adj_matrix,1));

% create degree matrix
D = diag(sum(adj_matrix,2)) ;

% create laplacian matrix
L = D - adj_matrix ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% other versions of Laplacian matrix
% L = eye(size(adj_matrix,1)) - (D^-0.5) * adj_matrix * (D^-0.5) ;
% L = eye(size(adj_matrix,1)) - (D^-1) * adj_matrix ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find eigenvalues and correspondig eigenvectors
[eig_vector, eig_value] = eig(L) ;

% perform k-means clustering
predicted_labels = kmeans(eig_vector(:,1:k), k, 'Replicates', 20) ;

% find the connected nodes
nonIsolated_nodes = unique([edges(:,1);edges(:,2)]) ;
nonIsolated_labels = labels(nonIsolated_nodes) ;

% find the majority labels (ML) in each cluster
for kk = 1:k
    idx = (predicted_labels==kk) ;
    [label_count, label_flg] = groupcounts(nonIsolated_labels(idx));
    [~, idx] = max(label_count) ;
    majority_label(kk) = label_flg(idx) ;
end

% compute mismatch rate
for kk = 1:k
    cluster_labels = nonIsolated_labels(predicted_labels==kk) ;
    mismatch_rate(kk) = mean(cluster_labels~=majority_label(kk)) ;
end
mismatch_rate = max(mismatch_rate) ;

end % function