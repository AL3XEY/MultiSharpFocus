function [v] = optical_flow( img1, img2, method=6, debug=0 )

    pkg load image;

    %graphics_toolkit('gnuplot');

    seq{1} = img1;
    seq{2} = img2;
    %TODO if non the same size (including pixel size), error

    [h,w,c] = size(seq{1})

    if debug == 1
        figure;
        imshow(seq{1});
        figure;
        imshow(seq{2});
    end

    %%%%%%%%%%differenciation%%%%%%%%%%

    %ix=ones(n);
    %iy=ones(n);
    %it=ones(n);
    imgGray = rgb2gray(seq{1});

    if debug == 1
        ix(1:h-1,1:w) = diff(imgGray(:,:));
        figure;
        imshow(ix);
    end
    ix=ones(h,w);
    ix(1:h-1,1:w) = diff(imgGray(:,:));

    if debug == 1
        iy(1:w-1,1:h) = diff(imgGray(:,:)');
        iy = iy';
        figure;
        imshow(iy);
    end
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

    if debug == 1
        figure;
        imshow(it);
    end

    switch method
    case 1
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
    case 2
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
    case 3
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
    case 4
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
    case 5
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
    case 6
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
    otherwise
        'No method selected. Please select a method between 1 and 6.'
    end

    figure
    imshow(flowToColor(v))

end
