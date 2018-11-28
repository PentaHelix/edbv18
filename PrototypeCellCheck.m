%Author: Michael Raimer - 11701255
function type = PrototypeCellCheck(img)
    for k=1:length(img)
        [corner, line, point] = loadReference();
        corner = rgb2gray(corner);
        corner = imbinarize(corner,0.75); % IMPLEMENT Gerhard
        
        il = size(img{k});
        img{k} = img{k}(25:il(1)-25, 25:il(2)-25); 

        %Debug-Ausgabe
        %{ 
        figure
        subplot(3, 2, 1)
        imshow(img{k});
        %}

        img{k} = imcomplement(img{k});
        img{k} = bwmorph(img{k},'fill',Inf); % IMPLEMENT Sarah
        img{k} = bwmorph(img{k},'clean',Inf); % IMPLEMENT Sarah
        
        %img{k} = bwmorph(img{k},'open',Inf); % IMPLEMENT Sarah
        %img{k} = bwmorph(img{k},'majority',Inf); % IMPLEMENT Sarah
        corner1 = imcomplement(corner);
        corner1 = bwmorph(corner1,'clean',Inf);
        corner1 = bwmorph(corner1,'fill',Inf); 
        %corner1 = bwmorph(corner1,'open',Inf); 
        %corner1 = bwmorph(corner1,'majority',Inf);

        a = radon(img{k}, 90); % IMPLEMENT Michael
        b = radon(img{k}, 0); % IMPLEMENT Michael
        c = radon(img{k}, 45); % IMPLEMENT Michael
        
        a(a==0) = [];
        b(b==0) = [];
        c(c==0) = [];
        if isempty(a)
            a = 0;
        end
        if isempty(b)
            b = 0;
        end
        if isempty(c)
            c = 0;
        end
        %Debug-Ausgabe
        %{ 
        subplot(4, 2, 2)
        imshow(img{k});
        subplot(4, 2, 3)
        imshow(corner);
        subplot(4, 2, 4)
        plot(1:length(c), c)
        subplot(4, 2, 5)
        plot(1:length(a), a)
        subplot(4, 2, 6)
        plot(1:length(b), b)
        %}
        
        %{ 
            [v1 ,  h1,  d1,  a1] = imSignature(img{k});
            %[v2 ,  h2,  d2,  a2] = imSignature(corner);

            %[Vv, Kv] = corrCalc(v1,  v2);
            %[Vh, Kh] = corrCalc(h1,  h2);
            %[Vd, Kd] = corrCalc(d1,  d2);
            %[Va, Ka] = corrCalc(a1 ,  a2);

            figure
            subplot(4, 2, 1)
            plot (1:length(v1), v1, 'r-');
            subplot(4, 2, 2)
            plot (1:length(h1), h1, 'r-');
            subplot(4, 2, 3)
            plot (1:length(d1), d1, 'r-');
            subplot(4, 2, 4)
            plot (1:length(a1), a1, 'r-');
            subplot(4, 2, 5)
            imshow(corner)
            subplot(4, 2, 6)
            imshow(img{k})

            %%%
            %subplot(4, 2, 7)
            %plot(1:length(verticalProfile), verticalProfile,'r-', 1:length(verticalProfileC), verticalProfileC)
            %subplot(4, 2, 8)
            %plot(1:length(a), a,'r-', 1:length(b), b)
            %title(sprintf('maxV = %f',Vv))
        
        %}
        
        
        [maxA, indexA] = max(a);
        [maxB, indexB] = max(b);
        [maxC, indexC] = max(c);
        type{k} = "nothing";
        leftA=0;
        rightA=0;
        rightB=0;
        leftB=0;
        sa = skewness(a);
        sb = skewness(b);
        %if maxC > maxA && maxC > maxB
        %    type{k} = "point";
        %if (maxC/maxA >= 0.8 && maxC/maxA <= 1) || (maxA/maxC >= 0.8 && maxA/maxC <= 1)|| maxB/maxA >= 3
        if maxA < maxC && maxC < maxB && maxB/maxA > 2
            type{k} = "vline";
        elseif maxB < maxC && maxC < maxA && maxA/maxB > 2
            type{k} = "hline";
        elseif sa > 0 && sb > 0 %maxA > 60 && maxB > 60 
            leftA = sum(a(1:indexA-20));
            rightA = sum(a(indexA+20:length(a)));
            leftB = sum(b(1:indexB-20));
            rightB = sum(b(indexB+20:length(b))); 
            if leftA < rightA
               if leftB < rightB
                   type{k}="cornerLU";
               else
                   type{k}="cornerRU";
               end
            else
               if leftB < rightB
                   type{k}="cornerLO";
               else
                   type{k}="cornerRO";
               end
            end
        elseif sa < 0 && sb < 0 %maxA > 30 && maxB > 30 
            type{k} = "point";
        end
        
        %Debug-Ausgabe
        %{ 
        clc;
        %maxA
        %maxB
        %maxC
        [maxA maxB maxC]
        [leftA rightA]
        [leftB rightB]
        skewness(a)
        skewness(b)
        type{k}
        
        %}
    end 
    
end

%Author: Michael Raimer - 11701255
function [corner, line, point] = loadReference
    corner = imread('corner.png');
    line = imread('line.png');
    point = imread('point.png');
end


function [v,h,d,a]=imSignature(M)
    h=sum(M, 1) / size(M, 1);
    v = rot90( flipud (sum(M,  2) /  size (M,  1))) ;
    d = diagSumCalc(M) ;
    a = diagSumCalc(M,'a');
