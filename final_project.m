%%
clear, close all

SIFT_files = dir( fullfile( 'cover_SIFT', '*.mat') );
train_files = dir( fullfile( 'cover', '*.jpg') );
test_files = dir( fullfile( 'test', '*.jpg') );
%num_images = length(train_files);
num_test = length(test_files);
correct = 0;

%%
if ~exist('vocab.mat', 'file')
    fprintf('No existing visual word vocabulary found. Computing one from training images\n')
    vocab_size = 400; %Larger values will work better (to a point) but be slower to compute
    vocab = build_vocab('cover', train_files, vocab_size);
    save('vocab.mat', 'vocab')
end
%load train_gist.mat
%train_feats = calculate_gist('cover', train_files);
%test_feats = calculate_gist('test', test_files);

if ~exist('train_feats', 'var'), load train_feats.mat; end
%train_feats = calculate_BoSIFT('cover', train_files);
test_feats = calculate_BoSIFT('test', test_files);


D = vl_alldist2(test_feats', train_feats');
Q = sort(D, 2);

%%
for m = 1 : num_test
    test_img = rgb2gray(imread(fullfile( 'test', test_files(m).name)));
    test_img = imresize(test_img, 0.1);
    [~, d] = vl_sift(single(test_img));
    des1 = double(d');

    threshold = 40;
    near_train = Q(m, 1 : threshold);
    score = zeros(threshold, 1);
    S = Take2Match(D, near_train, threshold, m, train_files);
    
    for k = 1 : length(S)
        des2 = fullfile( 'cover_SIFT', S(k));
        load(des2{1})
        M = SIFTSimpleMatcher(des1, descriptor);
        score(k) = size(M, 1);
    end
    [~, x] = max(score);
    predict = S{x}(1 : end-4);
    %predict = predict(1:end-4);
    fprintf(['This book is ', predict, '\n'])
    
    true = test_files(m).name(1:end-7);
    %true = true(1:length(true)-4);
    fprintf(['Actually its ', true, '\n'])
    
    if strcmp(predict, true)
        correct = correct +1;
    end
end
Accuracy = correct/num_test