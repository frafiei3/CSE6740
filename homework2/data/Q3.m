clear
clc
close all

%% load the data
test_data = []; train_data = []; test_label = []; train_label = [];
scaleFactor = 0.25 ;
filename = dir('./yalefaces/*.gif') ;
for i = 1:length(filename)
    if strfind(filename(i).name, 'test')
        data = importdata(['./yalefaces/', filename(i).name]) ;
        img = imresize(data.cdata, scaleFactor) ;
        test_data(end+1,:) = reshape(img, 1, []);
        
        if strfind(filename(i).name, '01')
            test_label(end+1) = 1 ;
        else
            test_label(end+1) = 2 ;
        end
        
    else
        data = importdata(['./yalefaces/', filename(i).name]) ;
        img = imresize(data.cdata, scaleFactor) ;
        train_data(end+1,:) = reshape(img, 1, []);
        
        if strfind(filename(i).name, '01')
            train_label(end+1) = 1 ;
        else
            train_label(end+1) = 2 ;
        end
        
    end
end

%% perform pca
k = 6 ; 
sub1_data = train_data(train_label==1, :) ;
sub2_data = train_data(train_label==2, :) ;

[sub1_W, sub1_PCA] = myPCA(sub1_data, k) ;
[sub2_W, sub2_PCA] = myPCA(sub2_data, k) ;

%% visualization of weights
figure(1); clf
for i = 1:k
    subplot_tight(6, 2, 2*i-1, [0.01, 0.01])
    weight_img = (sub1_W(:,i)-min(sub1_W(:,i))) ;
    weight_img = weight_img / max(weight_img) ;
    imshow(reshape(weight_img, size(img)))
    imshow(imresize(reshape(weight_img, size(img)), 1/scaleFactor))
    
    
    subplot_tight(6, 2, 2*i, [0.01, 0.01])
    weight_img = (sub2_W(:,i)-min(sub2_W(:,i))) ;
    weight_img = weight_img / max(weight_img) ;
    imshow(imresize(reshape(weight_img, size(img)), 1/scaleFactor))
end

%% compute normalized inner product score
s11 = (sub1_W(:,1)' * test_data(1,:)') / (norm(sub1_W(:,1)) * norm(test_data(1,:)));
s12 = (sub1_W(:,1)' * test_data(2,:)') / (norm(sub1_W(:,1)) * norm(test_data(2,:)));
s21 = (sub2_W(:,1)' * test_data(1,:)') / (norm(sub2_W(:,1)) * norm(test_data(1,:)));
s22 = (sub2_W(:,1)' * test_data(2,:)') / (norm(sub2_W(:,1)) * norm(test_data(2,:)));

