function [] = multiTrackFromVideo(file)
    radius=input('Enter the radius of the area of interest ');
    sensitivity=input('Enter the findCircle Sensitivity ');%%suggest .8
    edge=input('Enter the edge threshold value ');%% syggest .1
    numParticles=input("Enter the # of particles ");
    
    Rmin=8;
    Rmax=25;
    
    files={};
    files{1}=file;
    next=0;
    
    while(next==0)
        nextFile=input('Enter another file ' );
        if(nextFile=="done")
            next=1;
        end
        if(nextFile~="done")
            files=[files nextFile];
        end
    end
    
    for k=1:length(files)
        
        v=VideoReader(files{k});
        coordinates=cell(1,numParticles);


        for i = 1:1:v.NumFrames/20
            frame=rgb2gray(read(v, i));
            done=i/(v.NumFrames/20);
            disp(done);

            newFrameSize=size(frame); %%
            circle=[180, 240, radius]; %%
            [xx,yy]=ndgrid((1:newFrameSize(1))-circle(1),(1:newFrameSize(2))-circle(2));
            mask=uint8((xx.^2+yy.^2)<circle(3)^2);
            newFrame = uint8(zeros(size(frame)));
            newFrame(:,:,1) = frame(:,:,1).*mask;
            %newFrame(:,:,2) = frame(:,:,2).*mask;
            %newFrame(:,:,3) = frame(:,:,3).*mask;
            %imshow(newFrame); %%

            [centersDark, radiiDark]=imfindcircles(newFrame, [Rmin Rmax], 'ObjectPolarity', 'dark','Sensitivity',sensitivity,'EdgeThreshold',edge);
            viscircles(centersDark, radiiDark,'Color','b');
            %drawnow;

            for j = 1:numParticles
                if(i>1)
                    xOld=coordinates{j}(i-1,1);
                    yOld=coordinates{j}(i-1,2);
                    yNew=centersDark(:,2);
                    xNew=centersDark(:,1);
                    min=50;
                    for k = 1:numParticles
                        diff=abs(yNew(k)-yOld)+abs(xNew(k)-xOld);
                        if(diff<min)
                            min=diff;
                            a=centersDark(k,:);
                        end
                    end
                    coordinates{j}(i,:)=a;
                end
                if(i==1)
                    a=centersDark(j,:);
                    coordinates{j}(i,:)=a;
                end
            end
            clc;
        end
        clf;
        frame=read(v,1);
        imshow(frame);
        name=input('Enter a file name ');
        for i = 1:numParticles
            x=coordinates{i}(:,1);
            y=coordinates{i}(:,2);
            title={'X','Y'};
            fname = sprintf ( '%i %s', i, name);
            csvwrite_with_headers(fname,[x y],title);
            %mapFromTXT(x,y,newFrameSize(1),newFrameSize(2));
        end
end


