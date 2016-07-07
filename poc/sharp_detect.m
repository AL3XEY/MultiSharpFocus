function [ ] = sharp_detect( path, full=0 )
%sharp_detect Detects and displays sharp zones in an image
%   Detects sharp zones using a 3x3 Laplacian filter and an edge detector, then dilations and erosions

    img = imread(path);

    %convert image into grayscale format if it's not already
    [h,w,c]=size(img)
    if c==3
    	imgGray = rgb2gray(img);
    	w=w/3;
    else
    	imgGray = img;
    end

    if full==1
    	% perform Fourier transform
    	IMG = fft2(img);
    	IMG = fftshift(IMG);
    	IMG = abs(IMG);
    	IMG = log(IMG+1);
    	IMG = mat2gray(IMG);
    end

    %create and apply Laplacian filter
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

        %attempt to use local 2D Fourier Transform
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

    end

    %figure;
    %imshow(img);

    figure;
    imshow(imgGray);

    figure;
    imshow(res);

    if full==1
    	figure;
    	imshow(IMG);

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

end;
