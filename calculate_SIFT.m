image_files = dir( fullfile( 'new_cover', '*.jpg') );
num_images = length(image_files);
save_dir = 'cover_SIFT/';

for m = 1 : num_images
    image = rgb2gray(imread(fullfile( 'new_cover', image_files(m).name)));
    [~, d] = vl_sift(single(image));
    descriptor = double(d');
    a = image_files(m).name;
    X = [save_dir, a(1:length(a)-4), '.mat'];
    save(X, 'descriptor')
end