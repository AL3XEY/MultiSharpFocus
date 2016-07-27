close all;
clear all;


pkg load image;

%img = imread('img/rice.pgm');
%[h,w] = size(img);
%label = zeros(h,w);
%n = 0 ; % le numéro du dernier label posé
%for i=1:h
%    for j=1:w
%        if label(i,j) == 0
%            n=n+1
%            label = set_label(img, label, i, j, n);
%        end
%    end
%end

%figure;
%imshow(img);

%figure;
%imagesc(label);

img = imread('img/sd/set2/img0.pgm');
%img = imread('img/rice.pgm');
[h,w,c] = size(img);
switch c
case 3
    imgGray = rgb2gray(img);
    [h,w,c] = size(imgGray);
case 1
    imgGray = img;
otherwise
    'Chuck Testa'
end
labelized = zeros(h+1,w+1);
l = 0;
figure;
imshow(imgGray);
img2 = zeros(h+1,w+1);
img2(2:h+1,2:w+1) = imgGray;
%img = img2;

img3(:,:)=255*sign(1+sign(img2(:,:)-60));
figure;
imshow(img3);

[img4 n] = bwlabel(img3);
figure;
colormap jet;
imagesc(img4);

img5 = edge(imgGray, 'Sobel');
%img5 = edge(imgGray, 'LoG');
figure;
imshow(img5);

ix(1:h-1,1:w) = diff(imgGray(:,:));
figure;
imshow(ix);
ix=ones(h,w);
ix(1:h-1,1:w) = diff(imgGray(:,:));

iy(1:w-1,1:h) = diff(imgGray(:,:)');
iy = iy';
figure;
imshow(iy);
iy=ones(w,h);
iy(1:w-1,1:h) = diff(imgGray(:,:)');
iy = iy';

%%%%%%

ixx(1:h-1,1:w) = diff(ix(:,:));
figure;
imshow(ixx);
ixx=ones(h,w);
ixx(1:h-1,1:w) = diff(ix(:,:));

iyy(1:w-1,1:h) = diff(iy(:,:)');
iyy = iyy';
figure;
imshow(iyy);
iyy=ones(w,h);
iyy(1:w-1,1:h) = diff(iy(:,:)');
iyy = iyy';

%%%%%%%%%%

[ix iy] = imgradientxy(imgGray, 'sobel');
figure;
imshow(ix);
figure;
imshow(mat2gray(ix));
figure;
imshow(iy);
figure;
imshow(mat2gray(iy));

pause;

threshold = 0;

if 1==0
    for i=2:h+1
        for j=2:w+1
            i
            a = abs(img(i,j-1) - img(i,j))==threshold;
            b = abs(img(i-1,j) - img(i,j))==threshold;

            %TODO first line and first column

            if a && !b
                labelized(i,j) = labelized(i,j-1);
            end
            if !a && b
                labelized(i,j) = labelized(i-1,j);
            end
            if !a && !b
                l = l+1;
                labelized(i,j) = l;
            end
            if a && b
                labelized(i,j) = labelized(i-1,j);
                if (labelized(i,j-1) ~= labelized(i-1,j))
                    flag = 0;
                    for x=2:h+1;
                        for y=2:w+1
                            %i
                            %j
                            %x
                            %y
                            if (x >= i) && (y >= j)
                                flag = 1;
                                break;
                            end
                            if (labelized(x,y) == labelized(i,j-1))
                                labelized(x,y) == labelized(i-1,j);
                            end
                        end
                        if (flag == 1)
                            break;
                        end
                    end
                end
            end
        end
    end

    labelized = labelized(2:h+1,2:w+1);

    figure;
    imagesc(labelized);

    labelized
end

pause;
