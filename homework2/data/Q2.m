clear
clc
close all

% load  the data
load isomap
[dim_imgs, num_imgs] = size(images) ;

% insert some options
isomap_type = 'epsilon' ; % 'epsilon' OR 'KNN'
epsilon = 600 ; % in case of epsilon 
k = 100 ; % in case of KNN

images = images' ;
distance = pdist2(images, images, 'cityblock') ; % distance matrix 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = distance ;
inf =  1000 * max(max(A)) * num_imgs;

%% Step 1
% build a weighted graph A
if strcmp(isomap_type, 'epsilon')
    
    A = A ./ (A<=epsilon) ;
    A = min(A, inf) ;
    
elseif strcmp(isomap_type, 'KNN')
    
    [~, idx] = sort(A) ;
    for i = 1:num_imgs
        A(i, idx(2+k:end,i)) = inf ;
    end
    
end

A = min(A, A') ; % A should be symmetrical

% visualize the similarity graph
figure
imshow(1-A/max(max(A)))

% Let's find the edges
E = int8(1 - (A==inf)) ;

%% Step 2
% Compute the shortest path
D = Matrix_D(A) ;

%% Step 3
% Compute centering matrix
C = -.5*(D.^2 - ...
    sum(D.^2)'*ones(1,num_imgs)/num_imgs - ...
    ones(num_imgs,1)*sum(D.^2)/num_imgs + ...
    sum(sum(D.^2))/(num_imgs^2)) ;

%% Step 4
% Compute leading eigenvalues and eignevectors
[eig_vectors, eig_values] = eig(C) ;

%% visualize the results
img_loc = eig_vectors(:,[1,2]);
IMAGES = reshape(images', [64, 64, num_imgs]);
mask = zeros(num_imgs,1) ;
mask(10:10:698) = 1 ;
imgScatter(img_loc, IMAGES, mask, 0.01, 0.01) ;

%% perform PCA on images
data = images ;
[num_dataPoints, num_features] = size(data) ;
normalization = 0 ;
k = 2 ; % number of top components

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

img_loc_pca = PC(:,[1,2]) ;
imgScatter(img_loc_pca, IMAGES, mask, 0.3, 0.3) ;



