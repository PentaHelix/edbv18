%Author: Yana & Jakob
function [imgs, region] = Crop(img, prototype)
    % Trapezkorrektur IMPLEMENT Yana & Jakob
    if prototype
        con = [regionprops(img, 'Extrema', 'Area', 'BoundingBox', 'Centroid'); regionprops(not(img), 'Extrema', 'Area', 'BoundingBox', 'Centroid')];
    else    
        con = components(img);
    end
    
    x = [con.Area];
    y = find(x < max(x)*0.3 & x > max(x)*0.015);
    tmp=con(y);
    m = min([tmp.Area]);
    i = (m./[tmp.Area]) < 0.40;
    y(i) = []; 
    con = con(y);
    
    %sort
    extrema = cat(1, con.Centroid);
    left = extrema(:, 1);
    left = round(left/100)*100;
    right = extrema(:, 2);
    right = round(right/100)*100;

    
    
    [~, sort_order] = sortrows([left right]);
    con = con(sort_order);
    left = left(sort_order);
    right= right(sort_order);
    left(1:6) = max(left(1:6));
    left(7:12) = max(left(7:12));
    left(13:18) = max(left(13:18));
    left(19:24) = max(left(19:24));
    [~, sort_order] = sortrows([left right]);
    con = con(sort_order);

    

    for k = 1 : length(y)
        thisBB = con(k).BoundingBox;
        if prototype
            imgs{k} = imcrop(img, thisBB);
        else
            imgs{k} = myImcrop(img, thisBB);  % IMPLEMENT Yana & Jakob
        end
        region{k} = thisBB;
    end 
    
    
    %DEBUG-Ausgabe: 
    %for i = 1:length(y)
    %    rectangle('Position', con(i).BoundingBox, ...
    %    'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
    %end
end

%Author: Yana
function [stats] = myImcrop(img, scope)
    x = scope(1);
    y = scope(2);
    width = scope(3);
    height = scope(4);
    stats = img(y:y+height-1, x:x+width-1);
end

%Author: Jakob
function [stats] = components(Image)
    Image = logical(Image(:,:,1));
    stats = [];
    [w, h]=size(Image);
    comps = zeros(w,h);
    counter = 1;

    for i = 1:w
        for j = 1:h
            if(Image(i,j) == 1)
                 idx = ((j-1)*w + i);
                 comps(idx) = counter;
                 bb.x0 = h;
                 bb.y0 = w;
                 bb.x1 = 0;
                 bb.y1 = 0;
                 while ~isempty(idx)
                      Image(idx)=0;
                      
                      neighbors = idx + [-1; w; 1; -w]';
                      neighbors = neighbors(neighbors > 0 & neighbors < w * h);
                      neighbors = unique(neighbors(:));

                      idx = neighbors(Image(neighbors));
                      comps(idx)=counter;
                      
                      minY = min(mod(idx, w));
                      minX = min(floor(idx / w));
                      
                      maxY = max(mod(idx, w));
                      maxX = max(floor(idx / w));
                      
                      if (minX < bb.x0) bb.x0 = minX; end
                      if (minY < bb.y0) bb.y0 = minY; end
                      if (maxX > bb.x1) bb.x1 = maxX; end
                      if (maxY > bb.y1) bb.y1 = maxY; end
                      
                 end
                 
                 stats(counter).Index = counter;
                 stats(counter).BoundingBox = [bb.x0, bb.y0, bb.x1 - bb.x0, bb.y1 - bb.y0];
                 stats(counter).Area = (bb.x1 - bb.x0) * (bb.y1 - bb.y0);
                 
                 pixels = find(comps == counter);
                 
                 stats(counter).Centroid = floor([mean(floor(pixels / h)), mean(mod(pixels, w))]);
                 counter = counter + 1;
            end
        end
    end
end
