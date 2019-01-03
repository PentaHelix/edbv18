%Author: Michael Raimer - 11701255
function [imgs, region] = PrototypeCrop(img)
    stats = [regionprops(img, 'Extrema', 'Area', 'BoundingBox', 'Centroid'); regionprops(not(img), 'Extrema', 'Area', 'BoundingBox', 'Centroid')]; % IMPLEMENT Yana & Jakob
    
    x = [stats.Area];
    y = find(x < max(x)*0.15 & x > max(x)*0.015);
    stats = stats(y);
    
    %sort raster cells
    extrema = cat(1, stats.Centroid);
    left = extrema(:, 1);
    left = round(left/100)*100;
    right = extrema(:, 2);
    right = round(right/100)*100;

    
    [sorted, sort_order] = sortrows([left right]);
    stats = stats(sort_order);
    left = left(sort_order);
    right = right(sort_order);
    left(1:6) = max(left(1:6));
    left(7:12) = max(left(7:12));
    left(13:18) = max(left(13:18));
    left(19:24) = max(left(19:24));
    [sorted, sort_order] = sortrows([left right]);
    
    stats = stats(sort_order);

    

    for k = 1 : length(y)
        thisBB = stats(k).BoundingBox;
        imgs{k} = imcrop(img, thisBB);
        region{k} = thisBB;
    end
    
    
    %DEBUG-Ausgabe: 
    %for i = 1:length(y)
    %    rectangle('Position', stats(i).BoundingBox, ...
    %    'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
    %end
end