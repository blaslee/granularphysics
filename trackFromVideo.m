function [] = trackFromVideo()
    
    next=input('enter 1 for file, 0 for folder');
    
    if(next==0)

        directory=input('enter a folder path');
        Files=dir(directory);
        files={};
        names={};
        namesEnd=input('enter file name ending');
        count=1;
        for k=4:length(Files)
            files{count}=(Files(k).name);
            Files(k).name=Files(k).name(1:end-4);
            names{count}=append(Files(k).name,namesEnd);
            count=count+1;
        end
    end

    if(next==1)
        next=0;
        files={};
        names={};

        while(next==0)
            nextFile=input('Enter another file ' );
            if(nextFile=="done")
                next=1;
            end
            if(nextFile~="done")
                nextName=input('Enter the coordinates text file name ');
                files=[files nextFile];
                names=[names nextName];
            end
        end
    end
    
    radii=zeros([0 length(files)]);
    percent=zeros([0 length(files)]);
    deviation=zeros([0 length(files)]);
    
%     radius=input('Enter the radius of the area of interest ');
%     sensitivity=input('Enter the findCircle Sensitivity '); %%suggested .8
%     edge=input('Enter the edge threshold value '); %%suggested .1
% %     direction=input("Which axis have oscillations? ");
    radius=145;
    sensitivity=.8;
    edge=.1;
    
    for j=1:length(files)

        v=VideoReader(files{j});
        
        Rmin=8;
        Rmax=25;
        h = animatedline;
        
        x=zeros([0 v.NumFrames]);
        y=zeros([0 v.NumFrames]);
        r=zeros([0 v.NumFrames]);
        
        for i = 1:1:v.NumFrames
            frame=rgb2gray(read(v, i));
            done=i/(v.NumFrames);
            disp(done);
            disp(files{j});
            
            newFrameSize=size(frame); %%
            circle=[180, 240, radius]; %%
            [xx,yy]=ndgrid((1:newFrameSize(1))-circle(1),(1:newFrameSize(2))-circle(2));
            mask=uint8((xx.^2+yy.^2)<circle(3)^2);
            newFrame = uint8(zeros(size(frame)));
            newFrame(:,:,1) = frame(:,:,1).*mask;
            %newFrame(:,:,:)=255-newFrame(:,:,:);
            %imshow(newFrame); %%

            [centersDark, radiiDark]=imfindcircles(newFrame, [Rmin Rmax], 'ObjectPolarity', 'dark','Sensitivity',sensitivity,'EdgeThreshold',edge);
            viscircles(centersDark, radiiDark,'Color','b');
            %drawnow;
            clc;
            if(i>1 && length(centersDark)==2)
                x(i)=centersDark(1);
                y(i)=centersDark(2);
                r(i)=radiiDark;
            end
            
        end
        
        
        r = r(r~=0);
        sum=0;
        for i = 1:length(r)
            sum=sum+r(i);
        end
        average=sum/length(r);
        sd=std(r);
        radii(j)=average;
        deviation(j)=sd;
        
%         disp('radius average and sd')
%         disp(average);
%         disp(sd);
%         disp('percent found')
%         disp(length(r)/(v.NumFrames));
        percent(j)=length(r)/(v.NumFrames);
        
        x=x(:);
        x=x(x~=0);
        y=y(:);
        y=y(y~=0);
        title={'X','Y'};
        csvwrite_with_headers(names{j},[x y],title);
        open(names{j});
        close all;
        %clf;
        %mapFromTXT(x,y,newFrameSize(1),newFrameSize(2));

%         if(direction=='x')
%             gCalculation(names{j},1);
%             gCalculationDamping(names{j},2,1,j);
%         end
%         if(direction=='y')
%             gCalculation(names{j},2);
%             gCalculationDamping(names{j},1,2,j);
%         end
        
        
    end
    radii=radii(:);
    deviation=deviation(:);
    percent=percent(:);
    title={'radius','std','percent found'};
    csvwrite_with_headers('info.txt',[radii, deviation, percent],title);
    open('info.txt');
end


