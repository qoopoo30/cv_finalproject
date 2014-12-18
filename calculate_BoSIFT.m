function image_feats = calculate_BoSIFT(dir, image_files)

load SIFT_vocab.mat
vocab_size = size(SIFT_vocab, 1);
num_images = length(image_files);
image_feats = zeros(num_images, vocab_size);

%{
if strcmp(dir, 'cover_SIFT')
    for m = 1 : num_images
        load(fullfile( dir, image_files(m).name));
        D = vl_alldist2(SIFT_vocab', single(descriptor'));
        [~, cate] = min(D);
        H = hist(cate, vocab_size);
        image_feats(m,:) = zscore(H);
    end
else
    for a = 1 : num_images
        image = rgb2gray(imread(fullfile( dir, image_files(a).name)));
        image = imresize(image, 0.1);
        [~, d] = vl_sift(single(image));
        descriptor = double(d');
        D = vl_alldist2(SIFT_vocab', single(descriptor'));
        [~, cate] = min(D);
        H = hist(cate, vocab_size);
        image_feats(a,:) = zscore(H);
    end
end
%}
for a = 1 : num_images
    image = rgb2gray(imread(fullfile( dir, image_files(a).name)));
    if strcmp(dir, 'test')
        image = imresize(image, 0.1);
    end
    [~, d] = vl_sift(single(image));
    descriptor = double(d');
    D = vl_alldist2(SIFT_vocab', single(descriptor'));
    [~, cate] = min(D);
    H = hist(cate, vocab_size);
    image_feats(a,:) = zscore(H);
end