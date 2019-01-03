%Author: Sarah Kuchler 11776811
function [img] = morphology(img)
    img = ~img;
    cleanElement = [0 0 0; 0 1 0; 0 0 0];                   %structure element with 8 neighbors
    fillElement = [1 1 1;1 0 1;1 1 1];
    
    img = compareElement(img,cleanElement,0);
    img = compareElement(img,fillElement,1);
end

%Author: Sarah Kuchler 11776811
function [imgNew] = compareElement(img,Element,value)
    imgOld = img;
    imgNew = img;
    sz = size(imgOld);
    
    %while true                                             %do-while loop
        for i=2:sz(1)-1                                     %rows
            for j=2:sz(2)-1                                 %columns
                if isequal(imgOld(i-1:i+1,j-1:j+1),Element) %compares (same size) part of the picture with the structure element
                   imgNew(i,j) = value;                     %Changes value of the pixel in the middle 
                end
            end
        end
        %if ~isequal(imgOld,imgNew)                          %Checks if something has changed after comparing with the structure element
            %break                                           %if so there will be no further changes -> stop while loop
        %end
        %imgOld = imgNew;
    %end
end