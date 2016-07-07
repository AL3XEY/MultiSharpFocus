clear all;

full = 0;

%graphics_toolkit('fltk')
graphics_toolkit('gnuplot')

%haar_test03()
%pause;

%img = imread('img/01.jpg');
%img = imread('img/02.jpg'); %good
%img = imread('img/kidsblur.ppm'); %very good
%img = imread('img/lena.ppm'); %good

%img = imread('img/test1.jpg'); %good
%img = imread('img/test2.jpg'); % error: rgb2gray: the input must either be an RGB image or a colormap %kind of bad
%img = imread('img/test3.jpg'); %not bad
%img = imread('img/test4.jpg'); %very good
%img = imread('img/test5.jpg'); %very good
%img = imread('img/test6.jpg'); %very good
%img = imread('img/test7.jpg'); %surprisingly good => noisy original image
%img = imread('img/test8.jpg'); %very good

%img = imread('img/blur1.png'); %not so good
%img = imread('img/blur2.jpg'); %very good
%img = imread('img/blur3.jpg'); %really bad, logical
%img = imread('img/blur4.jpg'); %bad, logical

%img = imread('img/res1.jpg'); %very good
%img = imread('img/res2.jpg'); %very good
%img = imread('img/res3.jpg'); %very good
%img = imread('img/res4.jpg'); %very good
%img = imread('img/res5.jpg'); %slow but good
%img = imread('img/res6.jpg'); %very slow, quite good

% convert image to grayscale

%TODO if image is already grayscaled
imgGray = rgb2gray(img);
%imgGray = img; %if image is already grayscaled
[h,w]=size(img)
w=w/3

% perform Fourier transform
IMG = fft2(img);
IMG = fftshift(IMG);
IMG = abs(IMG);
IMG = log(IMG+1);
IMG = mat2gray(IMG);

laplacian = zeros(3);
laplacian(1,2) = 1;
laplacian(2,1) = 1;
laplacian(2,3) = 1;
laplacian(3,2) = 1;
laplacian(2,2) = -4;

%laplacian = ones(5);
%laplacian(3,3) = 8;
%laplacian(2,3) = -3;
%laplacian(4,3) = -3;
%laplacian(3,2) = -3;
%laplacian(3,4) = -3;

%laplacian = fspecial('laplacian');
%laplacian = fspecial('laplacian',0.1);

laplacian

res = conv2(imgGray, laplacian);
res = mat2gray(res);
%res = uint8(255 * mat2gray(res))
%res = histeq(res);

if full==0
	sx = zeros(h,w);
	sy = zeros(h,w);
	sxy = zeros(h,w);
	dx = zeros(h,w);
	dy = zeros(h,w);
	dxy = zeros(h,w);

	for i=1:h-1%211%h
		for j=1:w-1%329%w-1
			sx(i,j)=(imgGray(i,j)+imgGray(i+1,j))/2;
			dx(i,j)=imgGray(i+1,j)-imgGray(i,j);
		end
	end

	for i=1:h-1%211%h-1
		for j=1:w-1%329%w
			sy(i,j)=(imgGray(i,j)+imgGray(i,j+1))/2;
			dy(i,j)=imgGray(i,j+1)-imgGray(i,j);
		end
	end

	for i=1:h-1%211%h-1
		for j=1:w-1%329%w-1
			sxy(i,j)=(imgGray(i,j)+imgGray(i+1,j+1))/2;
			dxy(i,j)=imgGray(i+1,j+1)-imgGray(i,j);
		end
	end

	sx = mat2gray(sx);
	sy = mat2gray(sy);
	sxy = mat2gray(sxy);
	dx = mat2gray(abs(dx));
	dy = mat2gray(abs(dy));
	dxy = mat2gray(abs(dxy));
end

tau = 2;
f = 1/1000000000;
x0 = 1;
y0 = 1;
%for x=1:50%h-1
	%for y=1:50%w-1
		%stftx(x,y) = 0;
		%for u=1:212%h-1
			%for v=1:330%w-1
				%stftx(x,y) = stftx(x,y) + double(imgGray(u,v))*exp(-2*pi*i*f*(u*x*x0 + v*y*y0));

				%stftx(x,y) = stftx(x,y) + imgGray(u,v).*hann(tau)*exp(-2*pi*i*(u*x*x0 + v*y*y0));
			%end
		%end
	%end
%end
%figure;
%colormap jet;
%imagesc(stftx);

%stft = integral imgGray.*hann(tau).*exp(-li)


%figure;
%imshow(img);
figure;
imshow(imgGray);
%figure;
%imshow(IMG);
figure;
imshow(res);

if full==1
	figure;
	%colormap jet;
	imagesc(sx);

	figure;
	imagesc(sy);

	figure;
	imagesc(sxy);

	figure;
	imagesc(dx);

	figure;
	imagesc(dy);

	figure;
	imagesc(dxy);

	figure;
	imhist(imgGray);

	%figure;
	%[counts,locations]=imhist(imgGray);
	%stem(locations,counts);

	figure;
	imhist(res);

end

[counts,locations]=imhist(imgGray);
locations
counts
var(counts)

var(var(imgGray))
var(var(res))

edges = edge(res);

figure;
imshow(edges);

%se = offsetstrel('ball',5,5);
se = strel('square',3);

dil = edges;
for i=1:4
	dil = imdilate(dil,se);
end
%figure;
%imshow(dil);

for i=1:5
	dil = imerode(dil,se);
end
%figure;
%imshow(dil);

for i=1:10
	dil = imdilate(dil,se);
end
figure;
imshow(dil);

pause;
