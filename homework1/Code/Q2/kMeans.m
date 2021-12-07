function [class, centroid] = kMeans(pixels, k)

% Choose K random centroids for initialization
% rng(2020)
centroid = pixels(randperm(size(pixels,1), k),:) ;

max_iter = 1000 ; iter = 0 ; curr_loss = 1e8 ; loss = curr_loss+1 ;
while (iter < max_iter) && (curr_loss - loss < 0)
    
    loss = curr_loss ;
    distance = pdist2(pixels, centroid) ;
    [dist, class] = min(distance,[],2) ;
    curr_loss = sum(dist) ;
    
    % update the centroids
    for i = 1:k
        class_pixels = pixels(class==i, :) ;
        class_pixels = unique(class_pixels, 'rows') ;
        centroid(i,:) = mean(class_pixels) ;
    end
    
    iter = iter + 1 ;
end
centroid = centroid .* 255 ;
end

