function image_feats = calculate_gist(dir, image_files)

clear param
param.imageSize = [346 230]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 5;
param.fc_prefilt = 4;

num_images = length(image_files);
num_feats = sum(param.orientationsPerScale)*param.numberBlocks^2;
gist = zeros(num_images, num_feats);

img = rgb2gray(imread(fullfile( dir, image_files(1).name)));
[gist(1, :), param] = LMgist(img, '', param); % first call

for a = 2 : num_images
    img = rgb2gray(imread(fullfile( dir, image_files(a).name)));
    gist(a, :) = LMgist(img, '', param); % the next calls will be faster
end

image_feats = zscore(gist')'; % becus 'zscore' compute along each column
