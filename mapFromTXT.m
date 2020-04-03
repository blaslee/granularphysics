function [] = mapFromTXT(x,y,xMax,yMax)
    radii=.5;
    h = animatedline('LineWidth',4,'Color','r');
    for k=1:length(x)
        xlim([0 xMax]);
        ylim([0 yMax]);
        center=[x(k),y(k)];
        addpoints(h,x(k),y(k));
        c=viscircles(center,radii);
        drawnow;
        delete(c);
        hold on;
    end
end


