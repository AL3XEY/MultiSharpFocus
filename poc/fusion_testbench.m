clear all;
close all;
clc;

pkg load image;

%imgs(:,:,1) = imread('img/sd/set1/img0.pgm');
%imgs(:,:,2) = imread('img/sd/set1/img1.pgm');
%imgs(:,:,3) = imread('img/sd/set1/img2.pgm');
%imgs(:,:,4) = imread('img/sd/set1/img3.pgm');
%imgsc(:,:,:,1) = imread('img/sd/set1/img0.ppm');
%imgsc(:,:,:,2) = imread('img/sd/set1/img1.ppm');
%imgsc(:,:,:,3) = imread('img/sd/set1/img2.ppm');
%imgsc(:,:,:,4) = imread('img/sd/set1/img3.ppm');
%vrs(:,:,1) = sharp_detect('img/sd/set1/img0.ppm', full);
%vrs(:,:,2) = sharp_detect('img/sd/set1/img1.ppm', full);
%vrs(:,:,3) = sharp_detect('img/sd/set1/img2.ppm', full);
%vrs(:,:,4) = sharp_detect('img/sd/set1/img3.ppm', full);

full = 0;

imgsc(:,:,:,1) = imread('img/sd/set2/img0.ppm');
imgsc(:,:,:,2) = imread('img/sd/set2/img1.ppm');
imgsc(:,:,:,3) = imread('img/sd/set2/img2.ppm');
imgsc(:,:,:,4) = imread('img/sd/set2/img3.ppm');

[h,w,c,s] = size(imgsc);

for i=1:s
    vrs(:,:,i) = sharp_detect(imgsc(:,:,:,i), full);
end

for i=1:s-1
    v(:,:,:,i) = optical_flow(imgsc(:,:,:,i), imgsc(:,:,:,i+1));
end

xs = zeros(1,s);
ys = zeros(1,s);

for x=1:h
    for y=1:w
        xs(1) = x;
        ys(1) = y;
        for count=1:s-1
            x2 = xs(count)+round(v(x,y,1,count)) %TODO caution!!! We calculate optical flow between 1 and 2, 2 and 3, 3 and 4, etc.... So coordinates aren't x+dx but xs(i)+dx
            y2 = ys(count)+round(v(x,y,2,count))
            %x2 = x+round(v(x,y,1,1));
            %y2 = y+round(v(x,y,2,1));
            if x2 < 1 || x2 >= h || y2 < 1 || y2 >= w %TODO find something better
                x2 = x;
                y2 = y;
            end
            xs(count+1) = x2;
            ys(count+1) = y2;
            %xs(2) = x2;
            %ys(2) = y2;
        end

        [m,i] = max(vrs(x,y,:)); %vrs{3}(x,y) vrs{4}(x,y)]);
        resc(x,y,:) = imgsc(x,y,:,i);

        [m i] = max(vrs(x(:), y(:), :));
        resc(x,y,:) = imgsc(xs(i),ys(i),:, i);
    end
end

%figure;
%imshow(res);
figure;
imshow(resc);
imwrite(resc, 'results/fusion.ppm')

pause;
