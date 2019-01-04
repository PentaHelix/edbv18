%Author: Gerhard Andreas Stog - 00954038
function [img] = rotation(img, A)
%ROTATION Rotates array 90 degree clockwise based on array dimensions

% Transposes the matrix (switches rows and columns)
img = img';

% % The y dimension of the array
rowLength = size(img,1);
% % The x dimension of the array
colLength = size(img,2);

% Uses fliplr to reverse order of columns for finding rotation
% img = fliplr(img);

% For every row
for y = 1:rowLength
    % Swap elements until you reach mid row element (rounded down)
    for x = 1:colLength/2
        % The index of the left element that needs to be swapped
        left = x;
        % The index of the right element that needs to be swapped
        right = colLength+1-x;
        % Temporarily store left element
        temp = img(y,x);
        % Store right element in left
        img(y,left) = img(y,right);
        % Store left element in right
        img(y,right) = temp;
    end
end 

end

