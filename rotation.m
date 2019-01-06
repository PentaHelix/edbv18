%Author: Gerhard Andreas Stog - 00954038
function [img] = rotation(img, numberOfRotations)
%ROTATION Rotates array 90 degree clockwise based on array dimensions

numberOfRotations = 4-numberOfRotations;

for i=1:numberOfRotations
    % TRANSPOSE the matrix (switches rows and columns)
    img = img';

    % % The y dimension of the array
    rowLength = size(img,1);
    % % The x dimension of the array
    colLength = size(img,2);

    % REVERSE order of columns for finding rotation
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
end