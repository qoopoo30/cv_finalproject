clear, close all

train_files = dir( fullfile( 'cover', '*.jpg') );
num_images = length(train_files);

for k = 1 : 2%num_images
    im = rgb2gray(imread(fullfile( 'cover', train_files(k).name)));
    im2 = zeros(size(im)) + 255;

    [height, width, ~] = size(im);
    p1 = [1 1; 1 width-1; height-1 1; height-1 width-1];
    p2 = [20 1; 1 width-1; height-20 1; height-1 width-1];

    %A
    H2 = trans_mat(p2, p1);

    %question 2
    %[height, width, ~] = size(im);
    [meshX,meshY] = meshgrid(0:1);
    for i1 = 1:height
        for i2 = 1:width
            if(inrect([i1 i2],p2)) % [i1 i2] in im2
                pn = H2*[i1 i2 1]';
                xf = pn(1)/pn(3); % x in float
                yf = pn(2)/pn(3);
                x0 = floor(xf);
                if x0==0, x0=1;end
                y0 = floor(yf);
                if y0==0, y0=1;end

                V = [im(x0,y0) im(x0,y0+1);
                im(x0+1,y0) im(x0+1,y0+1)];
                im2(i1,i2) = interp2(meshX,meshY,V,xf-x0,yf-y0,'linear');
            end
        end
    end

    %figure,imshow(uint8(im2))
    imwrite(uint8(im2), fullfile('create_cover', train_files(k).name))
end