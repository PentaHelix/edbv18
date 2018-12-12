%Author: Michael Raimer - 11701255
function [raster, img, imgs, region] = Main(handles, img, debug, prototype)
    % IMPLEMENT Zwischenschritte im GUI
    
    img = im2double(img);
    img = rgb2gray(img);
    
    if prototype
          img = imbinarize(img,0.55);  % IMPLEMENT Gerhard
    else
           % IMPLEMENT Gerhard: imbinarize
    end
        
     
    s = size(img);
    if s(1) < s(2)
        if prototype
            img = rot90(img, 1);  % IMPLEMENT Gerhard
        else
            % IMPLEMENT Gerhard: rotate
        end
    end
    
    imshow(img,'Parent',handles.axes1);
    
    if prototype
        [imgs, region] = PrototypeCrop(img);  % IMPLEMENT Yana & Jakob
    else
        % IMPLEMENT Yana & Jakob
    end
    
    types = CellCheck(imgs, prototype);
    
    raster = [types{:}];
    raster = reshape(raster, [6, 4]);
    if ~debug
        [resultImg, result] = GeneratePath(raster, img, imgs, region, 0, 0, 0, prototype);
        figure, imshow(resultImg);
        set(handles.text1, 'String', result);
    end
end




