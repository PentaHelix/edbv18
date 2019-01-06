%Author: Michael Raimer - 11701255
function img = LoadImage(handles)
    [filename,user_canceled] = imgetfile(); %open choose file dialog
    if ~user_canceled
        img = imread(filename); %read image
        imshow(img,'Parent',handles.axes1); %show img in gui
        %imshow(img);
    end
end