%Author: Michael Raimer - 11701255
function [rasterM, img, imgs, region] = Main(handles, img, debug, prototype)
    
    img = im2double(img);
    img = rgb2gray(img);
    
    if prototype
          img = imbinarize(img,0.55);
    else
          img = binarization(img, 0.2); % IMPLEMENT Gerhard
    end
        
     
    s = size(img);
    if s(1) < s(2)
        if prototype
            img = rot90(img, 1);
        else
            % IMPLEMENT Gerhard: rotate
        end
    end
    
    imshow(img,'Parent',handles.axes1);
    
    if prototype
        [imgs, region] = PrototypeCrop(img);
    else
        [imgs, region] = Crop(img); %IMPLEMENT Yana & Jakob
    end
    
    types = CellCheck(imgs, prototype);
    
    %raster = string(types(:));
    rasterM = [types{:}];
    try
        rasterM = reshape(rasterM, [6, 4]);
      
        if ~debug
            [resultImg, result] = GeneratePath(rasterM, img, imgs, region, 0, 0, 0, prototype);
            figure, imshow(resultImg);
            set(handles.text1, 'String', result);
        end
    catch ME
        %causeException = MException('MATLAB:myCode:dimensions','asdf');
        %ME = addCause(ME,causeException);
        set(handles.text1, 'String', 'ERROR!');
    end
end




