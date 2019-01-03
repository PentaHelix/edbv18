%Author: Gerhard Andreas Stog - 00954038
function [img] = rotation(img, A)
%ROTATION Rotates array 90 degree clockwise based on array dimensions

% % The y dimension of the array
% rowLength = size(img,1);
% % The x dimension of the array
% colLength = size(img,2);

% Transposes the matrix (switches rows and columns)
img = img';

% Uses fliplr to reverse order of columns for finding rotation
img = fliplr(img);

end

