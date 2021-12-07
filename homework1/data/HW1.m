clear
clc
close all

% load the image
image = imread('plants.bmp') ;
image = im2double(image) ;
pixels = reshape(image, [],3) ;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % part 2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,3,1)
imshow(image)
title('Original')
fig_num = 2;
for k = [2,4,8,16,32]
    tic
    [class_kmedoids, centroid_kmedoids] = kMedoids(pixels, k) ;
    toc
    class_kmedoids = reshape(class_kmedoids, size(image,1), size(image,2));
    converted_image_kmedoids = class2image(image, class_kmedoids, centroid_kmedoids);
    subplot(2,3,fig_num)
    imshow(converted_image_kmedoids./255)
    title(['K = ', num2str(k)])
    fig_num = fig_num + 1;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % part 3
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rng(10)
k = 8 ;
[class_kmedoids, centroid_kmedoids] = kMedoids(pixels, k) ;
class_kmedoids = reshape(class_kmedoids, size(image,1), size(image,2));
converted_image_kmedoids = class2image(image, class_kmedoids, centroid_kmedoids);
figure
imshow(converted_image_kmedoids./255)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,3,1)
imshow(image)
title('Original')
fig_num = 2;
for k = [2,4,8,16,32]
    tic
    [class_kMeans, centroid_kMeans] = kMeans(pixels, k) ;
    toc
    class_kMeans = reshape(class_kMeans, size(image,1), size(image,2));
    converted_image_kMeans = class2image(image, class_kMeans, centroid_kMeans);
    subplot(2,3,fig_num)
    imshow(converted_image_kMeans./255)
    title(['K = ', num2str(k)])
    fig_num = fig_num + 1;
end

k = 8 ;
[class_kmeans, centroid_kmeans] = kMedoids(pixels, k) ;
class_kmeans = reshape(class_kmeans, size(image,1), size(image,2));
converted_image_kmeans = class2image(image, class_kmeans, centroid_kmeans);
figure
imshow(converted_image_kmeans./255)


function converted_image = class2image(image, class, centroid)
k = max(class);
r = image(:,:,1);
g = image(:,:,2);
b = image(:,:,3);

for i = 1:k
    r(class==i) = centroid(i,1) ;
    g(class==i) = centroid(i,2) ;
    b(class==i) = centroid(i,3) ;
end
converted_image(:,:,1) = r;
converted_image(:,:,2) = g;
converted_image(:,:,3) = b;
end

