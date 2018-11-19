%Author: Michael Raimer - 11701255
function [imgs, region] = PrototypeCrop(img)
    % Trapezkorrektur IMPLEMENT Yana & Jakob
    stats = [regionprops(img, 'Extrema', 'Area', 'BoundingBox', 'Centroid'); regionprops(not(img), 'Extrema', 'Area', 'BoundingBox', 'Centroid')]; % IMPLEMENT Yana & Jakob
    
    x = [stats.Area];
    y = find(x < max(x)*0.15 & x > max(x)*0.015);
    stats = stats(y);
    
    %sort
    extrema = cat(1, stats.Centroid);
    left = extrema(:, 1);
    left = round(left/100)*100;
    right = extrema(:, 2);
    right = round(right/100)*100;

    
    [sorted, sort_order] = sortrows([left right]);
    stats = stats(sort_order);

    

    for k = 1 : length(y)
        thisBB = stats(k).BoundingBox;
        imgs{k} = imcrop(img, thisBB);  % IMPLEMENT Yana & Jakob
        region{k} = thisBB;
    end 
    
    
    %DEBUG-Ausgabe: 
    %for i = 1:length(y)
    %    rectangle('Position', stats(i).BoundingBox, ...
    %    'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
    %end
end