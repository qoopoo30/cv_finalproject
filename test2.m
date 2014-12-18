clear, close all

SIFT_files = dir( fullfile( 'cover_SIFT', '*.mat') );
train_files = dir( fullfile( 'cover', '*.jpg') );
test_files = dir( fullfile( 'test', '*.jpg') );
num_images = length(train_files);
num_test = length(test_files);
correct = 0;

load train_gist.mat
test_feats = calculate_gist('test', test_files);

D = vl_alldist2(test_feats', train_feats');
Q = sort(D, 2);
confidence = Q(:,2) - Q(:,1);

[~, b] = min(D, [], 2);

for m = 1 : num_test
    if confidence(m) > 100
        predict = train_files(b(m)).name;
        predict = predict(1:length(predict)-4);
        fprintf(['This book is ', predict, '\n'])
    else
        test_img = rgb2gray(imread(fullfile( 'test', test_files(m).name)));
        test_img = imresize(test_img, 0.1);
        [~, d] = vl_sift(single(test_img));
        des1 = double(d');
        
        temp = Q(m, 1:80);
        score = zeros(80, 1);
        Take2Match = struct([]);
        for k = 1:80
            Take2Match(k).name = SIFT_files(D(m,:)==temp(k)).name;
            des2 = fullfile( 'cover_SIFT', Take2Match(k).name);
            load(des2)
            M = SIFTSimpleMatcher(des1, descriptor, 0.5);
            score(k) = size(M, 1);
        end
        [~, x] = max(score);
        predict = Take2Match(x).name;
        predict = predict(1:length(predict)-4);
        fprintf(['This book is ', predict, '\n'])
    end
    
    true = test_files(m).name;
    true = true(1:length(true)-4);
    fprintf(['Actually its ', true, '\n'])
    
    if strcmp(predict, true)
        correct = correct +1;
    end
end
accuracy = correct/num_test