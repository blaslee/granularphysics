function [] = gCalculationDamping()

    directory=input('enter a folder path');
    Files=dir(directory);
    files={};
    count=1;
    xCol=input('enter x column');
    yCol=input('enter y column');
    z=1;
    
    for k=4:length(Files)
        files{count}=(Files(k).name);
        count=count+1;
    end
    
    
    Damping=zeros([0 length(files)]);
    Frequency=zeros([0 length(files)]);
    gravitys=zeros([0 length(files)]);
    
    for j=1:length(files)
        
        table = readtable(files{j});
        data = table2array(table);
        X=data(:,xCol);
        Y=data(:,yCol);
        X=X.*(.000174);%%m
        Y=Y.*(.000174);%%m
        R=.0375; %%m
        r=.00175; %%m
        d=R-r; %%R-r
        frames=[];

        Y=Y(Y~=0);
        X=X(X~=0);
        for i = 2:length(Y)-1

            if(Y(i)<Y(i+1) && Y(i)<Y(i-1) || Y(i)>Y(i+1) && Y(i)>Y(i-1))
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

        avgDIST=(mean(X)^2+mean(Y)^2)^.5;
        DIST=(X.^2+Y.^2).^.5;


        for i=1:length(Y)
            k(i)=asin((DIST(i)-avgDIST)/R); %DIST(i)-avgDIST
            x(i)=i/209.97;
        end

        k=k(:);
        x=x(:);
        f=fit(x,k,'A*exp(-B*x)*cos(w*x+p)+C','StartPoint', [1, 1, 1, 1, 13] );
%         if(rem(j,3)==0)
%             figure(j/3);
%             scatter(x,k);
%             hold on;
%             plot(f);
%         end
       

        parameters=coeffvalues(f);
        w=parameters(5);
        B=parameters(2);
        Damping(j)=B;
        Frequency(j)=w;
        gravitys(j)=7*d*(w^2+B^2)/5;
        
        Betas=[];
        errorBetas=[];
        temp=[];
    end
        for i = 1 : length(Damping)
            if(rem(i,3)==0)
                Betas=[Betas mean(temp)];
                errorBetas=[errorBetas std(temp)];
                temp=[];
            else
                temp=[temp Damping(i)];
            end
        end
        Current=[0;.1;.2;.3;.4;.5;.6;.7;.8;.9;1;1.1;1.2];
        figure(length(files)+1);
        scatter(Current, Betas);
        hold on;
        errorbar(Current, Betas, errorBetas, errorBetas,'o');
        
        Betas=Betas(:);
        
        f=fit(Current,Betas,'(.0969+c*x^(k))/(1+a*x^(k))','StartPoint', [3, 3, 3]);
        disp(f);
        hold on;
        plot(f);
        hold on;
        
        u=zeros([0 length(Betas)]);
        for i=1:length(Betas)
            u(i)=f(Current(i))-Betas(i);
        end
        residuals=0;
        
        for i = 1:length(u)
            residuals=residuals+u(i);
        end
        disp(residuals);
        disp(mean(u.^2));
        
        title('AC Current vs Damping');
        xlabel('Current (A)');
        ylabel('Damping');
        
%         disp("g with damping");
%         g=7*d*(w^2+B^2)/5;
%         disp(g);
%         disp('Damping')
%         disp(B);
    Damping=Damping(:);
    header={'Beta'};
    csvwrite_with_headers('info2.txt',[Damping],header);
    open('info2.txt');
    end