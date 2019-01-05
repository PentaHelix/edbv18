%Author: Michael Raimer - 11701255
function [img, ret, data] = GeneratePath(raster, img, imgs, region, count, data, ret, prototype)
    if count==0 %Normal-Mode:
        ret = "ok";
        [x,y] = findPoint(raster); %find start point
        oldX = x;
        oldY = y;
        while ~strcmp(ret,"error") && ~strcmp(ret, "end") %solange durchlaufen bis ein error auftritt, oder das ende erreicht wird
            [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, x, y, oldX, oldY, ret, prototype); %calculate how to rotate shape
            oldX = x;
            oldY = y;
            x = nextX;
            y = nextY;
        end 
    else %Debug-Mode:
        if count == 1 %Erster Durchlauf im Debug-Mode
            [x,y] = findPoint(raster); %find start point
            oldX = x;
            oldY = y;
            k=6*(x-1)+y;
            rectangle('Position', region{k}, ...
                'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--'); %aktuelle zelle markieren
            ret = "ok";
            [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, x, y, oldX, oldY, ret, prototype); %calculate how to rotate shape
            x = nextX;
            y = nextY;
            data = [oldX oldY x y];
        else %restlichen Durchläufe im Debug-mode
            [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, data(3), data(4), data(1), data(2), ret, prototype); %calculate how to rotate shape
            x = nextX;
            y = nextY;
            data = [data(3) data(4) x y]; %return data
        end
    end
end

%Author: Michael Raimer - 11701255
function [x,y] = findPoint(raster)
    % search start point
    x = 0; y = 0;
    for y=1:6
        for x=1:4
            if(raster(y, x) == "point")
                return;
            end
        end
    end

end

%Author: Michael Raimer - 11701255
function [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, x, y, oldX, oldY, ret, prototype)
        [nextX, nextY, dir] = getNextCell(raster, oldX, oldY, x, y);
        next = raster(nextY, nextX);
        if strcmp(dir, "nothing")
           ret="error";
           return;
        end
        switch next
            case "hline"
                ret="hline";
                if(dir == "up" || dir == "down")
                    img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    ret="vline";
                end
            case "vline"
                ret="vline";
                if(dir == "left" || dir == "right")
                    img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    ret="hline";
                end
            case "point"
                ret = "end";
                return
            case "cornerLU"
                [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                ret="cornerLU";
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerRO";
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerRU";
                    end
                 elseif(dir=="left")
                    
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerLO";
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerRO";
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerLO";
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerRU";
                    end 
                 end
            case "cornerLO"
                 [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 ret="cornerLO";
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerRO";
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerRU";
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerLU";
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerRO";
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerLU";
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerRU";
                    end 
                 end
            case "cornerRU"
                [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                ret="cornerRU";
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerRO";
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerLU";
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerLO";
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerRO";
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerLO";
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerLU";
                    end 
                 end
            case "cornerRO"
                 [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 ret="cornerRO";
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerRU";
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerLU";
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerLO";
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                        ret="cornerLO";
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                        ret="cornerLU";
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                        ret="cornerRU";
                    end 
                 end
            case "nothing"
                ret = "error";
                return;
        end
end

%Author: Michael Raimer - 11701255
function img = rotate(img, imgs, n, x, y, region, prototype)
    %rotate the image
    
    k = 6*(x-1)+y; %calc index
    thisBB = region{k};
    s = size(imgs{k});
    
    if s(1) < s(2)
       a = s(1);
    else
        a = s(2);
    end
    imgs{k} = imgs{k}(1:a, 1:a);
    
    %rotate 
    if prototype
        imgs{k} = rot90(imgs{k}, n);
    else
        imgs{k} = rotation(imgs{k}, n); % IMPLEMENT Gerhard
    end
    
    img(uint16(thisBB(2):thisBB(2)+a-1) , uint16(thisBB(1):thisBB(1)+a-1)) = imgs{k};
end

%Author: Michael Raimer - 11701255
function [x, y, dir] = getNextCell(raster, oldX, oldY, x, y)
    %find next cell with shape in it
    dir = "nothing";
    if y < length(raster(:,1)) %y innerhalb des rasters
        if(raster(y+1, x) ~= "nothing" && (y+1 ~= oldY || x ~= oldX)) %darunter überprüfen
            y = y+1;
            dir = "down";
            return;
        end
    end
    if x < length(raster(1,:)) %x innerhalb des rasters
        if(raster(y, x+1) ~= "nothing" && (y ~= oldY || x+1 ~= oldX)) %rechts überprüfen
            x = x+1;
            dir = "right";
            return;
        end
    end
    if y > 1  % y innerhalb des raster
        if(raster(y-1, x) ~= "nothing" && (y-1 ~= oldY || x ~= oldX)) %darüber überprüfen
            y = y-1;
            dir = "up";
            return;
        end
    end
    if x > 1 % x innerhalb des rasters
        if(raster(y, x-1) ~= "nothing" && (y ~= oldY || x-1 ~= oldX)) %links überprüfen
            x = x-1;
            dir = "left";
            return;
        end
    end
end