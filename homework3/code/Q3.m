clear
clc
close all

%% load the data
load('./data/data.mat')
load('./data/label.mat')
data = data' ;
pdata = data ;
num_dataPoints = size(data, 1) ;

%% Dimensionality reduction
% perform pca to project data into 5-dimensional space
num_components = 784 ;
% [eig_vectors, eig_values, pdata] = myPCA(data, num_components) ;

%% Expectation maximization (EM)

% initialization
% rng(2020)
K = 2 ; % fit a matrix of 2 gaussians 
pi = rand(K, 1) ; 
pi = pi ./ sum(pi) ; 
mu = randn(num_components, K) + 5; % mean or center of gaussian

sigma = zeros(num_components, num_components, K); 
for i = 1:K
    tmp = randn(num_components, num_components); 
    sigma(:,:,i) = tmp * tmp' + eye(num_components); 
end

tau = zeros(num_dataPoints, K) ; % poster probability of component indicator variable


% initialize the figure requirements
min_data = min(pdata, [], 1) ; 
max_data = max(pdata, [], 1) ;
gridno = 40 ; 
inc1 = (max_data(1) - min_data(1)) / gridno ; 
inc2 = (max_data(2) - min_data(2)) / gridno ; 
[gridx,gridy] = meshgrid(min_data(1):inc1:max_data(1), min_data(2):inc2:max_data(2)) ; 
gridall = [gridx(:), gridy(:)];     
gridallno = size(gridall, 1); 

figure

iterations = 100 ; iter = 0; flg = 0 ;
r = 20 ;
while (iter < iterations) & (flg < 0.5)
    
    fprintf(1, '--iteration %d of %d\n', iter, iterations); 
    iter = iter + 1 ;
    
    % Expectation step
    for i = 1:K
        [U, S, V] = svd(sigma(:,:,i)) ;
        sigma(:,:,i) = U(:,1:r) * S(1:r,1:r) * V(:,1:r)' + 0.001 * eye(784);
        tau(:,i) = pi(i) * mvnpdf(pdata, mu(:,i)', sigma(:,:,i)) ; 
    end
    
    l(iter) = sum(log(sum(tau,2))) ;
    flg = check_likelihood(l) ;
    
    tau = tau ./ repmat(sum(tau, 2), 1, K) ; % normalize
    
    % Maximization step
    for i = 1:K
        % update mixing proportion
        pi(i) = sum(tau(:,i), 1) ./ num_dataPoints ; 
        % update gaussian center
        mu(:, i) = pdata' * tau(:,i) ./ sum(tau(:,i), 1) ; 
        % update gaussian covariance
        tmpdata = pdata - repmat(mu(:,i)', num_dataPoints, 1) ; 
        sigma(:,:,i) = tmpdata' * diag(tau(:,i)) * tmpdata ./ sum(tau(:,i), 1); 
    end
    
    % plot data points using the mixing proportion tau as colors; 
    % the data point locations will not change over iterations, but the
    % color may change; 
    scatter(pdata(:,1), pdata(:,2), 16*ones(num_dataPoints, 1), [tau, 0.1*ones(1990,1)], 'filled') ; 
    
    hold on; 
    % also plot the centers of the guassian; 
    % the centers change locations each iteraction until the solution converges;  
    scatter(mu(1,:)', mu(2,:)', 26*ones(K, 1), 'filled'); 
    drawnow; 
    
%     % also draw the contour of the fitted mixture of gaussian density; 
%     % first evaluate the density on the grid points; 
%     tmppdf = zeros(size(gridall,1), 1);
%     for i = 1:K        
%         tmppdf = tmppdf + pi(i) * mvnpdf(gridall, mu(1:2,i)', sigma(1:2,1:2,i));
%     end
%     tmppdf = reshape(tmppdf, gridno+1, gridno+1) ; 
%     
%     % draw contour; 
%     [c, h] = contour(gridx, gridy, tmppdf);
    
    hold off; 
    
    pause(0.1);
    
    
end
%%
figure
subplot(1,2,1)
imshow(reshape(data(1,:), [28, 28]))
subplot(1,2,2)
imshow(reshape(data(1990,:), [28, 28]))

%%
figure
plot(l, 'o')

%%
for i = 1:K
    mu_orig(i,:) = mean(data,1)' + eig_vectors * eig_values^0.5 * mu(:,i) ;
    sigma_orig(:,:,i) = eig_vectors * sigma(:,:,i) * eig_vectors' ;
end

figure
subplot(1,2,1)
imshow(reshape(mu_orig(1,:), [28, 28]))
subplot(1,2,2)
imshow(reshape(mu_orig(2,:), [28, 28]))

%%
figure
subplot(1,2,1)
imshow(sigma_orig(:,:,1)./max(sigma_orig(:,:,1)))
subplot(1,2,2)
imshow(sigma_orig(:,:,2)./max(sigma_orig(:,:,2)))

%%
predicted_label = (tau(:,1) > tau(:,2)) ;
true_label_logical = (trueLabel < 3) ;
C = confusionmat(~true_label_logical, ~predicted_label);
figure; confusionchart(C);

