%Author: Michael Raimer - 11701255
function type = CellCheck(img, prototype)
    for k=1:length(img)
       
        il = size(img{k});
        img{k} = img{k}(25:il(1)-25, 25:il(2)-25); 

        %Debug-Ausgabe
        %{ 
        figure
        subplot(3, 2, 1)
        imshow(img{k});
        %}

        if prototype
            img{k} = imcomplement(img{k});
            img{k} = bwmorph(img{k},'fill',Inf); % IMPLEMENT Sarah
            img{k} = bwmorph(img{k},'clean',Inf); % IMPLEMENT Sarah
        else
            % IMPLEMENT Sarah
        end

        if prototype
            a = radon(img{k}, 90); % IMPLEMENT Michael
            b = radon(img{k}, 0); % IMPLEMENT Michael
            c = radon(img{k}, 45); % IMPLEMENT Michael
            [a, b, c] = Projections(img{k});
        else
            %[a, b, c] = Projections(img{k});
            % IMPLEMENT Michael
        end
        
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
        
        %{%
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
        
        %{ 
            [v1 ,  h1,  d1,  a1] = imSignature(img{k});

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
        if  maxB/maxA > 2 % /*maxA < maxC && maxC < maxB &&*/
            type{k} = "vline";
        elseif maxA/maxB > 2 % maxB < maxC && maxC < maxA &&
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
        

