function [eig_vectors, PC] = myPCA(data, k)

% data is n x p matrix
% n : number of instances
% p: number of features
% k is the number of top components

[num_dataPoints, num_features] = size(data) ;
normalization = 0 ;

if normalization == 1
    data_std = std(data) ; % compute std for each feature
    data = bsxfun(@rdivide, data, data_std); % normalize the data
end

mu = mean(data) ; % compute mean for each feature
xc = bsxfun(@minus, data, mu) ; % subtract mean from features
C = xc' * xc./ num_dataPoints; % covariance

[eig_vectors, eig_values] = eigs(C,k);

% compute pricipke components
for i = 1:k
    PC(:,i) = eig_vectors(:,i)' * xc' ./ sqrt(eig_values(i,i)) ;
end

end % function