end


function [dsum] = diagSumCalc(M,  a)
    if nargin == 2 && ~strcmp(a,'d')
        if strcmp(a ,'a')
            M = fliplr(M);
        else
            error('Error :  second  parameter  should  be a or d');
        end
    end
    N=size(M,2);
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
function [res]=myradon(f)
    [N M]=size(f);
    %Centeroftheimage
    m=round(M/2);
    n=round(N/2);
    %Thetotalnumberofrho’sisthenumberofpixelsonthediagonal,since
    %thisisthelargeststraightlineontheimagewhenrotating
    rhomax=ceil(sqrt(M^2+N^2));
    rc=round(rhomax/2);
    mt=max(1);
    %Preallocatethematrixusedtostoretheresult
    %add1tobesure,couldalsobesubtractedwhencheckingbounds

    %res=cast(zeros(rhomax+1,mt),'double');
    res=zeros(rhomax+1,mt);
    tic
    %res = zeros(10000, 10000);
    %for t=1:45
    t=0;
        %below45degrees,useyasvariable
        costheta=cos(t*pi/180);
        sintheta=sin(t*pi/180);
        a=-costheta/sintheta;
        %y=ax+b
        for r=1:rhomax
            rho=r-rc;
            b=rho/sintheta;
            %y=ax+b
            ymax=min(round(-a*m+b),n-1);
            ymin=max(round(a*m+b),-n);
            for y=ymin:ymax-1
                x=(y-b)/a;
                if isnan(x)
                    x=0;
                end
                xfloor=floor(x);

                %Theintegerpartofx
                xup=x-xfloor;
                %Thedecimalsofx
                xlow=1-xup;
                %Whatitsays
                x=xfloor;
                x=max(x,-m);
                x=min(x,m-2);
                res(rhomax-r+1,mt-t)=res(rhomax-r+1,mt-t)+xlow*f(y+n+1,x+m+1);
                res(rhomax-r+1,mt-t)=res(rhomax-r+1,mt-t)+xup*f(y+n+1,x+m+2);
            end
        end
    %end

    %{
    %for t=46:90
    t=90;
        costheta=cos(t*pi/180);
        sintheta=sin(t*pi/180);
        a=-costheta/sintheta;
        %y=ax+b

        for r=1:rhomax
            rho=r-rc;
            b=rho/sintheta;
            %y=ax+b
            xmax=min(round((-n-b)/a),m-1);
            xmin=max(round((n-b)/a),-m);
            for x=xmin:xmax-1
                y=a*x+b;
                yfloor=floor(y);
                yup=y-yfloor;
                ylow=1-yup;
                y=yfloor;
                y=max(y,-n);
                y=min(y,n-2);
                res(rhomax-r+1,mt-t+1)=res(rhomax-r+1,mt-t+1)+ylow*f(y+n+1,x+m+1);
                res(rhomax-r+1,mt-t+1)=res(rhomax-r+1,mt-t+1)+yup*f(y+n+1,x+m+1);
            end
        end
    %end
%}
    %{
    for t=91:135
        costheta=cos(t*pi/180);
        sintheta=sin(t*pi/180);
        a=-costheta/sintheta;
        %y=ax+b
        for r=1:rhomax
            rho=r-rc;
            b=rho/sintheta;
            %y=ax+b
            xmax=min(round((n-b)/a),m-1);
            xmin=max(round((-n-b)/a),-m);
            for x=xmin:xmax
                y=a*x+b;
                yfloor=floor(y);
                yup=y-yfloor;
                ylow=1-yup;
                y=yfloor;
                y=max(y,-n);
                y=min(y,n-2);
                res(rhomax-r+1,mt-t)=res(rhomax-r+1,mt-t)+ylow*f(y+n+1,x+m+1);
                res(rhomax-r+1,mt-t)=res(rhomax-r+1,mt-t)+yup*f(y+n+2,x+m+1);
            end
        end
    end

    for t=136:179
        %above135degrees,useyasvariable
        costheta=cos(t*pi/180);
        sintheta=sin(t*pi/180);
        a=-costheta/sintheta;
        %y=ax+b
        for r=1:rhomax
            rho=r-rc;
            b=rho/sintheta;
            %y=ax+b
            ymax=min(round(a*m+b),n-1);
            ymin=max(round(-a*m+b),-n);
            for y=ymin:ymax
                x=(y-b)/a;
                xfloor=floor(x);
                xup=x-xfloor;
                xlow=1-xup;
                x=xfloor;
                x=max(x,-m);
                x=min(x,m-2);
                res(rhomax-r+1,mt-t)=res(rhomax-r+1,mt-t)+xlow*f(y+n+1,x+m+1);
                res(rhomax-r+1,mt-t)=res(rhomax-r+1,mt-t)+xup*f(y+n+1,x+m+2);
            end
        end
    end

    for t=180
        %thesum-lineisvertical
        rhooffset=round((rhomax-M)/2);
        for x=1:M
            %cannotuserasxinbothresandfsincetheyarenotthesamesize
            r=x+rhooffset;
            r=rhomax-r+1;
            for y=1:N
                res(r,t)=res(r,t)+f(y,x);
            end
        end
    end
    %}

    toc
    figure, plot(1:length(res), res)
    %rhoaxis=(1:rhomax+1)-rc;
    %figure
    %imagesc(1:180,rhoaxis,res);
    %colormap(hot),colorbar  

end
%}       
        
        

