image_files = dir( fullfile( 'cover', '*.jpg') );
num_images = length(image_files);
full_ratio = zeros(num_images, 3);

for i = 1 : num_images
    img = imread(fullfile( 'cover', image_files(i).name));
    full_ratio(i, 1) = size(img, 1) / size(img, 2);
    full_ratio(i, 2:3) = [size(img, 1), size(img, 2)];
end

ratio = unique(full_ratio(:, 1));
num = zeros(length(ratio), 1);
for i = 1 : length(ratio)
    num(i) = sum(full_ratio(:, 1) == ratio(i));
end

[~, x] = max(num);
row = full_ratio(:, 2);
col = full_ratio(:, 3);
a = [row(full_ratio(:, 1) == ratio(x)), col(full_ratio(:, 1) == ratio(x))];