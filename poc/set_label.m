function labelImage = set_label( image, labelImage, i, j, n )
    if labelImage(i,j) == 0
        labelImage(i, j) = n
    end
    %[h,w] = size(image);
    %for x=-1:1
    %    for y=-1:1
    %        if (i+x != 0) && (i+x != h+1) && (j+y != 0) && (j+y != w)
    %            if image(i,j) - image(i+x,j+y) < 10
    %                labelImage = set_label (image, labelImage, i+x, j+y, n);
    %            end
    %        end
    %    end
    %end
end
