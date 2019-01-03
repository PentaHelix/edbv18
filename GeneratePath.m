%Author: Michael Raimer - 11701255
function [img, ret, data] = GeneratePath(raster, img, imgs, region, count, data, ret, prototype)
    try
        if count==0
            ret = "ok";
            [x,y] = findPoint(raster);
            oldX = x;
            oldY = y;
            while ~strcmp(ret,"error") && ~strcmp(ret, "end")
                [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, x, y, oldX, oldY, ret, prototype);
                oldX = x;
                oldY = y;
                x = nextX;
                y = nextY;
            end 
        else
            if count == 1
                [x,y] = findPoint(raster);
                oldX = x;
                oldY = y;
                ret = "ok";
                [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, x, y, oldX, oldY, ret, prototype);
                x = nextX;
                y = nextY;
                data = [oldX oldY x y];
            else
                [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, data(3), data(4), data(1), data(2), ret, prototype);
                x = nextX;
                y = nextY;
                data = [data(3) data(4) x y];
            end
        end
    catch ME
        ret = 'ERROR!';
    end
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
function [img, ret, nextX, nextY] = calculate(raster, img, imgs, region, x, y, oldX, oldY, ret, prototype)
        [nextX, nextY, dir] = getNextCell(raster, oldX, oldY, x, y);
        next = raster(nextY, nextX);
        switch next
            case "hline"
                if(dir == "up" || dir == "down")
                    img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                end
            case "vline"
                if(dir == "left" || dir == "right")
                    img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                end
            case "point"
                ret = "end";
                return
            case "cornerLU"
                [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="left")
                    
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    end 
                 end
            case "cornerLO"
                 [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    end 
                 end
            case "cornerRU"
                [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    end 
                 end
            case "cornerRO"
                 [a, b, nextDir] = getNextCell(raster, x, y, nextX, nextY);
                 if(dir=="right")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="left")
                    if(nextDir=="right" || nextDir=="left")
                        ret = "error";
                        return;
                    elseif(nextDir=="up")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    elseif(nextDir=="down")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    end
                 elseif(dir=="up")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 1, nextX, nextY, region, prototype);
                    end 
                 elseif(dir=="down")
                    if(nextDir=="up" || nextDir=="down")
                        ret = "error";
                        return;
                    elseif(nextDir=="right")
                        img = rotate(img, imgs, 2, nextX, nextY, region, prototype);
                    elseif(nextDir=="left")
                        img = rotate(img, imgs, 3, nextX, nextY, region, prototype);
                    end 
                 end
            case "nothing"
                ret= "error";
        end
end

%Author: Michael Raimer - 11701255
function img = rotate(img, imgs, n, x, y, region, prototype)
    k = 6*(x-1)+y;
    thisBB = region{k};
    s = size(imgs{k});
    %if s(1) < s(2)
    %   a = s(1);
    %end
    a = s(2);
    imgs{k} = imgs{k}(1:a, 1:a);
    
    if prototype
        imgs{k} = rot90(imgs{k}, n);
    else
        imgs{k} = rot90(imgs{k}, n);
        % IMPLEMENT Gerhard
    end
    
    img(uint16(thisBB(2):thisBB(2)+a-1) , uint16(thisBB(1):thisBB(1)+a-1)) = imgs{k};
end

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