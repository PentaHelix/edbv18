%Author: Sarah Kuchler 11776811
function [img] = morphology(img)
    img = ~img;
    
    %structure elements with 8 neighbors
    %fill = fills holes; clean = deletes single pixels
    cleanElement = [0 0 0; 0 1 0; 0 0 0];
    fillElement = [1 1 1; 1 0 1; 1 1 1];
    
    img = compareElement(img,cleanElement,0);
    img = compareElement(img,fillElement,1);
end

%Author: Sarah Kuchler 11776811
function [imgNew] = compareElement(img,Element,value)
    imgNew = img;
    sz = size(imgNew);
    
    %compares the structure element with (same size) part of the picture
    %ignores the outermost pixels (starts at the pixel in the second row
    %and column)
    for i=2:sz(1)-1                                    
       for j=2:sz(2)-1                                 
           if isequal(imgNew(i-1:i+1,j-1:j+1),Element) 
              %Changes value of the pixel in the middle (hot spot) 
              imgNew(i,j) = value;                     
           end
       end
    end
end