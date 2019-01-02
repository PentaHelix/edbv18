%Author: Gerhard Andreas Stog 00954038
function [binImg] = binarization(img, threshold)
%BINARIZATION Binarize Image by Thresholding

% Step 1: Mark every pixel >= threshold
img_overThreshold = logical(img(:,:,1) >= threshold);

% Step 2: Increase values on marked pixels to 1, every other to 0
binImg = img;
binImg(img_overThreshold) = 1;
binImg(not(img_overThreshold)) = 0;

%%

end

