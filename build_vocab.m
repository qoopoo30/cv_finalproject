function vocab = build_vocab(dir, image_files, vocab_size)

S=[];
for m = 1 : length(image_files)
    img = imread(fullfile( dir, image_files(m).name));
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    [~, descriptor] = vl_dsift(im2single(img), 'step', 4, 'size', 6);
    S = [S, descriptor];
end

[centers, ~] = vl_kmeans(single(S), vocab_size);
vocab = centers';
save('vocab.mat', 'vocab')