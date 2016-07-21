clear all;
close all;
clc;

pkg load image;

%graphics_toolkit('gnuplot');

method = 6;
test = 3;

if test==1
    seq{1} = imread('img/fomd/fomd042.ppm');
    seq{2} = imread('img/fomd/fomd043.ppm');
    %seq{3} = imread('img/fomd/fomd042.ppm');
    %seq{4} = imread('img/fomd/fomd043.ppm');
    %seq{5} = imread('img/fomd/fomd044.ppm');
elseif test==2
    seq{1} = imread('img/lenat1.ppm');
    seq{2} = imread('img/lenat4.ppm');
elseif test==3
    seq{1} = imread('img/01.ppm');
    seq{2} = imread('img/02.ppm');
elseif test==4
    seq{1} = imread('img/sd/set1/img0.ppm');
    seq{2} = imread('img/sd/set1/img3.ppm');
elseif test==5
    seq{1} = imread('img/optical-flow/1.ppm');
    seq{2} = imread('img/optical-flow/2.ppm');
elseif test==6
    seq{1} = imread('img/optical-flow/1.png');
    seq{2} = imread('img/optical-flow/5.png');
elseif test==7
    seq{1} = imread('img/frame10.png');
    seq{2} = imread('img/frame11.png');
end


[h,w,c] = size(seq{1})

figure;
imshow(seq{1});
figure;
imshow(seq{2});
%figure;
%imshow(seq{3});
%figure;
%imshow(seq{4});
%figure;
%imshow(seq{5});

%best=zeros(h,w);
%for x=1:h
%    for y=1:w
%        min=999999;
%        epsilon=zeros(h,w);
%        for dx=1:h%-1
%            for dy=1:w%-1
%                for ux=x-wx:x+wx
%                    for uy=y-wy:y+wy
%                        %%%
%                        epsilon(dx,dy)
%                    end
%                end
%                if epsilon<min
%                    min=epsilon;
%                    edx=dx;
%                    edy=dy;
%                end
%            end
%        end
%        best(x,y)=
%    end
%end

%a = [2 3 5];
%b = [1 1 0];
%c = a+b;
%starts = zeros(3,3);
%ends = [a;b;c];
%figure;
%quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3))
%axis equal

%[x,y] = meshgrid(1:10,1:10);
%u = cos(x).*y;
%v = sin(x).*y;
%figure;
%quiver(x,y,u,v);


%for i=1:n
%    for j=1:n
%        min = 999999;
%        for di=1:n
%            for dj=1:n
%                rgbvalue = abs(seq{1}(i,j,:)-seq{2}(di,dj,:));
%                value = rgbvalue(1)+rgbvalue(2)+rgbvalue(3);
%                if value<min
%                    min=value;
%                    imin = di;
%                    jmin = dj;
%                end
%            end
%        end
%        new(i,j,:)=[imin jmin];
%    end
%end

%[x,y] = meshgrid(1:n,1:n);
%size(x)
%size(y)
%u = new(1:n,1:n,1);
%size(u)
%v = new(1:n,1:n,2);
%size(v)
%figure;
%quiver(x,y,u,v);
%set(gca,'YDir','reverse');  %# This flips the y axis
%axis equal

%%%%%%%%%%differenciation%%%%%%%%%%

%ix=ones(n);
%iy=ones(n);
%it=ones(n);
imgGray = rgb2gray(seq{1});

ix(1:h-1,1:w) = diff(imgGray(:,:));
figure;
imshow(ix);
ix=ones(h,w);
ix(1:h-1,1:w) = diff(imgGray(:,:));

