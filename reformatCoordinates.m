function [] = reformatCoordinates()

    %% get folder with coordinates 
   
    directory = input('enter the folder with the ball coordinates ');

    Files=dir(directory);
    files={};
    count=1;
    
    for k = 1:length(Files)
        
        z=Files(k).name;
        
        if(z(1)~='C' || z(end)~='t')
            continue
        end
        
        files{count}=z;
        count=count+1;
        
    end
    
    %% get x and y data and put in master array for new file
    
    xAll = [];
    yAll = [];
    
    for i = 1:length(files)
    
        table = readtable(files{i});
        data = table2array(table);
        x{i}=data(:,1);
        y{i}=data(:,2);
        
        for j = 1:length(x{i})
            
            xAll=[xAll, x{i}(j)];
            yAll=[yAll, y{i}(j)];
            
        end
    
    end
    %% generate frame column
    
    frameAll=[];
    
    for i =  1:length(x)
        
        frame=[];
        
        for j = 1:length(x{i})
            
            frame = [frame, j-1];
            
        end
        
        frameAll = [frameAll, frame];
        
    end
    
    %% generate trajectory column
    trajectory = ones(1, length(frameAll)/length(x));
   
    %count=1;
 
%     for i = 1:length(frameAll)
%         
%         if(frameAll(i)==0)
%             
%             trajectory(i)=count;
%             count=count+1;
%             
%         end
%         
%     end

    trajectoryAll=[];

    for i = 1:length(x)
        
        trajectoryAll=[trajectoryAll,trajectory.*i];
        
    end


%% check lengths
    
    xAll=xAll(:);
    yAll=yAll(:);
    frameAll=frameAll(:);
    trajectoryAll=trajectoryAll(:);

    
    %% save file
    
    path=input('where would you like the file to be saved? ');
    
    disp(length(trajectoryAll));
    disp(length(xAll));
    disp(length(frameAll));
    disp(length(yAll));
    
    title={'TRAJECTORY','FRAME','X','Y'};
    fname=files{1}(1:8);
    fname=sprintf('%s %s', fname,'coordsALL.csv');
    csvwrite_with_headers(fname,[trajectoryAll,frameAll,xAll,yAll],title);
    movefile(fname,path);

end
    
    