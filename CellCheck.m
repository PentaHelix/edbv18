%Author: Michael Raimer - 11701255
function type = CellCheck(img, prototype)
    % recognize all shapes
    for k=1:length(img)
       
        il = size(img{k});
        img{k} = img{k}(50:il(1)-50, 50:il(2)-50); %cut of borders

        %Debug-Ausgabe
        %{
        figure
        subplot(3, 2, 1)
        imshow(img{k});
        %}

        % perform morphological operations on image
        if prototype
            img{k} = imcomplement(img{k});
            img{k} = bwmorph(img{k},'fill',Inf);
            img{k} = bwmorph(img{k},'clean',Inf); 
        else
            img{k} = morphology(img{k}); % IMPLEMENT Sarah
            %img{k} = imcomplement(img{k}); 
        end

        % calculate projections of image
        if prototype
            a = radon(img{k}, 90); 
            b = radon(img{k}, 0); 
            c = radon(img{k}, 45);
        else
            [a, b, c] = Projections(img{k}); % IMPLEMENT Michael
        end
        
        % remove 0's from projection
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
        subplot(4, 2, 4)
        plot(1:length(c), c)
        subplot(4, 2, 5)
        plot(1:length(a), a)
        subplot(4, 2, 6)
        plot(1:length(b), b)
        
        %{ %
        d(d==0) = [];
        e(e==0) = [];
        f(f==0) = [];
        if isempty(d)
            d = 0;
        end
        if isempty(e)
            e = 0;
        end
        if isempty(f)
            f = 0;
        end
        figure
        subplot(4, 2, 1)
        plot (1:length(d), d, 'r-');
        subplot(4, 2, 2)
        plot (1:length(e), e, 'r-');
        subplot(4, 2, 3)
        plot (1:length(f), f, 'r-');
        subplot(4, 2, 5)
        imshow(img{k})
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
        
        if maxA > 30 || maxB > 30 || maxC > 30 %check if cell is relevant
            if  maxB/maxA > 2 %vline
                type{k} = "vline";
            elseif maxA/maxB > 2 %hline
                type{k} = "hline";
            elseif sa > 0 && sb > 0 %corner
                leftA = sum(a(1:indexA-20));
                rightA = sum(a(indexA+20:length(a)));
                leftB = sum(b(1:indexB-20));
                rightB = sum(b(indexB+20:length(b))); 
                if leftA < rightA
                   if leftB < rightB %cornerLU
                       type{k}="cornerLU";
                   else %cornerRU
                       type{k}="cornerRU";
                   end
                else
                   if leftB < rightB %cornerLO
                       type{k}="cornerLO";
                   else %cornerRO
                       type{k}="cornerRO";
                   end
                end
            elseif sa < 0 && sb < 0 %point
                type{k} = "point";
            end
        end
        
        %Debug-Ausgabe
        %{ 
        %clc;
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