function    [thisFrame,AvImage,binarybreakcount2,cc] = BinaryEngine(file,fontSize,folder,ROI,binarythresh,contourlevel,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN)

% Engine for Cumulative Breaking only as part of SurfZoneFun. 
% Run via SurfZoneFun by Tom Shand & Pete Quilter 2021

%Inputs
file
fontSize
folder
ROI
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
        % Determine how many frames there are.
        
        if startframe>endframe
            g = msgbox({'Startframe > Endframe';'Starting from 1'}, 'Oops','error');
            startframe = 1;
        end
        
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
	 fig=figure('Position', [50 50 800 900])
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
		
		% gray image.
		grayImage = rgb2gray(thisFrame);
		
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

        %Create binary image to show breaking areas and plot it over the frame
		binaryImage = im2bw( grayImage, binarythresh); 
		
        if ROI == 2
        binaryImage =binaryImage .*mask;
         elseif ROI == 3
        binaryImage =binaryImage .*mask;
        else
        end
        
         %add to break point proportion and displace it 
        binarybreakcount=binarybreakcount+binaryImage;
        binarybreakcount2=binarybreakcount./framecount;
        
        hImage(3) = subplot(2, 1, 1);
        image(thisFrame);
        im=imagesc('CData',binaryImage);
        set(im,'AlphaData',binaryImage) 
%        title('Breaking portion', 'FontSize', fontSize);
 		caption = sprintf('Frame %4d of %d.', framecount.*interval, numberOfFrames);
 		title(caption, 'FontSize', fontSize);
         drawnow; % Force it to refresh the window.

         hImage(4) = subplot(2, 1, 2);
        image(thisFrame);
        im=imagesc('CData',binarybreakcount2,[0.01 1]);
        set(im,'AlphaData',binarybreakcount2) 
         colormap(hImage(4),jet)
         colorbar('east')
        title('Cumulative breaking portion', 'FontSize', fontSize);
         
        %if we want to make a vid save the frame
         if makevid == 1
        %F(framecount)=getframe;
        F(framecount)=getframe(fig);
         end
        

    end
	
    %binarybreakcount2=binarybreakcount./max(binarybreakcount);
    %binarybreakcount3=binarybreakcount2.*255;
    
    binarybreak8Bit = uint8(255 * mat2gray(binarybreakcount2));
    
       %if we want to save images and data do it 
    if  SaveYN == 1
    imwrite(binarybreak8Bit,strcat(movieFullFileName,"_binarysum.jpg"),'Quality',100);
	saveas(gcf,strcat(movieFullFileName,"_processfigure.jpg"))
    end
    
    close
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
        
            %if we want to save images and data do it 
        if  SaveYN == 1
        saveas(gcf,strcat(movieFullFileName,"_breakingexceedance.jpg"))
        
 
        %Saving mat files of binary count and stack
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

