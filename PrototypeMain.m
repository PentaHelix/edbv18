%Author: Michael Raimer - 11701255
function [raster, img, imgs, region] = PrototypeMain(handles, img, debug)
    % IMPLEMENT Zwischenschritte im GUI
    
    img = im2double(img);
    img = rgb2gray(img);
    img = imbinarize(img,0.55);  % IMPLEMENT Gerhard
    
    s = size(img);
    if s(1) < s(2)
       img = rot90(img, 1);  % IMPLEMENT Gerhard
    end
    
    imshow(img,'Parent',handles.axes1);
    [imgs, region] = PrototypeCrop(img);
    types = PrototypeCellCheck(imgs);
    
    raster = [types{:}];
    raster = reshape(raster, [6, 4]);
    if ~debug
        [resultImg, result] = PrototypeGeneratePath(raster, img, imgs, region, 0, 0, 0);
        figure, imshow(resultImg);
        set(handles.text1, 'String', result);
    end
end

%{
    s = size(thisImage{k});
    if s(1) < s(2)
       a = s(1);
    end
    a = s(2);
    thisImage{k} = thisImage{k}(1:a, 1:a);
    %figure, imshow(thisImage{k});
    thisImage{k} = rot90(thisImage{k}, 1);
    %figure, imshow(thisImage{k});
    img(uint16(thisBB(2):thisBB(2)+a-1) , uint16(thisBB(1):thisBB(1)+a-1)) = thisImage{k};
    
%}

%********************
%{
function [v,h,d,a]=imSignature(M)
    h=sum(M, 1) / size(M, 1);
    v = rot90( flipud (sum(M,  2) /  size (M,  1))) ;
    d = diagSumCalc(M) ;
    a = diagSumCalc(M,'a');
end

    % get projections with radon!
    %verticalProfile = sum(img, 2);
    %horizontalProfile = sum(img, 1);
    %verticalProfileC = sum(corner, 2);
    %horizontalProfileC = sum(corner, 1);
    %a = radon(img, 90);
    %b = radon(corner, 90);


function [dsum] = diagSumCalc(M,  a)
    if nargin == 2 && ~strcmp(a,'d')
        if strcmp(a ,'a')
            M = fliplr(M);
        else
            error('Error :  second  parameter  should  be a or d');
        end
    end
    N=size(M,1);
    M = double(M) ;
    dsum = zeros (1, 2*N-1);
    divider = [1:N N-1:-1:1];
    M_= M(:);

    for i=1:N+1
        tmp = M_(i:N+1:end);
        if(i<=N)
            dsum(N+1-i) = dsum(N+1-i) + sum(tmp(1:N+1-i));
        end
        if(i>2)
            dsum(2*N+2-i) = dsum(2*N+2-i) + sum(tmp(N+2-i:end));
        end
    end
    dsum = dsum  ./  divider;
end

function [V, K] = corrCalc(x,  y)
    if (length(x)>length(y))
        tmp = x ;
        x=y;
        y=tmp;
    end
    M=length(y)-length(x) ;
    s=zeros(M, 1);
    xavg = mean(x) ;
    for i = 1: length(s)
        s(i) = 0;
        divider = 0;
        yavg = mean(y( i : i-1+length(x)));
        for j=1:length(x)
            s(i) = s(i) + ((x(j)-xavg)*(y(i + j-1)-yavg) ) ;
            divider = s(i) + (((x(j)-xavg) )^2*((y(i + j-1)-yavg) )^2) ;
        end
        s(i) = s(i) / sqrt(divider);
    end
    [V,K]=max(s) ;
end


    %{
    [v1 ,  h1,  d1,  a1] = imSignature(img') ;
    [v2 ,  h2,  d2,  a2] = imSignature(corner) ;
    
    [Vv, Kv] = corrCalc(v1,  v2);
    [Vh, Kh] = corrCalc(h1,  h2);
    [Vd, Kd] = corrCalc(d1,  d2);
    [Va, Ka] = corrCalc(a1 ,  a2);
    
    figure
    plot (1:length(v1), v1, 'r-', Kv:length(v2)-1+Kv, v2);
    subplot(4, 2, 2)
    plot (1:length(h1), h1, 'r-', Kh:length(h2)-1+Kh, h2);
    subplot(4, 2, 3)
    plot (1:length(d1), d1, 'r-', Kd:length(d2)-1+Kd, d2);
    subplot(4, 2, 4)
    plot (1:length(a1), a1, 'r-', Ka:length(a2)-1+Ka, a2);
    subplot(4, 2, 5)
    imshow(corner)
    subplot(4, 2, 6)
    imshow(img)
    
    %%%
    %subplot(4, 2, 7)
    %plot(1:length(verticalProfile), verticalProfile,'r-', 1:length(verticalProfileC), verticalProfileC)
    %subplot(4, 2, 8)
    %plot(1:length(a), a,'r-', 1:length(b), b)
    
    title(sprintf('maxV = %f',Vv))
    %}
%}



