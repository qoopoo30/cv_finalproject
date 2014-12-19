function vocab = build_vocab(dir, image_files, vocab_size)

S=[];
for m = 1 : length(image_files)
    img = rgb2gray(imread(fullfile( dir, image_files(m).name)));
    [~, descriptor] = vl_dsift(im2single(img), 'step', 4, 'size', 6);
    S = [S, descriptor];
end

[centers, ~] = vl_kmeans(single(S), vocab_size);
vocab = centers';
save('vocab.mat', 'vocab')