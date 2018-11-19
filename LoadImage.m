%Author: Michael Raimer - 11701255
function img = LoadImage(handles)
    [filename,user_canceled] = imgetfile();
    if ~user_canceled
        img = imread(filename);
        imshow(img,'Parent',handles.axes1);
        %imshow(img);
    end
end