iy(1:w-1,1:h) = diff(imgGray(:,:)');
iy = iy';
figure;
imshow(iy);
iy=ones(h,w);
iy(1:w-1,1:h) = diff(imgGray(:,:)');

foo(:,:,1) = imgGray(:,:);
foo(:,:,2) = rgb2gray(seq{2})(:,:);
%it(:,:) = diff(foo(:,:,:));

for i=1:h
    for j=1:w
        it(i,j) = diff(foo(i,j,:));
    end
end

figure;
imshow(it);

if method==1
    for k=4:7:40
        clear v;
        k
        for x=1:k:h-k+1
            for y=1:k:w-k+1
                %vx(i,j)=
                %vy(i,j)=
                a =sum(sum(ix(x:x+k-1,y:y+k-1).^2));
                %ix.*iy
                b = sum(sum(ix(x:x+k-1,y:y+k-1).*iy(x:x+k-1,y:y+k-1)));
                c = sum(sum(iy(x:x+k-1,y:y+k-1).*ix(x:x+k-1,y:y+k-1)));
                d = sum(sum(iy(x:x+k-1,y:y+k-1).^2));
                e = -sum(sum(ix(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));
                f = -sum(sum(iy(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));

                m1 = [[a b]' [c d]'];
                m2 = [e f]';
                %%m1 = [[sum(ix(:,:).^2) sum(ix(:,:).*iy(:,:))] [sum(iy(:,:).*ix(:,:)) sum(iy(:,:).^2)]]
                %%m2 = [[-sum(ix(:,:).*it(:,:))] [-sum(iy(:,:).*it(:,:))]]

                m1 = inv(m1);
                v((x+k-1)/k,(y+k-1)/k,:) = (m1*m2);
            end
        end
        v(:,:,2) = -v(:,:,2);
        [hh,ww,dd] = size(v);
        [x,y] = meshgrid(1:hh,1:ww);
        figure;
        quiver(x,y,v(:,:,1),v(:,:,2));
        set(gca,'YDir','reverse');  %# This flips the y axis
        %axis equal
    end
elseif method==2
    for k=4:7:40
        clear v;
        k
        for x=1:k:h-k+1
            for y=1:k:w-k+1
                %vx(i,j)=
                %vy(i,j)=
                a =sum(sum(ix(x:x+k-1,y:y+k-1).^2));
                %ix.*iy
                b = sum(sum(ix(x:x+k-1,y:y+k-1).*iy(x:x+k-1,y:y+k-1)));
                c = sum(sum(iy(x:x+k-1,y:y+k-1).*ix(x:x+k-1,y:y+k-1)));
                d = sum(sum(iy(x:x+k-1,y:y+k-1).^2));
                e = -sum(sum(ix(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));
                f = -sum(sum(iy(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));

                m1 = [[a b]' [c d]'];
                m2 = [e f]';
                %m1 = [[sum(ix(:,:).^2) sum(ix(:,:).*iy(:,:))] [sum(iy(:,:).*ix(:,:)) sum(iy(:,:).^2)]]
                %m2 = [[-sum(ix(:,:).*it(:,:))] [-sum(iy(:,:).*it(:,:))]]

                m1 = inv(m1);
                %v((x+k-1)/k,(y+k-1)/k,:) = (m1*m2);
                %%v=double(v);
                vxy = (m1*m2);
                v(x,y,:) = vxy;
            end
        end
        v(:,:,2) = -v(:,:,2);
        [hh,ww,dd] = size(v);
        [x,y] = meshgrid(1:hh,1:ww);
        figure;
        %imshow(seq{1});
        %axis([1 h 1 w]);
        %axis manual
        hold on;
        quiver(x,y,v(:,:,1),v(:,:,2));
        %axis([0 hh 0 ww]);
        set(gca,'YDir','reverse');  %# This flips the y axis
        %axis equal
        hold off;
    end
elseif method==3
    k=1
    for x=1:k:h-k+1
        for y=1:k:w-k+1
            %vx(i,j)=
            %vy(i,j)=
            a =sum(sum(ix(x:x+k-1,y:y+k-1).^2));
            %ix.*iy
            b = sum(sum(ix(x:x+k-1,y:y+k-1).*iy(x:x+k-1,y:y+k-1)));
            c = sum(sum(iy(x:x+k-1,y:y+k-1).*ix(x:x+k-1,y:y+k-1)));
            d = sum(sum(iy(x:x+k-1,y:y+k-1).^2));
            e = -sum(sum(ix(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));
            f = -sum(sum(iy(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));

            m1 = [[a b]' [c d]'];
            m2 = [e f]';
            %m1 = [[sum(ix(:,:).^2) sum(ix(:,:).*iy(:,:))] [sum(iy(:,:).*ix(:,:)) sum(iy(:,:).^2)]]
            %m2 = [[-sum(ix(:,:).*it(:,:))] [-sum(iy(:,:).*it(:,:))]]

            m1 = inv(m1);
            %v((x+k-1)/k,(y+k-1)/k,:) = (m1*m2);
            %%v=double(v);
            vxy = (m1*m2);
            v(x,y,:) = vxy;
        end
    end
    v(:,:,2) = -v(:,:,2);
    [hh,ww,dd] = size(v)
    v
    [x,y] = meshgrid(1:hh,1:ww);
    figure;
    imshow(seq{1});
    axis([1 h 1 w]);
    %axis manual
    hold on;
    quiver(x,y,v(:,:,1),v(:,:,2));
    %axis([0 hh 0 ww]);
    set(gca,'YDir','reverse');  %# This flips the y axis
    %axis equal
    hold off;
elseif method==4
    for k=4:7:40
        clear v;
        k
        for x=1:k:h-k+1
            for y=1:k:w-k+1
                %vx(i,j)=
                %vy(i,j)=
                a =sum(sum(ix(x:x+k-1,y:y+k-1).^2));
                %ix.*iy
                b = sum(sum(ix(x:x+k-1,y:y+k-1).*iy(x:x+k-1,y:y+k-1)));
                c = sum(sum(iy(x:x+k-1,y:y+k-1).*ix(x:x+k-1,y:y+k-1)));
                d = sum(sum(iy(x:x+k-1,y:y+k-1).^2));
                e = -sum(sum(ix(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));
                f = -sum(sum(iy(x:x+k-1,y:y+k-1).*it(x:x+k-1,y:y+k-1)));

                uu = (d*e - b*f)/(a*d - b^2);
                vv = (-(b*e) + a*f)/(a*d - b^2);

                v((x+k-1)/k,(y+k-1)/k,:) = [uu vv]';
            end
        end
        v(:,:,2) = -v(:,:,2);
        [hh,ww,dd] = size(v);
        [x,y] = meshgrid(1:hh,1:ww);
        figure;
        quiver(x,y,v(:,:,1),v(:,:,2));
        set(gca,'YDir','reverse');  %# This flips the y axis
        %axis equal
    end
elseif method==5
    A = zeros(h*w,4);
    L = zeros(h*w,1);
    B = zeros(4,1);
    v = zeros(h,w,2);

    for x=1:h
        for y=1:w
            A(x*y,1) = ix(x,y);
            A(x*y,2) = iy(x,y);
            A(x*y,3) = x*ix(x,y) + y*iy(x,y);
            A(x*y,4) = x*iy(x,y) - y*ix(x,y);
            B(x*y) = it(x,y) + x*ix(x,y) + y*iy(x,y);
        end
    end

    L = pinv(A)*B;

    a = L(1);
    b = L(2);
    c = L(3);
    d = L(4);
    x=1:h;
    y=1:w;

    %v(x,y,1) = (c-1)*x -d*y +a;
    %v(x,y,2) = d*x + (c-1)*y +b;

    %newimg = zeros(h,w);
    for x=1:h
        for y=1:w
            v(x,y,1) = (c-1)*x -d*y +a;
            v(x,y,2) = d*x + (c-1)*y +b;
    %        newimg(x,y) = imgGray(x+v(x,y,1),y+v(x,y,2));
        end
    end

    %newimg = zeros(h,w);
    %newimg(x,y)

    %v(:,:,2) = -v(:,:,2);
    [x,y] = meshgrid(1:h,1:w);
    figure;
    quiver(x,y,v(:,:,1),v(:,:,2));
    set(gca,'YDir','reverse');  %# This flips the y axis
    %%axis equal
elseif method==6
    A = zeros(h*w,4);
    L = zeros(h*w,1);
    B = zeros(4,1);
    v = zeros(h,w,2);

    for x=1:h
        for y=1:w
            A(x*y,1) = ix(x,y);
            A(x*y,2) = iy(x,y);
            A(x*y,3) = x*ix(x,y) + y*iy(x,y);
            A(x*y,4) = x*iy(x,y) - y*ix(x,y);
            B(x*y) = it(x,y);
        end
    end

    L = pinv(A)*B;

    a = L(1);
    b = L(2);
    c = L(3);
    d = L(4);
    x=1:h;
    y=1:w;

    %v(x,y,1) = (c-1)*x -d*y +a;
    %v(x,y,2) = d*x + (c-1)*y +b;

    %newimg = zeros(h,w);
    for x=1:h
        for y=1:w
            v(x,y,1) = c*x -d*y +a;
            v(x,y,2) = d*x + c*y +b;
    %        newimg(x,y) = imgGray(x+v(x,y,1),y+v(x,y,2));
        end
    end

    %newimg = zeros(h,w);
    %newimg(x,y)

    %v(:,:,2) = -v(:,:,2);
    [x,y] = meshgrid(1:h,1:w);
    figure;
    quiver(x,y,v(:,:,1),v(:,:,2));
    set(gca,'YDir','reverse');  %# This flips the y axis
    %%axis equal
end

figure
imshow(flowToColor(v))

for x=1:h
    for y=1:w
        v(x,y)
        round(v(x,y))
        x2 = x+round(v(x,y,1))
        y2 = y+round(v(x,y,2))
        if x2 < 1 || x2 >= h || y2 < 1 || y2 >= w %TODO find something better
            x2 = x;
            y2 = y;
        end

        res(x,y) = max([seq{1}(x2, y2) seq{2}(x, y)]);
        %res(x,y) = imgs(x,y,p);
        %resc(x,y,:) = imgsc(x,y,:,p);
    end
end

figure;
imshow(res);

pause;
