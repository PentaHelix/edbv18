%Author: Yana & Jakob & Michael
function [imgs, region] = Crop(img, prototype)
    
    %get all cells/regions
    if prototype
        con = [regionprops(img, 'Extrema', 'Area', 'BoundingBox', 'Centroid'); regionprops(not(img), 'Extrema', 'Area', 'BoundingBox', 'Centroid')];
    else    
        con = components(img);
    end
    
    % filter all regions to get only the needed ones
    x = [con.Area];
    y = find(x < max(x)*0.3 & x > max(x)*0.015);
    tmp=con(y);
    m = min([tmp.Area]);
    i = (m./[tmp.Area]) < 0.40;
    y(i) = []; 
    con = con(y);
    
    % sort all cells for the right order
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

    
    % crop the image
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
%This function crops an image img by a cropping rectangle scope. 
function [stats] = myImcrop(img, scope)
    x = scope(1);
    y = scope(2);
    width = scope(3);
    height = scope(4);
    stats = img(y:y+height-1, x:x+width-1);
end

%Author: Jakob
function [stats] = components(Image)
    % convert image to logical
    Image = logical(Image(:,:,1));
    stats = [];
    [w, h]=size(Image);
    % matrix that holds information about which pixel belongs to which
    % component
    comps = zeros(w,h);
    % first components = id 1
    counter = 1;

    % loop through all pixels
    for i = 1:w
        for j = 1:h
            
            if(Image(i,j) == 1)
                 idx = ((j-1)*w + i);
                 comps(idx) = counter;
                 % default bounding box to be the size of the whole image,
                 % but inverted
                 bb.x0 = h;
                 bb.y0 = w;
                 bb.x1 = 0;
                 bb.y1 = 0;
                 while ~isempty(idx)
                      Image(idx)=0;
                       
                      % get the neighbors of all the pixels from the previous
                      % iteration
                      neighbors = idx + [-1; w; 1; -w]';
                      % clamp possible pixel values so that there are no
                      % pixels outside of the image bounds
                      neighbors = neighbors(neighbors > 0 & neighbors < w * h);
                      % remove dupliace pixels
                      neighbors = unique(neighbors(:));
                        
                      % remove pixels which are not white in the image
                      idx = neighbors(Image(neighbors));
                      comps(idx)=counter;
                      
                      % get the minimum and maximum pixel ofthe current
                      % selection
                      minY = min(mod(idx, w));
                      minX = min(floor(idx / w));
                      
                      maxY = max(mod(idx, w));
                      maxX = max(floor(idx / w));
                      
                      % if the currently considered pixels are outside of
                      % the bounding box, increase the bounding box size 
                      if (minX < bb.x0) bb.x0 = minX; end
                      if (minY < bb.y0) bb.y0 = minY; end
                      if (maxX > bb.x1) bb.x1 = maxX; end
                      if (maxY > bb.y1) bb.y1 = maxY; end
                      
                 end
                 
                 % set stats for the component with index 'counter'
                 stats(counter).Index = counter;
                 % bounding box is calculated in the loop, just convert it to
                 % the format used in the following pipeline
                 stats(counter).BoundingBox = [bb.x0, bb.y0, bb.x1 - bb.x0, bb.y1 - bb.y0];
                 %% calculate area of/from bounding box
                 stats(counter).Area = (bb.x1 - bb.x0) * (bb.y1 - bb.y0);
                 
                 % get pixel indices of component
                 pixels = find(comps == counter);
                 
                 % calculate centroid (mean of all pixel coordinates)
                 stats(counter).Centroid = floor([mean(floor(pixels / h)), mean(mod(pixels, w))]);
                 counter = counter + 1;
            end
        end
    end
end
