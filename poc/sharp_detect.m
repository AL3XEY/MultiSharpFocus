function [sm] = sharp_detect( img, full=0 )
%sharp_detect Detects and displays sharp zones in an image
%   Detects sharp zones using a 3x3 Laplacian filter and an edge detector, then dilations and erosions

    pkg load image;

    if ischar(img)
        img = imread(img);
    end

    %convert image into grayscale format if it's not already
    [h,w,c]=size(img);
    switch c
    case 3
    	imgGray = rgb2gray(img);
    	w=w/3;
    case 1
    	imgGray = img;
    otherwise
        'Error : input must be RGB or Grayscale'
    end

    %if full==1
    	% perform Fourier transform
    	%IMG = fft2(img);
    	%IMG = fftshift(IMG);
    	%IMG = abs(IMG);
    	%IMG = log(IMG+1);
    	%IMG = mat2gray(IMG);
    %end

    if full==1
        %create and apply Laplacian filter
        laplacian = zeros(3);
        laplacian(1,2) = 1;
        laplacian(2,1) = 1;
        laplacian(2,3) = 1;
        laplacian(3,2) = 1;
        laplacian(2,2) = -4;

        %laplacian = ones(3);
        %laplacian(2,2) = -2;

        %laplacian = ones(5);
        %laplacian(3,3) = 8;
        %laplacian(2,3) = -3;
        %laplacian(4,3) = -3;
        %laplacian(3,2) = -3;
        %laplacian(3,4) = -3;

        %laplacian = fspecial('laplacian');
        %laplacian = fspecial('laplacian',0.1);

        %laplacian = ones(9);
        %laplacian(1,:) = [0 1 1 2 2 2 1 1 0];
        %laplacian(2,:) = [1 2 4 5 5 5 4 2 1];
        %laplacian(3,:) = [1 4 5 3 0 3 5 4 1];
        %laplacian(4,:) = [2 5 3 -12 -24 -12 3 5 2];
        %laplacian(5,:) = [2 5 0 -24 -40 -24 0 5 2];
        %laplacian(6,:) = [2 5 3 -12 -24 -12 3 5 2];
        %laplacian(7,:) = [1 4 5 3 0 3 5 4 1];
        %laplacian(8,:) = [1 2 4 5 5 5 4 2 1];
        %laplacian(9,:) = [0 1 1 2 2 2 1 1 0];

        laplacian

        res = conv2(imgGray, laplacian);
        res = mat2gray(res);
        %res = uint8(255 * mat2gray(res))
        %res = histeq(res);
    end

    %if full==1
    %	sx = zeros(h,w);
    %	sy = zeros(h,w);
    %	sxy = zeros(h,w);
    %	dx = zeros(h,w);
    %	dy = zeros(h,w);
    %	dxy = zeros(h,w);
    %
    %	for i=1:h-1%211%h
    %		for j=1:w-1%329%w-1
    %			sx(i,j)=(imgGray(i,j)+imgGray(i+1,j))/2;
    %			dx(i,j)=imgGray(i+1,j)-imgGray(i,j);
    %		end
    %	end
    %
    %	for i=1:h-1%211%h-1
    %		for j=1:w-1%329%w
    %			sy(i,j)=(imgGray(i,j)+imgGray(i,j+1))/2;
    %			dy(i,j)=imgGray(i,j+1)-imgGray(i,j);
    %		end
    %	end

    %	for i=1:h-1%211%h-1
    %		for j=1:w-1%329%w-1
    %			sxy(i,j)=(imgGray(i,j)+imgGray(i+1,j+1))/2;
    %			dxy(i,j)=imgGray(i+1,j+1)-imgGray(i,j);
    %		end
    %	end

    %	sx = mat2gray(sx);
    %	sy = mat2gray(sy);
    %	sxy = mat2gray(sxy);
    %	dx = mat2gray(abs(dx));
    %	dy = mat2gray(abs(dy));
    %	dxy = mat2gray(abs(dxy));

        %attempt to use local 2D Fourier Transform
        %tau = 2;
        %f = 1/1000000000;
        %x0 = 1;
        %y0 = 1;
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

    %end

    %figure;
    %imshow(img);

    %figure;
    %imshow(imgGray);
    %title('Grayscale');

    if full==1
        figure;
        imshow(res);
        title('Convolution with Laplacian');
    end

    %if full==1
    %	figure;
    %	imshow(IMG);
    %    title('2DFFT');

    %	figure;
    %	%colormap jet;
    %	imagesc(sx);

    %	figure;
    %	imagesc(sy);

    %	figure;
    %	imagesc(sxy);

    %	figure;
    %	imagesc(dx);

    %	figure;
    %	imagesc(dy);

    %	figure;
    %	imagesc(dxy);

    	%figure;
    	%imhist(imgGray);
        %title('Histogram of grayscales');

    	%figure;
    	%[counts,locations]=imhist(imgGray);
    	%stem(locations,counts);

    	%figure;
    	%imhist(res);
        %title('Histogram of the image convoluted by a Laplacian filter');

    %end

    %if full==1
    %    [counts,locations]=imhist(imgGray);
    %    locations
    %    counts
    %    var(counts)
    %
    %    var(var(imgGray))
    %    var(var(res))
    %end

    if full==1
        edges = edge(res); %Sobel

        figure;
        imshow(edges);
        title('Sobel filter on the result of the convolution by a Laplacian filter');

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
        title('Result of dilations and erosions applied to se Sobel filtered image');
    end

    %local variance
    [h,w]=size(imgGray);
    v = zeros(h,w);
    vr = zeros(h,w);
    vrr = zeros(h,w);
    vr2 = zeros(h,w);
    vrr2 = zeros(h,w);

    %for i=2:h-1%211%h-1
    %    for j=2:w-1%329%w-1
    %        a = imgGray(i-1:i+1,j-1);
    %        b = imgGray(i-1:i+1,j+1);
    %        c = imgGray(i,j-1);
    %        d = imgGray(i,j+1);
    %        neighbours = [reshape(a, [1,3]) reshape(b, [1,3]) c d];
    %        %v(i,j) = var(neighbours);
    %        v(i,j) = abs(mean(neighbours) - imgGray(i,j));
    %    end
    %end

    %fv = [[1/24 1/24 1/24 1/24 1/24] [1/24 1/24 1/24 1/24 1/24] [1/24 1/24 -1 1/24 1/24] [1/24 1/24 1/24 1/24 1/24] [1/24 1/24 1/24 1/24 1/24]]
    %v = conv2(v, fv);

