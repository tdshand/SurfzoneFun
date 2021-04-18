function    [thisFrame,stack,AvImage,binarybreakcount2,cc] = TimestackBinaryEngine(file,fontSize,folder,ROI,Type,column,row,binarythresh,contourlevel,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN)

% Engine for Cumulative Breaking and Timestack as part of SurfZoneFun. 
% Run via SurfZoneFun by Tom Shand & Pete Quilter 2021

%Inputs
file
fontSize
folder
ROI
Type
column
row
binarythresh
contourlevel
startframe
endframe
interval
makevid
vFrameRate
playbackinterval
SaveYN

% Frame extraction adapted from Extractmovieframes.m by Jagabandhu Mallik 
try
    movieFullFileName = fullfile(folder, file);
    
	%Read video
        videoObject = VideoReader(movieFullFileName)
        
        if startframe>endframe
            g = msgbox({'Startframe > Endframe';'Starting from 1'}, 'Oops','error');
            startframe = 1;
        end
        
        % Determine how many frames there are.
        if endframe<videoObject.NumberOfFrames
        length=endframe-startframe; %end frame
        numberOfFrames = length;
        else
        endframe = videoObject.NumberOfFrames;    
        length=endframe-startframe; %end frame
        numberOfFrames = length;
        end

        vidHeight = videoObject.Height;
        vidWidth = videoObject.Width;
        fps=videoObject.Framerate./interval;
        
         %checking for a few errors and reverting to defaults
        if binarythresh>1||binarythresh<0
        g = msgbox({'Invalid binary threshold';'Reverting to default = 0.8'}, 'Oops','error');
        binarythresh=0.8;
        end
        
        if contourlevel>1||contourlevel<0
        h = msgbox({'Invalid contour level';'Reverting to default = 0.1'}, 'Oops','error');
        contourlevel=0.1;
        end
        
        
    %Set up timestack matrix
        if Type == 1  %stack a column
       
        if column>vidWidth
        o = msgbox({'Invalid column';'Reverting to mid point'}, 'Oops','error');
        column=vidWidth./2;
        end
        
        x = [column column];
        y = [0 vidHeight];

        stack=ones([y(end)-y(1)],floor(numberOfFrames./interval),3);
        stack=stack.*255;
        graystack=ones([y(end)-y(1)],floor(numberOfFrames./interval),1);
        graystack=graystack.*255;

        elseif Type == 2 %stack a row
            
        if row>vidHeight
        p = msgbox({'Invalid row';'Reverting to mid point'}, 'Oops','error');
        row=vidHeight./2;
        end
        
        x = [0 vidWidth];
        y = [row row];

        stack=ones([x(end)-x(1)],floor(numberOfFrames./interval),3);
        stack=stack.*255;
        graystack=ones([x(end)-x(1)],floor(numberOfFrames./interval),1);
        graystack=graystack.*255;

        elseif Type == 3 %pick the points
        figure(1)
        testFrame = read(videoObject, 1);
        imshow(testFrame)
        title('choose the offshore then nearshore point of your timestack');
        [xi,yi] = getpts
        close 1

        x = floor(xi)';
        y = floor(yi)';
        tempfile=fullfile(folder, 'stackxy.mat');
        save(tempfile,'x','y')
        a=improfile(testFrame,x,y);
        sza=size(a);

        stack=ones(sza(1)-1,floor(numberOfFrames./interval),3);
        stack=stack.*255;
        graystack=ones(sza(1)-1,floor(numberOfFrames./interval),1);
        graystack=graystack.*255;

        else %if points already specified as x, y
        tempfile=fullfile(folder, 'stackxy.mat');
        load(tempfile);
        testFrame = read(videoObject, 1);    
        a=improfile(testFrame,x,y);
        sza=size(a);

        stack=ones(sza(1)-1,floor(numberOfFrames./interval),3);
        stack=stack.*255;
        graystack=ones(sza(1)-1,floor(numberOfFrames./interval),1);
        graystack=graystack.*255;
        
        end
    
    %Set up ROI for cumulative breaking
        if ROI == 2
        figure(1)
        testFrame = read(videoObject, 1);
        imshow(testFrame)
        title('set your region of interest');
        ROI2 = drawpolygon;
        mask = poly2mask(ROI2.Position(:,1),ROI2.Position(:,2),vidHeight,vidWidth);
        tempfile=fullfile(folder, 'mask.mat');
        save(tempfile,'mask')
        close 1 
        elseif ROI == 3
        tempfile=fullfile(folder, 'mask.mat');
        load(tempfile);
        else
        end

	numberOfFramesWritten = 0;
	
    % Prepare a figure to show the images 
	fig= figure('Position', [10 10 1000 1000])
    sgcaption = char(strcat("SURF ZONE FUN using ",file));
    sgtitle(sgcaption, 'FontSize', fontSize)
	% Loop through the movie, writing all frames out.
	% Each frame will be in a separate file with unique name.
	
    binarybreakcount=zeros(videoObject.Height,videoObject.Width);
    
    framecount=0;
    
    %do the analysis frame by frame
	for frame = startframe : interval : endframe
		% Extract the frame from the movie structure.
		thisFrame = read(videoObject, frame);
		framecount=framecount+1;
		% Display it
		hImage(1) = subplot(3, 2, 1);
		image(thisFrame);
        hold on
        plot(x,y,'-r')
        hold off
		caption = sprintf('Frame %4d of %d.', framecount.*interval, numberOfFrames);
		title(caption, 'FontSize', fontSize);       
        drawnow; % Force it to refresh the window.
		
		% gray image.
		grayImage = rgb2gray(thisFrame);
		
		% Extract stack profiles, add to matrix and display it
		a=improfile(thisFrame,x,y);
        sizea=size(a);
      
        stack(:,framecount,:)=a(2:end,:,:);
        %and from grayscale image
        b=improfile(grayImage,x,y);
        graystack(:,framecount,:)=b(2:end,:,:);
        
        stack8Bit = uint8(255 * mat2gray(stack));
		
        hImage(5) = subplot(3, 2, 5:6);
		image(stack8Bit);
        %drawnow
        
		% Put title back because plot() erases the existing title.
		caption = sprintf('Timestack at %f fps.', round(fps));
		title(caption, 'FontSize', fontSize);
        
        %title('Timestack', 'FontSize', fontSize);
	%	if frame == 1
			xlabel('Frame Number');
			ylabel('distance offshore');
			% Get size data later for preallocation if we read
			% the movie back in from disk.
			[rows, columns, numberOfColorChannels] = size(thisFrame);
	%	end
		
		% Increment frame count (should eventually = numberOfFrames
		% unless an error happens).
		numberOfFramesWritten = numberOfFramesWritten + 1;
		
        %add to average image and display it
		if frame == startframe
            AvImage = thisFrame;
		else
			% add each image to the average           
           AvImage = AvImage.*((framecount-1)./framecount) + thisFrame./framecount;
            
        end
        
        hImage(2) = subplot(3, 2, 2);
		image(AvImage);        
		title('Average Image', 'FontSize', fontSize);

        %Create binary image to show breaking areas and plot it over the frame
		binaryImage = im2bw( grayImage, binarythresh); 
		
         if ROI == 2
        binaryImage =binaryImage .*mask;
         elseif ROI == 3
        binaryImage =binaryImage .*mask;
         else
         end
       
        hImage(3) = subplot(3, 2, 3);
        image(thisFrame);
        im=imagesc('CData',binaryImage);
        set(im,'AlphaData',binaryImage) 
        title('Breaking portion', 'FontSize', fontSize);
        
        %add to break point proportion and displace it         
        binarybreakcount=binarybreakcount+binaryImage;
        binarybreakcount2=binarybreakcount./framecount;
        
         hImage(4) = subplot(3, 2, 4);
        image(thisFrame);
        im=imagesc('CData',binarybreakcount2,[0.01 1]);
        set(im,'AlphaData',binarybreakcount2) 
         colormap(hImage(4),jet)
         colorbar('east')
        title('Cumulative breaking portion', 'FontSize', fontSize);
         
        %if we want to make a vid save the frame
         if makevid == 1
        F(framecount)=getframe(fig);
         end
        
    end
	
    %plot the final cumulative breaking with a contour overlaid
        hImage(4) = subplot(3, 2, 4);
        image(thisFrame);
        hold on
        im=imagesc('CData',binarybreakcount2,[0.01 1]);
        set(im,'AlphaData',binarybreakcount2) 
        colormap(hImage(4),jet)
        colorbar('east')
        title('Cumulative breaking portion', 'FontSize', fontSize);
        x = 1:size(binarybreakcount2, 2); y = 1:size(binarybreakcount2, 1);
        cc=contour(x, y, binarybreakcount2, [contourlevel contourlevel], 'm');
        legend('10% exceedance')
        
    %binarybreakcount2=binarybreakcount./max(binarybreakcount);
    %binarybreakcount3=binarybreakcount2.*255;
    
    binarybreak8Bit = uint8(255 * mat2gray(binarybreakcount2));
    
    %if we want to save images and data do it 
    if  SaveYN == 1
    imwrite(stack8Bit,strcat(movieFullFileName,"_stack.jpg"),'Quality',100);
    imwrite(AvImage,strcat(movieFullFileName,"_average.jpg"),'Quality',100);
    imwrite(binarybreak8Bit,strcat(movieFullFileName,"_binarysum.jpg"),'Quality',100);
	saveas(gcf,strcat(movieFullFileName,"_processfigure.jpg"))
    end
    
    close
    
      %presenting timestack figure
        sizestack=size(stack);
        if sizestack(2)<900
            sizestack(2)=900;
        end
        figure('Position', [0 0 sizestack(2) sizestack(1)])
        g=image(stack8Bit);
        %drawnow
		% Put title back because plot() erases the existing title.
		caption = sprintf('Timestack at %f fps.', round(fps));
		title(caption, 'FontSize', fontSize);
        xlabel('Frame Number');
		ylabel('distance offshore');

    %presenting figure of cumulative breaking with % exceedance contour
    %overlaid 
        figure('Position', [10 10 900 600])
        h=image(AvImage);
        hold on
        im=imagesc('CData',binarybreakcount2,[0.01 1]);
        set(im,'AlphaData',binarybreakcount2) 
         colormap(jet)
         colorbar('east')
        title('Cumulative breaking portion', 'FontSize', fontSize);
        x = 1:size(binarybreakcount2, 2); y = 1:size(binarybreakcount2, 1);
        cc=contour(x, y, binarybreakcount2, [contourlevel contourlevel], 'm');
        legend('10% exceedance')
       
      
        
        if  SaveYN == 1
        saveas(h,strcat(movieFullFileName,"_breakingexceedance.jpg"))
        saveas(g,strcat(movieFullFileName,"_timestack.jpg"))

        %Saving mat files of binary count and stack
        save(strcat(movieFullFileName,"_stack.mat"),'stack');
        save(strcat(movieFullFileName,"_binarysum.mat"),'binarybreakcount2')
        save(strcat(movieFullFileName,"_10-contour.mat"),'cc')
        end
        
        %If we want to save a video
        if makevid == 1
        vidfilename=char(strcat(movieFullFileName,"_processvideo.avi"));
        v = VideoWriter(vidfilename);
        v.FrameRate=vFrameRate;
        open(v)
        writeVideo(v,F(1:playbackinterval:end))
        close(v)
        else
        end
    
        g = msgbox({'Ok thats it, bye bye';'SURF ZONE FUN v1.0'});
        
catch ME
	% Some error happened if you get here.
	strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	uiwait(msgbox(strErrorMessage));
end

end