clear all;
close all;
clc;

pkg load image;

full = 0;

test=4

%Chose your test

switch test
case 1
    imgsc(:,:,:,1) = imread('img/sd/set1/img0.ppm');
    imgsc(:,:,:,2) = imread('img/sd/set1/img1.ppm');
    imgsc(:,:,:,3) = imread('img/sd/set1/img2.ppm');
    imgsc(:,:,:,4) = imread('img/sd/set1/img3.ppm');
case 2
    imgsc(:,:,:,1) = imread('img/sd/set2/img0.ppm');
    imgsc(:,:,:,2) = imread('img/sd/set2/img1.ppm');
    imgsc(:,:,:,3) = imread('img/sd/set2/img2.ppm');
    imgsc(:,:,:,4) = imread('img/sd/set2/img3.ppm');
case 3
    imgsc(:,:,:,1) = imread('img/bino/retouche/set1/101.ppm');
    imgsc(:,:,:,2) = imread('img/bino/retouche/set1/102.ppm');
    imgsc(:,:,:,3) = imread('img/bino/retouche/set1/103.ppm');
    imgsc(:,:,:,4) = imread('img/bino/retouche/set1/104.ppm');
    imgsc(:,:,:,5) = imread('img/bino/retouche/set1/105.ppm');
    imgsc(:,:,:,6) = imread('img/bino/retouche/set1/106.ppm');
    imgsc(:,:,:,7) = imread('img/bino/retouche/set1/107.ppm');
case 4
    imgsc(:,:,:,1) = imread('img/bino/retouche/set2/101.ppm');
    imgsc(:,:,:,2) = imread('img/bino/retouche/set2/102.ppm');
    imgsc(:,:,:,3) = imread('img/bino/retouche/set2/103.ppm');
    imgsc(:,:,:,4) = imread('img/bino/retouche/set2/104.ppm');
    imgsc(:,:,:,5) = imread('img/bino/retouche/set2/105.ppm');
    imgsc(:,:,:,6) = imread('img/bino/retouche/set2/106.ppm');
    imgsc(:,:,:,7) = imread('img/bino/retouche/set2/107.ppm');
case 5
    imgsc(:,:,:,1) = imread('img/bino/retouche/set3/051.ppm');
    imgsc(:,:,:,2) = imread('img/bino/retouche/set3/052.ppm');
    imgsc(:,:,:,3) = imread('img/bino/retouche/set3/053.ppm');
    imgsc(:,:,:,4) = imread('img/bino/retouche/set3/054.ppm');
    imgsc(:,:,:,5) = imread('img/bino/retouche/set3/055.ppm');
case 6
    imgsc(:,:,:,1) = imread('img/bino/retouche/set4/051.ppm');
    imgsc(:,:,:,2) = imread('img/bino/retouche/set4/052.ppm');
    imgsc(:,:,:,3) = imread('img/bino/retouche/set4/053.ppm');
    imgsc(:,:,:,4) = imread('img/bino/retouche/set4/054.ppm');
    imgsc(:,:,:,5) = imread('img/bino/retouche/set4/055.ppm');
case 7
    imgsc(:,:,:,1) = imread('img/bino/normal/set1/101.ppm');
    imgsc(:,:,:,2) = imread('img/bino/normal/set1/102.ppm');
    imgsc(:,:,:,3) = imread('img/bino/normal/set1/103.ppm');
    imgsc(:,:,:,4) = imread('img/bino/normal/set1/104.ppm');
    imgsc(:,:,:,5) = imread('img/bino/normal/set1/105.ppm');
    imgsc(:,:,:,6) = imread('img/bino/normal/set1/106.ppm');
    imgsc(:,:,:,7) = imread('img/bino/normal/set1/107.ppm');
case 8
    imgsc(:,:,:,1) = imread('img/bino/normal/set2/101.ppm');
    imgsc(:,:,:,2) = imread('img/bino/normal/set2/102.ppm');
    imgsc(:,:,:,3) = imread('img/bino/normal/set2/103.ppm');
    imgsc(:,:,:,4) = imread('img/bino/normal/set2/104.ppm');
    imgsc(:,:,:,5) = imread('img/bino/normal/set2/105.ppm');
    imgsc(:,:,:,6) = imread('img/bino/normal/set2/106.ppm');
    imgsc(:,:,:,7) = imread('img/bino/normal/set2/107.ppm');
case 9
    imgsc(:,:,:,1) = imread('img/bino/normal/set3/051.ppm');
    imgsc(:,:,:,2) = imread('img/bino/normal/set3/052.ppm');
    imgsc(:,:,:,3) = imread('img/bino/normal/set3/053.ppm');
    imgsc(:,:,:,4) = imread('img/bino/normal/set3/054.ppm');
    imgsc(:,:,:,5) = imread('img/bino/normal/set4/055.ppm');
case 10
    imgsc(:,:,:,1) = imread('img/bino/normal/set4/051.ppm');
    imgsc(:,:,:,2) = imread('img/bino/normal/set4/052.ppm');
    imgsc(:,:,:,3) = imread('img/bino/normal/set4/053.ppm');
    imgsc(:,:,:,4) = imread('img/bino/normal/set4/054.ppm');
    imgsc(:,:,:,5) = imread('img/bino/normal/set4/055.ppm');
otherwise
    'Please select a valid test (range : 1 - 10).'
end

%Get the size of the images and the number of elements in the dataset
[h,w,c,s] = size(imgsc)

%Measure sharpness of every pixel in every image
ctime(time())
for i=1:s
    vrs(:,:,i) = sharp_detect(imgsc(:,:,:,i), full);
end
ctime(time())
%Measure the optical flow between every couple of images
for i=1:s-1
    v(:,:,:,i) = optical_flow(imgsc(:,:,:,i), imgsc(:,:,:,i+1));
end
%If you don't want to use the optical flow, just comment the three previous lines (to avoid time loss) and uncomment the following one
%v = zeros(h,w,2,s-1);
ctime(time())

%Now, we are going to make the fusion between the images based on the sharpness and movement of each pixel
xs = zeros(1,s);
ys = zeros(1,s);
%v = round(v.*10);
v = round(v);
for x=1:h
    for y=1:w
        xs(1) = x;
        ys(1) = y;
        for count=1:s-1
            x2 = xs(count)+v(x,y,1,count); %TODO caution!!! We calculate optical flow between 1 and 2, 2 and 3, 3 and 4, etc.... So coordinates aren't x+dx but xs(i)+dx (but still, verify that it's correct)
            y2 = ys(count)+v(x,y,2,count);
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

        for kr=1:s
            foobar(kr) = vrs(xs(kr), ys(kr), kr);
        end
        %foobar(:) = vrs(xs(:), ys(:), :);
        [m i] = max(foobar(:));

        %[m i] = max(vrs(x(:), y(:), :));
        resc(x,y,:) = imgsc(xs(i),ys(i),:, i);
    end
end
ctime(time())

%Show the output image, entirely sharp! (I hope)
figure;
imshow(resc);
imwrite(resc, 'results/fusion.ppm')

pause;
