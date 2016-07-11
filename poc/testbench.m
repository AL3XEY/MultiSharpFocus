%testbench.m
%

clear all;
clc;

pkg load image;

%graphics_toolkit('fltk');
graphics_toolkit('gnuplot');

full = 0;

%sharp_detect('img/01.jpg', full); %bad
%sharp_detect('img/02.jpg', full); %good
%sharp_detect('img/kidsblur.ppm', full); %very good
%sharp_detect('img/lena.ppm', full); %good

%sharp_detect('img/test1.jpg', full); %good
%sharp_detect('img/test2.jpg', full); % error: rgb2gray: the input must either be an RGB image or a colormap %kind of bad
%sharp_detect('img/test3.jpg', full); %not bad
%sharp_detect('img/test4.jpg', full); %very good
%sharp_detect('img/test5.jpg', full); %very good %PYRAMID
%sharp_detect('img/test6.jpg', full); %very good
%sharp_detect('img/test7.jpg', full); %surprisingly good => noisy original image
%sharp_detect('img/test8.jpg', full); %very good

%sharp_detect('img/blur1.png', full); %not so good
%sharp_detect('img/blur2.jpg', full); %very good
%sharp_detect('img/blur3.jpg', full); %really bad, logical
%sharp_detect('img/blur4.jpg', full); %bad, logical

%sharp_detect('img/res1.jpg', full); %very good
%sharp_detect('img/res2.jpg', full); %very good
%sharp_detect('img/res3.jpg', full); %very good
%sharp_detect('img/res4.jpg', full); %very good
%sharp_detect('img/res5.jpg', full); %slow but good
%sharp_detect('img/res6.jpg', full); %very slow, quite good

%sharp_detect('img/sharp1.jpg', full); %kind of good : clouds + ground not really detected
%sharp_detect('img/sharp2.jpg', full); %kind of good : clouds + regular walls not detected
%sharp_detect('img/sharp3.jpg', full); %kind of bad
%sharp_detect('img/sharp4.jpg', full); %bad : clouds not detected at all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%imgs(:,:,1) = imread('img/01.pgm');
%imgs(:,:,2) = imread('img/02.pgm');

%imgsc(:,:,:,1) = imread('img/01.ppm');
%imgsc(:,:,:,2) = imread('img/02.ppm');

%vrs(:,:,1) = sharp_detect('img/01.ppm', full);
%vrs(:,:,2) = sharp_detect('img/02.ppm', full);

%%%%%%%%%%

%%img = imread('img/sd/set2/img0.ppm');
%%imgs(:,:,1) = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;
%%img = imread('img/sd/set2/img1.ppm');
%%imgs(:,:,2) = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;
%%img = imread('img/sd/set2/img2.ppm');
%%imgs(:,:,3) = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

imgs(:,:,1) = imread('img/sd/set2/img0.pgm');
imgs(:,:,2) = imread('img/sd/set2/img1.pgm');
imgs(:,:,3) = imread('img/sd/set2/img2.pgm');
imgsc(:,:,:,1) = imread('img/sd/set2/img0.ppm');
imgsc(:,:,:,2) = imread('img/sd/set2/img1.ppm');
imgsc(:,:,:,3) = imread('img/sd/set2/img2.ppm');
vrs(:,:,1) = sharp_detect('img/sd/set2/img0.ppm', full);
vrs(:,:,2) = sharp_detect('img/sd/set2/img1.ppm', full);
vrs(:,:,3) = sharp_detect('img/sd/set2/img2.ppm', full);

%%%%%%%%%%

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

[h,w,c] = size(vrs)

for x=1:h
    for y=1:w
        [v,p] = max(vrs(x,y,:));
        res(x,y) = imgs(x,y,p);
        resc(x,y,:) = imgsc(x,y,:,p);
    end
end

figure;
imshow(res);
imwrite(res, 'results/res.pgm')
figure;
imshow(resc);
imwrite(resc, 'results/res.ppm')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%im1 = imread('img/01.jpg');
%im1 = rgb2gray(im1);
%im2 = imread('img/01.jpg');
%im2 = rgb2gray(im2);
%[u,v,cert] = HierarchicalLK(im1, im2, 3, 1, 1, 1

of=0
if of==1
    images(:,:,1) = imread('img/lenat1.pgm');
    images(:,:,2) = imread('img/lenat2.pgm');
    alpha = 1;
    iterations = 1;
    [Vx,Vy] = OpticalFlow(images,alpha,iterations);

    [h,w,c] = size(images);
    [x,y] = meshgrid(1:h,1:w);
    %size(x)
    %size(y)
    %u = new(1:n,1:n,1);
    %size(u)
    %v = new(1:n,1:n,2);
    %size(v)
    figure;
    Vy = -Vy;
    quiver(x,y,Vx,Vy);
    set(gca,'YDir','reverse');  %# This flips the y axis
    axis equal


    %Vx = floor(100*mat2gray(Vx));
    Vx = floor(h.*Vx./(max(Vx)-min(Vx)))
    %interest[xxmax+k][yymax+l] =  (byte)((cvalues[xxmax][yymax]-min)*255.0/(max - min));
    Vy = floor(w.*Vy./(max(Vy)-min(Vy)))
    %images(10,10,1) = 0;
    %images(10+Vx(10,10),10+Vy(10,10),2) = 0;

    Vx(10,10)

    images(50,50,1) = 0;
    images(50+Vx(50,50),50+Vy(50,50),2) = 0;

    %images(20,70,1) = 0;
    %images(20+Vx(20,70),70+Vy(20,70),2) = 0;

    figure;
    imshow(images(:,:,1));

    figure;
    imshow(images(:,:,2));

    size(images)
end

pause;
