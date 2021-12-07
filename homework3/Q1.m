clear
clc
close all

%% load the data
n90pol = readtable("./data/n90pol.csv");

amygdala = n90pol.amygdala ;
acc = n90pol.acc ;
orientation = n90pol.orientation ;

num_bins = 20 ; % set number of bins for histogram
bw = 0.0075 ; % set bandwidth for KDE
edges = linspace(min(min(amygdala, acc)), max(max(amygdala, acc)), num_bins) ;

%% form 1-dim histogram
% amygdala
count_hist_amygdala = histcounts(amygdala, edges) ;
figure(1)
subplot(1,2,1)
histogram(amygdala, edges)
ylabel('amygdala')
title(['bins = ', num2str(num_bins)])

% acc
count_hist_acc = histcounts(acc, edges) ;
figure(1)
subplot(1,2,2)
histogram(acc, edges)
ylabel('acc')
title(['bins = ', num2str(num_bins)])

%% form 2-dim histogram
figure(3)
hist3([amygdala acc], 'Nbins', [num_bins, num_bins],'CDataMode','auto','FaceColor','interp')
xlabel('amygdala')
ylabel('acc')
title(['bins = ', num2str(num_bins)])
%% form 1-dim KDE
% amygdala
[KDE_amygdala, xi_amygdala] = ksdensity(amygdala, 'Bandwidth', bw);
figure(4)
subplot(1,2,1)
plot(xi_amygdala, KDE_amygdala, 'LineWidth', 2);
ylabel('amygdala')
title(['Bandwidth = ', num2str(bw)])

% acc
[KDE_acc, xi_acc] = ksdensity(acc, 'Bandwidth', bw);
figure(4)
subplot(1,2,2)
plot(xi_acc, KDE_acc, 'LineWidth', 2);
ylabel('acc')
title(['Bandwidth = ', num2str(bw)])

%% are amygdala and acc independent of each other?
% create p(amygdala, acc)
[x1, x2] = meshgrid(xi_amygdala, xi_acc) ;
x1 = x1(:) ;
x2 = x2(:) ;
figure(6)
subplot(1,2,1)
ksdensity([amygdala, acc], [x1 x2])
xlabel('amygdala')
ylabel('acc')
[KDE_joint, ~] = ksdensity([amygdala, acc], [x1 x2]) ; % 2-dim KDE
KDE_joint = reshape(KDE_joint, length(xi_amygdala), length(xi_acc))' ;

subplot(1,2,2)
contour(xi_amygdala, xi_acc, KDE_joint)
xlim([-0.1, 0.1])
ylim([-0.1, 0.1])
xlabel('amygdala')
ylabel('acc')

% create p(amygdala) * p(acc)
KDE_mult = KDE_amygdala' * KDE_acc ;
figure(7)
surf(xi_amygdala, xi_acc, KDE_mult);
xlabel('amygdala')
ylabel('acc')

figure(8)
surf(xi_amygdala, xi_acc, abs(KDE_joint-KDE_mult));
xlabel('amygdala')
ylabel('acc')

%% compute conditional KDE
bw = 8e-3 ;

for c = min(orientation):max(orientation)
    
    amygdala_c = amygdala(orientation==c) ;
    acc_c = acc(orientation==c) ;
    
    % amygdala
    [KDE_amygdala_c, xi_amygdala] = ksdensity(amygdala_c, 'Bandwidth', bw);
    figure(9)
    subplot(2,2,c-1)
    plot(xi_amygdala, KDE_amygdala_c, 'LineWidth', 2);
    title("Orientation = " + c)
    
    % acc
    [KDE_acc_c, xi_acc] = ksdensity(acc_c, 'Bandwidth', bw);
    figure(10)
    subplot(2,2,c-1)
    plot(xi_acc, KDE_acc_c, 'LineWidth', 2);
    title("Orientation = " + c)
    
    [x1, x2] = meshgrid(xi_amygdala, xi_acc) ;
    x1 = x1(:) ;
    x2 = x2(:) ;
    figure(11)
    subplot(2,2,c-1)
    ksdensity([amygdala_c, acc_c], [x1 x2])
    xlabel('amygdala')
    ylabel('acc')
    xlim([-0.1, 0.1])
    ylim([-0.1, 0.1])
    title("Orientation = " + c)
    [KDE_joint, ~] = ksdensity([amygdala_c, acc_c], [x1 x2]) ; % 2-dim KDE
    KDE_joint = reshape(KDE_joint, length(xi_amygdala), length(xi_acc))' ;
    
    % create p(amygdala) * p(acc)
    KDE_mult = KDE_amygdala_c' * KDE_acc_c ;
    figure(12)
    subplot(2,2,c-1)
    surf(xi_amygdala, xi_acc, KDE_mult) ;
    xlabel('amygdala')
    ylabel('acc')
    xlim([-0.1, 0.1])
    ylim([-0.1, 0.1])
    title("Orientation = " + c)
    
    figure(13)
    subplot(2,2,c-1)
    surf(xi_amygdala, xi_acc, abs(KDE_joint-KDE_mult)) ;
    xlabel('amygdala')
    ylabel('acc')
    xlim([-0.1, 0.1])
    ylim([-0.1, 0.1])
    title("Orientation = " + c)
    
end
