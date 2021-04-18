# SurfzoneFun
SurfzoneFun processes videos to illustrate surf zone processes.

The main functions of the package include:
1.	Progressively average video frames
2.	Create a timestack of a single profile of pixels 
3.	Identify breaking portion of an image using a threshold and sum over time to give precent exceedance 
The intent of this package is to provide outputs that will be useful for future analysis but also to visually illustrate the averaging, stacking and breaking processing.

There are a number of different ways of running SurfZoneFun:
1.	Install the matlab app SurfZoneFunGUIv1.0.mlappinstall. The GUI can be run straight from the apps tab in your matlab
2.	Run SurfZoneFunGUI.m which will open the GUI 
3.	Open SurfZoneFun.m and specify your location, file and values and hit run
4.	Run the examples with pre-specified versions of SurfZoneFun, i.e. run_Example1.m
5.	Call the individual processing engines (BinaryEngine.m, TimestackEngine.m, TimestackBinaryEngine.m)– if you want to batch run multiple videos you can do it this way.

![Alt text](https://github.com/tdshand/SurfzoneFun/blob/main/Docs/GUIv1.0cover.jpg)

## Software requirements: 
Matlab (tested on R2018b), Image processing toolbox

## Known bugs:
-	Can run out of memory if you are trying to process too many frames (or more often save a process video with too many frames)  
-	If you stack a row it will pull out the profile left to right – so if you’re looking north it can give a back-to-front stack
-	Threshold still needs a bit of trial and error and isn’t great with varying exposure during the video, shadowing, etc.

## To-dos for future versions
1.	Add a variable or dynamic threshold for breaking waves
2.	Add an option to rectify output images (at the moment you can do separately using g_rect or similar)
3.	Add an option to register video to remove movement between frames
4.	Incorporate wmeasure to assess breaking wave height (from Shand et al 2012)

## Contact:
Dr Tom Shand
Department of Civil and Environmental Engineering, The University of Auckland
t.shand@auckland.ac.nz | t.d.shand@gmail.com

References
Shand, T., Bailey, D., Shand, R. (2011) Automated Detection of Breaking Wave Height Using an Optical Technique. J. Coast. Res.2012,28, 671–682.

Shand, T., Weppe, S., Quilter, P., Short, A., Blumberg, B and Reinen-Hamill, R. (2020) Assessing the Effect Of Earthquake-Induced Uplift And Engineering Works on a Surf Break of National Significance. Coastal Engineering Proceedings

## Examples
Example 1

ExampleVid1_Ngaranui.MOV

Timelapse video of Ngaranui Beach by Tom Shand (2020)

![Alt text](https://github.com/tdshand/SurfzoneFun/blob/main/Docs/Example1.jpg)

Example 2

ExampleVid2_GoldCoast-WRL.mp4 

Timelapse video of Palm Beach by the Water Research Laboratory (2020)
 
![Alt text](https://github.com/tdshand/SurfzoneFun/blob/main/Docs/Example2.jpg)

Example 3


ExampleVid3_MangamaunuRect.avi

Rectified timelapse video of Mangamaunu Point, see Shand et al., (2020)

![Alt text](https://github.com/tdshand/SurfzoneFun/blob/main/Docs/Example3.jpg)
