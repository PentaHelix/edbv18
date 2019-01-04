%Author: Michael Raimer - 11701255
function [rasterM, img, imgs, region] = Main(handles, img, debug, prototype)
    rasterM = [];
    imgs = [];
    region = [];
    img = im2double(img);
    img = rgb2gray(img); 
    s = size(img);
    
    % binarize image with 4 sections
    imgc{1} = img(1:round(s(1)/2), 1:round(s(2)/2));
    imgc{2} = img(round(s(1)/2):s(1), 1:round(s(2)/2));
    imgc{3} = img(1:round(s(1)/2), round(s(2)/2):s(2));
    imgc{4} = img(round(s(1)/2):s(1), round(s(2)/2):s(2));
    for i = 1:4
        %calc threshold value
        ma=max(max(imgc{i}));
        m = mean(mean(imgc{i}));
        val = ma*m;
        if ma > 0.9
            val = val*0.5;
        end
        if prototype
            imgc{i} = imbinarize(imgc{i},val);
        else
            imgc{i} = binarization(imgc{i}, val);  
            %imgc{i} = imbinarize(imgc{i},val);
        end
    end   
    a = cat(1, imgc{1}, imgc{2});
    b = cat(1, imgc{3}, imgc{4});
    img = cat (2, a, b);
     
    if s(1) < s(2)
        if prototype
            img = rot90(img, 1);
        else
            img = rotation(img, 1); % IMPLEMENT Gerhard
        end
    end
    
    imshow(img,'Parent',handles.axes1);
    try
        [imgs, region] = Crop(img, prototype);
    catch ME
        set(handles.text1, 'String', 'Error cropping image/raster recognition!');
        return;
    end
    
    try
        types = CellCheck(imgs, prototype);  
        %raster = string(types(:));
        rasterM = [types{:}];
        rasterM = reshape(rasterM, [6, 4]);
        rasterM
    catch
        set(handles.text1, 'String', 'Error in shape detection!');
        return;
    end
    
    try
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
        set(handles.text1, 'String', 'Error generating Path!');
        return;
    end
end




