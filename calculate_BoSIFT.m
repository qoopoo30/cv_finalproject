function image_feats = calculate_BoSIFT(dir, image_files)

load vocab.mat
vocab_size = size(vocab, 1);
num_images = length(image_files);
image_feats = zeros(num_images, vocab_size);

for a = 1 : num_images
    
    if strcmp(dir, 'test')
        image = rgb2gray(imread(fullfile( dir, image_files(a).name)));
        image = imresize(image, 0.1);
        row_gap = floor(size(image, 1)*0.1/2);
        col_gap = floor(size(image, 2)*0.1/2);
        image = image(row_gap : size(image, 1) - row_gap,...
            col_gap : size(image, 2) - col_gap);
    else
        image = imread(fullfile( dir, image_files(a).name));
        if size(image, 3) == 3
            image = rgb2gray(image);
        end
    end
    
    [~, d] = vl_dsift(im2single(image), 'step', 4, 'size', 6);
    %descriptor = double(d');
    D = vl_alldist2(vocab', single(d));
    [~, cate] = min(D);
    H = hist(cate, vocab_size);
    image_feats(a,:) = zscore(H);
end