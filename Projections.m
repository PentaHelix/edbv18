%Author: Michael Raimer - 11701255
function [v ,  h,  d]=Projections(img)
    [v, h] = hvSum(img); %horizotal and vertical
    d = diagSum(img); %diagonal

    % DEBUG
    %{ 
    figure
    subplot(2, 2, 1)
    plot (1:length(v), v, 'r-');
    subplot(2, 2, 2)
    plot (1:length(h), h, 'r-');
    subplot(2, 2, 3)
    plot (1:length(d), d, 'r-');
    %}
    
end

%Author: Michael Raimer - 11701255
function[v, h]=hvSum(M)
    h=sum(M, 1); %horizonral
    v = rotation( flipud (sum(M,  2) ), 1); %vertical
end

%Author: Michael Raimer - 11701255
function [dsum] = diagSum(img)

    cols = size(img,2); %columns
    rows  = size(img,1); %rows
    dsum = zeros(1, cols+rows); % init verctor with 0's
    
    %calc projections vom linken unteren dreieck
    for i=1:rows
        for j=i:rows
            if j-i+1 < cols
                dsum(i) = dsum(i) + img(j, j-i+1);
            end
        end
    end
    
    %calc projections vom rechten oberen dreieck
    dsum(1:rows) = flip(dsum(1:rows));
    for i=1:cols
        for j=i:cols
            if j < rows
                dsum(i+rows) = dsum(i+rows) + img(j, j-i+1);
            end
        end
    end
end