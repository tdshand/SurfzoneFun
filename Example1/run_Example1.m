% Surfzone Fun by Tom Shand & Pete Quilter.
% V1.0 February 2021

% Example script for ExampleVid1_Ngaranui.MOV
% Copy to root directory and run
% Timelapse video of Ngaranui Beach by Tom Shand (2020)

%% Initialising
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 16;

%% User define below 
%Folder where video is
folder = fullfile(pwd, 'Example1'); 
file='ExampleVid1_Ngaranui.MOV';

%Frames to use
startframe=1;   %what frame do you want to start at?
endframe=9999; %end frame (use 9999 if want last frame)
interval=1; %desired interval between frames

%do you want to run a timestack only (1), 
%cumulative breaking analysis only (2) or both cumulative breaking and timestack (3)
Method=1;

%do you want to define a ROI for the breaking analysis? 1 = no, 2 = yes - pick from image, 3 = yes - use file called mask.mat
ROI=3;

%do you want to stack a column a row or user defined? 
Type = 2; %type 1 = column, type 2 = row, type 3 = select (do a zigzag for fun), type 4 - you already have a set of points called stackxy.mat

%if type 1 or 2 input below
column = 0; %what column do you want to stack? Use 0 if a row
row=400;         %what row do you want to stack? Use 0 if a column

%If doing cumulative breaking analysis
binarythresh = 0.8; %threshold for binary 
contourlevel=0.1; % level of contour on binary image

%Do you want to make a video of the process?
makevid=1; %make a video of the stacking 1 = Y, 0 = N
vFrameRate=30; %Video playback rate
playbackinterval=5; %video playback interval (every n frames)

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