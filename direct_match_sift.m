%% Match all images in database
clear, close all

image_files = dir( fullfile( 'cover_SIFT', '*.mat') ); % pre-generated
test_files = dir( fullfile( 'test', '*.jpg') );
num_images = length(image_files);
num_test = length(test_files);
correct = 0;
score = zeros(num_images, 1);

%%
for i = 1 : num_test
    % Calculate test image's sift features
    test_img = rgb2gray(imread(fullfile( 'test', test_files(i).name)));
    test_img = imresize(test_img, 0.1);
    [~, d] = vl_sift(im2single(test_img));
    des1 = double(d');

    % Match
    for m = 1 : num_images
        des2 = fullfile( 'cover_SIFT', image_files(m).name);
        load(des2)
        M = SIFTSimpleMatcher(des1, descriptor, 0.7);
        score(m) = size(M, 1);
    end

    [~, x] = max(score);
    predict = image_files(x).name(1:end-4);
    %predict = predict(1:length(predict)-4);
    fprintf(['This book is ', predict, '\n'])
    
    true = test_files(i).name(1:end-7);
    %true = true(1:length(true)-4);
    fprintf(['Actually its ', true, '\n'])
    if strcmp(predict,true)
        correct = correct +1;
    end
end
Accuracy = correct / num_test