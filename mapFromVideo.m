function [x,y] = mapFromVideo(file)
    radii=.5;
    table = readtable(file);
    data = table2array(table);
    x=data(:,1);
    y=data(:,2);
    xMin=x(1);
    xMax=x(1);
    yMin=y(1);
    yMax=y(1);
    for i=1:length(x)
        if(x(i)<xMin)
            xMin=x(i);
        end
        if(x(i)>xMax)
            xMax=x(i);
        end
    end
    for i=1:length(y)
        if(y(i)<yMin)
            yMin=y(i);
        end
        if(y(i)>yMax)
            yMax=y(i);
        end
    end
    h = animatedline;
    for k=1:length(x)
        xlim([xMin-10 xMax+10]);
        ylim([yMin-10 yMax+10]);
        center=[x(k),y(k)];
        addpoints(h,x(k),y(k));
        c=viscircles(center,radii);
        drawnow;
        delete(c);
        hold all;
    end
end


