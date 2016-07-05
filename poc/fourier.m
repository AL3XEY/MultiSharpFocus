clear all;

%haar_test03()
%pause;

%img = imread("01.jpg");
img = imread("02.jpg");
%img = imread("IMG_7291.jpg");
%img = imread("IMG_7293-e1292255522923.jpg");

% convert image to grayscale

imgGray = rgb2gray(img);

% perform Fourier transform
IMG = fft2(img);
IMG = fftshift(IMG);
IMG = abs(IMG);
IMG = log(IMG+1);
IMG = mat2gray(IMG);

laplacian = zeros(3,3);
laplacian(1,2) = -1;
laplacian(2,1) = -1;
laplacian(2,3) = -1;
laplacian(3,2) = -1;
laplacian(2,2) = 4

%laplacian = fspecial("laplacian")
%laplacian = fspecial("laplacian",0.1)

res = conv2(imgGray, laplacian);
res = mat2gray(res);

% display the image in both temporal and frequential

figure(1);
imshow(img);
figure(2);
imshow(imgGray);
figure(3);
imshow(IMG);
figure(4);
imshow(res);

pause;