if full==1
    for i=3:(h-2)%211%h-1
        for j=3:(w-2)%329%w-1
            a = imgGray((i-2):(i+2),(j-2):(j-1));
            b = imgGray((i-2):(i+2),(j+1):(j+2));
            c = imgGray(i,(j-2):(j-1));
            d = imgGray(i,(j+1):(j+2));
            neighbours = [reshape(a, [1,10]) reshape(b, [1,10]) c d];
            %v(i,j) = var(neighbours);
            v(i,j) = abs(mean(neighbours) - imgGray(i,j));

            %if full==1
            %    vr(i,j) = vr(i,j) + v(i,j);
            %    vr(i-2:i+2,j-2:j+2) = vr(i-2:i+2,j-2:j+2) + v(i,j);
            %end

            %if full==1
                vrr(i-1:i+1,j) = vrr(i-1:i+1,j) + 2*v(i,j);
                vrr(i,j-1:j+1) = vrr(i,j-1:j+1) + 2*v(i,j);
                vrr(i,j-2) = vrr(i,j-2) + v(i,j);
                vrr(i,j+2) = vrr(i,j+2) + v(i,j);
                vrr(i-2,j) = vrr(i-2,j) + v(i,j);
                vrr(i+2,j) = vrr(i+2,j) + v(i,j);
                vrr(i-1,j-1) = vrr(i-1,j-1) + v(i,j);
                vrr(i-1,j+1) = vrr(i-1,j+1) + v(i,j);
                vrr(i+1,j-1) = vrr(i+1,j-1) + v(i,j);
                vrr(i+1,j+1) = vrr(i+1,j+1) + v(i,j);
            %end

        end
    end
end

%if full==1
    fv = ones(5);
    fv(:,:) = fv(:,:)/24;
    fv(3,3) = -1;
    %v = imfilter(imgGray,fv, 'conv');
    v = conv2(imgGray,fv, 'same');
    v = abs(v);
    %v = mat2gray(v);
    %v = floor(255.*v);
    fvr = ones(5);
    fvr(3,3) = 2;
    %vr = imfilter(v,fvr, 'conv');
    vr = conv2(v,fvr, 'same');

    for i=1:9 %TODO this is just a test for now
        vr = conv2(vr,fvr, 'same');
    end

    %vr = mat2gray(vr);
    %vr = floor(255.*vr);

    %fvr = [[1 1 1] [1 2 1] [1 1 1]]
    %fvrr = [[-1 -1 0 -1 -1]' [-1 0 1 0 -1]' [0 1 4 1 0]' [-1 0 1 0 -1]' [-1 -1 0 -1 -1]']
    %fvrr = [[0 0 1 0 0]' [0 1 2 1 0]' [1 2 4 2 1]' [0 1 2 1 0]' [0 0 1 0 0]']
    %vr = conv2(v, fvr);
    %vrr = conv2(v, fvrr, 'same');
%end

    if full==1
        figure;
        colormap jet;
        imagesc(v);
        title('Variance of pixel values in original grayscale image');
    end

    %v = mat2gray(v);
    %figure;
    %imshow(v);

    if full==1
        for i=1:h-1
            for j=1:w-1
                if dil(i,j) == 0;
                    vrr2(i,j) = v(i,j);
                    vr2(i,j) = v(i,j);
                else
                    vrr2(i,j) = vrr(i,j);
                    vr2(i,j) = vr(i,j);
                end
            end
        end
    end

    %if full==1
        figure;
        imagesc(vr);
        %vrnorm = mat2gray(vr);
        %imshowpair(img, vrnorm, 'montage');
        %title('Variance accentuation');
    %end
    if full==1
        figure;
        imagesc(vr2);
        title('Variance localized accentuation');
    end
    if full==1
        figure;
        imagesc(vrr);
        title('Variance strong accentuation');
    end
    if full==1
        figure;
        imagesc(vrr2);
        title('Variance localized strong accentuation');
    end

    sm = vr;
    %sm = vr2;
    %sm = vrr;
    %sm = vrr2;

end;
