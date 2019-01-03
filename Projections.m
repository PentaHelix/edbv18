%Author: Michael Raimer - 11701255
function [v ,  h,  d]=Projections(img)
    [v, h] = hvSum(img);
    d = diagSum(img);

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
    h=sum(M, 1); 
    v = rot90( flipud (sum(M,  2) )) ; 
    d = rot90( flipud (sum(M,  2) )) ;
end

%Author: Michael Raimer - 11701255
function [dsum] = diagSum(img)

    cols = size(img,2); %columns
    rows  = size(img,1); %rows
    dsum = zeros(1, cols+rows);
    for i=1:rows
        for j=i:rows
            if j-i+1 < cols
                dsum(i) = dsum(i) + img(j, j-i+1);
            end
        end
    end
    dsum(1:rows) = flip(dsum(1:rows));
    for i=1:cols
        for j=i:cols
            if j < rows
                %clc;
                %[i+rows, j, j-i+1, size(dsum), size(img)]
                dsum(i+rows) = dsum(i+rows) + img(j, j-i+1);
            end
        end
    end
end