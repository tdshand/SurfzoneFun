% Surfzone Fun by Tom Shand & Pete Quilter.
% V1.0 February 2021

% Edited by Tom Shand 5/7/20 to 
    %  1. extract pixel lines from images and make stack.
    %  2. convert image to binary to show breaking and sum total number 
    %  3. progressively average image
%21/7/20 to include options for rows or columns and start and end
    %  time
%7/9/20 to allow diagonal stacks as well as rows or columns and
    %  output video of the process.
%25/9/20 to overlay the bindary breaking and exceedance on image
%3/11/20 to provide one shell to run the other options from within
    %(this shell). Now gives option for cumulative breaking, timestack or 
    %both for user to select.
%5/1/21 to be run from GUI (see seperate GUI) v0.1
%8/2/21 all outputs and mask.mat/stackxy.mat saved in call video dir - v1.0

%% Initialising
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 16;

%% User define below 
%Folder where video is
folder = 'C:\your\folder\here'; 
file='videofile.MOV.mp4.avi';

%Frames to use
startframe=1;   %what frame do you want to start at?
endframe=200; %end frame (use 9999 if want last frame)
interval=10; %desired interval between frames

%do you want to run a timestack only (1), 
%cumulative breaking analysis only (2) or both cumulative breaking and timestack (3)
Method=3;

%do you want to define a ROI for the breaking analysis? 1 = no, 2 = yes - pick from image, 3 = yes - use file called mask.mat
ROI=2;

%do you want to stack a column a row or user defined? 
Type = 3; %type 1 = column, type 2 = row, type 3 = select (do a zigzag for fun), type 4 - you already have a set of points called stackxy.mat

%if type 1 or 2 input below
column = 640; %what column do you want to stack? Use 0 if a row
row=500;         %what row do you want to stack? Use 0 if a column

%If doing cumulative breaking analysis
binarythresh = 0.75; %threshold for binary 
contourlevel=0.1; % level of contour on binary image

%Do you want to make a video of the process?
makevid=1; %make a video of the stacking 1 = Y, 0 = N
vFrameRate=10; %Video playback rate
playbackinterval=10; %video playback interval (every n frames)

%Do you want to save out images and data? 
SaveYN = 1;  %1 is yes save and 2 is don't save anything

%starting the engines

if Method == 1   %timestacking only
[SingleFrame,Stack,AvImage] = TimestackEngine(file,fontSize,folder,Type,column,row,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN);

elseif Method == 2   %cumulative breaking only
[SingleFrame,AvImage,Binarybreakcount,Contour] = BinaryEngine(file,fontSize,folder,ROI,binarythresh,contourlevel,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN);

elseif Method == 3   %cumulative breaking and timestacking
[SingleFrame,Stack,AvImage,Binarybreakcount,Contour] = TimestackBinaryEngine(file,fontSize,folder,ROI,Type,column,row,binarythresh,contourlevel,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN);
    
    % where outputs are
        % SingleFrame = last frame of analysis
        % Stack = timestack along defined line
        % AvImage = average image
        % CumBinarybreak = cumulative binary break proportion 
        % Contour = x% exceedance contour from CumBinarybreak
    
end      