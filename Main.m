%Author: Michael Raimer - 11701255
function [rasterM, img, imgs, region] = Main(handles, img, debug, prototype)
    
    img = im2double(img);
    img = rgb2gray(img); 
    
    ma=max(max(img))
    val = ma*0.575
    if prototype
          img = imbinarize(img,val);
    else
          img = imbinarize(img,val);
          % IMPLEMENT Gerhard
          img = binarization(img, 0.55); 
    end
        
    imshow(img,'Parent',handles.axes1);
     
    s = size(img);
    if s(1) < s(2)
        if prototype
            img = rot90(img, 1);
        else
            % IMPLEMENT Gerhard:
            test = [1 2 3; 4 5 6;];
            img = rotation(test, 1);
        end
    end
    
    imshow(img,'Parent',handles.axes1);
    
    [imgs, region] = Crop(img, prototype);
    
    types = CellCheck(imgs, prototype);
    
    %raster = string(types(:));
    rasterM = [types{:}];
    try
        rasterM = reshape(rasterM, [6, 4]);
        if ~debug
            [resultImg, result] = GeneratePath(rasterM, img, imgs, region, 0, 0, 0, prototype);
            if strcmp(result,'end') 
               set(handles.text1, 'String', "Success, correct path found!");
               figure, imshow(resultImg);
            elseif strcmp(result,'error')
               set(handles.text1, 'String', "Error! There is no correct result!");
            end
            %set(handles.text1, 'String', result);
        end
    catch ME
        set(handles.text1, 'String', 'Error in Program!');
    end
end




