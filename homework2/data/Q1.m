clear
clc
close all
warning off

% load the data
T = readtable('food-consumption.csv','ReadRowNames',true) ;
data = table2array(T) ;
countries = T.Properties.RowNames ; % Country names       
foods = T.Properties.VariableNames ; % foods

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

figure; subplot(2,1,1); stem(eig_vectors(:,1), 'r'); title('Largest Eigenvector')
subplot(2,1,2); stem(eig_vectors(:,2)); title('Second Largest Eigenvector')

% compute pricipke components
for i = 1:k
    PC(:,i) = eig_vectors(:,i)' * xc' ./ sqrt(eig_values(i,i)) ;
end

% plot data points
figure
plot(PC(:,1),PC(:,2),'o'); 
hold on
text(PC(:,1), PC(:,2), countries, 'FontSize',9, 'VerticalAlignment','bottom', 'FontWeight', 'bold');

% plot reduced feature space
magnifier = 5 ;
z = zeros(num_features,1) ;
plot([z'; magnifier*eig_vectors(:,1)'], [z'; magnifier*eig_vectors(:,2)'], 'r') ; 
text(magnifier*eig_vectors(:,1), magnifier*eig_vectors(:,2), foods, 'FontSize',8,...
    'VerticalAlignment','bottom', ...
    'HorizontalAlignment','right', ...
    'color','red') ;
grid on
axis equal
ax = axis ; 
plot(ax(1:2),[0 0],'g',[0 0],ax(3:4),'g')
xlabel('Principal Component 1')
ylabel('Principal Component 2')
hold off