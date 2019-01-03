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

%Author: Yana & Jakob
function [stats] = myImcrop(img, scope)
    x = scope(1);
    y = scope(2);
    width = scope(3);
    height = scope(4);
    stats = img(y:y+height-1, x:x+width-1);
end

%Author: Yana & Jakob
function [stats] = components(Image)
    stats = [];
    [M, N]=size(Image);
    Connected = zeros(M,N);
    Mark = 1;
    Offsets = [-1; M; 1; -M];

    for i = 1:M
        for j = 1:N
            if(Image(i,j)==1)
                 Index = ((j-1)*M + i);
                 Connected(Index)=Mark;
                 bb.x0 = N;
                 bb.y0 = M;
                 bb.x1 = 0;
                 bb.y1 = 0;
                 while ~isempty(Index)
                      Image(Index)=0;
                      Neighbors = bsxfun(@plus, Index, Offsets');
                      Neighbors = unique(Neighbors(:));
                      Neighbors = Neighbors(Neighbors > 0 & Neighbors < M * N);
                      Index = Neighbors(Image(Neighbors));
                      Connected(Index)=Mark;
                      
                      minY = min(mod(Index, M));
                      minX = min(floor(Index / M));
                      
                      maxY = max(mod(Index, M));
                      maxX = max(floor(Index / M));
                      
                      if (minX < bb.x0) bb.x0 = minX; end
                      if (minY < bb.y0) bb.y0 = minY; end
                      if (maxX > bb.x1) bb.x1 = maxX; end
                      if (maxY > bb.y1) bb.y1 = maxY; end
                      
                 end
                 
                 stats(Mark).Index = Mark;
                 stats(Mark).BoundingBox = [bb.x0, bb.y0, bb.x1 - bb.x0, bb.y1 - bb.y0];
                 stats(Mark).Area = (bb.x1 - bb.x0) * (bb.y1 - bb.y0);
                 
                 pixels = find(Connected == Mark);
                 
                 stats(Mark).Centroid = floor([mean(floor(pixels / N)), mean(mod(pixels, M))]);
                 Mark = Mark + 1;
            end
        end
    end
end
