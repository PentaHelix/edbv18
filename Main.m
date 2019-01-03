%Author: Michael Raimer - 11701255
function [rasterM, img, imgs, region] = Main(handles, img, debug, prototype)
    
    img = im2double(img);
    img = rgb2gray(img);
    
    %figure, imshow(imbinarize(img,0.55));
    %figure, imshow(binarization(img, 0.55));
    %a = imbinarize(img,0.55)-binarization(img, 0.55);
    %b = binarization(img, 0.55)-imbinarize(img,0.55);
    %figure, imshow(a);   
    %figure, imshow(b);  
    
    if prototype
          img = imbinarize(img,0.55);
    else
          img = imbinarize(img,0.55);
          %img = binarization(img, 0.55); % IMPLEMENT Gerhard
    end
        
     
    s = size(img);
    if s(1) < s(2)
        if prototype
            img = rot90(img, 1);
        else
            img = rot90(img, 1);
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




