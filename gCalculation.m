function [] = gCalculation(file,yCol)

    table = readtable(file);
    data = table2array(table);
    y=data(:,yCol);
    R=.0375; %%m
    r=.00175; %%m
    d=R-r; %%R-r
    frames=[];
    
    y=y(y~=0);
    for i = 2:length(y)-1

        if(y(i)<y(i+1) && y(i)<y(i-1) || y(i)>y(i+1) && y(i)>y(i-1))
            frames = [frames i];
        end
    end
    sum=0;
    for i=1:length(frames)-2
        periods(i)=frames(i+2)-frames(i);
        sum=sum+periods(i);
    end
    period=sum/length(periods);
    T=period./209.97; %%make seconds
    
    g=28*pi^2*d/(5*T^2);
    disp("g without damping");
    disp(g);
end