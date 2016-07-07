% wavelab-test --
%
addpath /usr/toolbox/Wavelab850
WavePath

img = imread('img/lena.pgm');
[h,w] = size(img)

%figure('Position',[0,0,800,600]);
%clf;
%subplot(121);
%imshow(img);
%title('Original Image');

[n,J] = dyadlength(img);

Q = MakeONFilter('Haar',2);
wimg = FWT2_PO(img,J-1,Q);

%subplot(122);
zmat = sqrt(abs(wimg));
%zmat = 256-3.8*zmat;
%zmat = uint8(255 * mat2gray(zmat))
%imshow(zmat);
HH1 = zmat((w/2)+1:w,(h/2)+1:h);
LH1 = zmat(1:(w/2),(h/2)+1:h);
HL1 = zmat((w/2)+1:w,1:(h/2));
LL1 = zmat(1:(w/2),1:(h/2));

Emap1 = sqrt((HH1.^2) .+ (LH1.^2) .+ (HL1.^2))

HH2 = zmat((w/4)+1:(w/2),(h/4)+1:(h/2));
LH2 = zmat(1:(w/4),(h/4)+1:(h/2));
HL2 = zmat((w/4)+1:(w/2),1:(h/4));
LL2 = zmat(1:(w/4),1:(h/4));
Emap2 = sqrt((HH2.^2) .+ (LH2.^2) .+ (HL2.^2))

%figure('Position',[0,0,800,600]);
%AutoImage(LL1);
%title('2D Haar Wavelet Transform');

figure;
colormap jet;
imagesc(Emap1);

figure;
Emap1 = uint8(255 * mat2gray(Emap1));
imagesc(Emap1);

figure;
Emap1 = mat2gray(Emap1);
imagesc(Emap1);

pause;
