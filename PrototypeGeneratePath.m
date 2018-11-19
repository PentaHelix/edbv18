%Author: Michael Raimer - 11701255
function [img, ret] = PrototypeGeneratePath(raster, img, imgs, region)
   [x,y] = findPoint(raster);
    [img, ret] = calculate(raster, img, imgs, region, x, y);
end

%Author: Michael Raimer - 11701255
function [x,y] = findPoint(raster)
    x = 0; y = 0;
    for y=1:6
        for x=1:4
            if(raster(y, x) == "point")
                return
            end
        end
    end

end

%Author: Michael Raimer - 11701255
function [img, ret] = calculate(raster, img, imgs, region, x, y)
    oldX = x;
    oldY = y;
    ret = 'ok';
    while ~strcmp(ret,'error') && ~strcmp(ret, 'end')
        [nextX, nextY, dir] = getNextCell(raster, oldX, oldY, x, y);
        next = raster(nextY, nextX);
        switch next
            case "hline"
                if(dir == "up" || dir == "down")
                    img = rotate(img, imgs, 1, nextX, nextY, region);
                end
            case "vline"
                if(dir == "left" || dir == "right")
                    img = rotate(img, imgs, 1, nextX, nextY, region);
                end
            case "point"
                ret = 'end';
                return
            case "cornerLU"
                [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    end
                 elseif(dir=="left")
                    
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    end 
                 end
            case "cornerLO"
                 [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    end 
                 end
            case "cornerRU"
                [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    end 
                 end
            case "cornerRO"
                 [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = 'error';
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 1, nextX, nextY, region);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = 'error';
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 2, nextX, nextY, region);
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 3, nextX, nextY, region);
                    end 
                 end
            case "nothing"
                ret= 'error';
                %return
        end
        oldX = x;
        oldY = y;
        x = nextX;
        y = nextY;
    end
    
end

%Author: Michael Raimer - 11701255
function img = rotate(img, imgs, n, x, y, region)
    k = 6*(x-1)+y;
    thisBB = region{k};
    s = size(imgs{k});
    if s(1) < s(2)
       a = s(1);
    end
    a = s(2);
    imgs{k} = imgs{k}(1:a, 1:a);
    imgs{k} = rot90(imgs{k}, n);  % IMPLEMENT Gerhard
    img(uint16(thisBB(2):thisBB(2)+a-1) , uint16(thisBB(1):thisBB(1)+a-1)) = imgs{k};
    %figure, imshow(img);
end % IMPLEMENT

%Author: Michael Raimer - 11701255
function [x, y, dir] = getNextCell(raster, oldX, oldY, x, y)
    dir = "nothing";
    if y < length(raster(:,1))
        if(raster(y+1, x) ~= "nothing" && (y+1 ~= oldY || x ~= oldX))
            y = y+1;
            dir = "down";
            return
        end
    end
    if x < length(raster(1,:))
        if(raster(y, x+1) ~= "nothing" && (y ~= oldY || x+1 ~= oldX))
            x = x+1;
            dir = "right";
            return
        end
    end
    if y > 1  
        if(raster(y-1, x) ~= "nothing" && (y-1 ~= oldY || x ~= oldX))
            y = y-1;
            dir = "up";
            return
        end
    end
    if x > 1
        if(raster(y, x-1) ~= "nothing" && (y ~= oldY || x-1 ~= oldX))
            x = x-1;
            dir = "left";
            return
        end
    end
end