close all
clear

SIFT_files = dir( fullfile( 'cover_SIFT', '*.mat') );
train_files = dir( fullfile( 'cover', '*.jpg') );
test_files = dir( fullfile( 'test', '*.jpg') );
%num_images = length(SIFT_files);
num_test = length(test_files);
correct = 0;
%% Extract features and apply k-means on training data
%test_feats = calculate_gist('test', test_files);
%train_feats = calculate_gist('cover', train_files);
% load train_gist.mat

%{
S=[];
for m = 1 : length(train_files)
    img = rgb2gray(imread(fullfile( 'cover', train_files(m).name)));
    [~, descriptor] = vl_dsift(single(img), 'step', 5, 'fast');
    S = [S, descriptor];
end
vocab_size = 4000;
[centers, ~] = vl_kmeans(single(S), vocab_size);
SIFT_vocab = centers';
save('SIFT_vocab.mat', 'SIFT_vocab')
%}
test_feats = calculate_BoSIFT('test', test_files);
train_feats = calculate_BoSIFT('cover', train_files);
% load train_BoSIFT.mat

vocab_size = 3;
[centers, A] = vl_kmeans(single(train_feats'), vocab_size);
vocab = centers';
class_of_covers = A';
%%
for i = 1 : num_test
    
    G = repmat(test_feats(i, :), [size(vocab, 1), 1]);
    D = sum((G - vocab).^2, 2);
    [~, class] = min(D);
    Take2Match = SIFT_files(class_of_covers == class);
    
    test_img = rgb2gray(imread(fullfile( 'test', test_files(i).name)));
    test_img = imresize(test_img, 0.1);
    [~, d] = vl_sift(single(test_img));
    des1 = double(d');

    score = zeros(length(Take2Match), 1);
    
    for m = 1 : length(Take2Match)
        des2 = fullfile( 'cover_SIFT', Take2Match(m).name);
        load(des2)
        M = SIFTSimpleMatcher(des1, descriptor, 0.5);
        score(m) = size(M, 1);
    end

    [~, x] = max(score);
    a = Take2Match(x).name;
    a = a(1:length(a)-4);
    fprintf(['This book is ', a, '\n'])
    b = test_files(i).name;
    b = b(1:length(b)-4);
    fprintf(['Actually its ', b, '\n'])
    if strcmp(a,b)
        correct = correct +1;
    end
end
accuracy = correct/num_test