classdef SurfZoneFunGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        ChoosevidfileButton             matlab.ui.control.Button
        StartframeEditFieldLabel        matlab.ui.control.Label
        StartframeEditField             matlab.ui.control.NumericEditField
        EndframeEditFieldLabel          matlab.ui.control.Label
        EndframeEditField               matlab.ui.control.NumericEditField
        FrameintervalEditFieldLabel     matlab.ui.control.Label
        FrameintervalEditField          matlab.ui.control.NumericEditField
        DefineROIDropDownLabel          matlab.ui.control.Label
        DefineROIDropDown               matlab.ui.control.DropDown
        StackDropDownLabel              matlab.ui.control.Label
        StackDropDown                   matlab.ui.control.DropDown
        RowcolumnEditFieldLabel         matlab.ui.control.Label
        RowcolumnEditField              matlab.ui.control.NumericEditField
        Binarythreshold01EditFieldLabel  matlab.ui.control.Label
        Binarythreshold01EditField      matlab.ui.control.NumericEditField
        Contourlevel01EditFieldLabel    matlab.ui.control.Label
        Contourlevel01EditField         matlab.ui.control.NumericEditField
        MakeprocessvideoDropDownLabel   matlab.ui.control.Label
        MakeprocessvideoDropDown        matlab.ui.control.DropDown
        ProcessvideoframerateEditFieldLabel  matlab.ui.control.Label
        ProcessvideoframerateEditField  matlab.ui.control.NumericEditField
        ProcessvideointervalEditFieldLabel  matlab.ui.control.Label
        ProcessvideointervalEditField   matlab.ui.control.NumericEditField
        SaveimagesdataDropDownLabel     matlab.ui.control.Label
        SaveimagesdataDropDown          matlab.ui.control.DropDown
        DotimestackonlyButton           matlab.ui.control.Button
        CumulativebreakingonlyButton    matlab.ui.control.Button
        CumulativebreakingtimestackButton  matlab.ui.control.Button
        DosomestuffLabel                matlab.ui.control.Label
        TimestackandbreakingoptionsLabel  matlab.ui.control.Label
        ChoosefileandframesLabel        matlab.ui.control.Label
        SelectsaveoptionsLabel          matlab.ui.control.Label
        SurfzoneFunv10ShandQuilterFeb2021Label  matlab.ui.control.Label
        Button                          matlab.ui.control.Button
        SurfzoneFunv10Label             matlab.ui.control.Label
    end

    methods (Access = private)

        % Button pushed function: ChoosevidfileButton
        function ChoosevidfileButtonPushed(app, event)

        [file,folder] = uigetfile({'*.mov';'*.avi';'*.mp4';'*.*'},...
               'Select a video file'); %select a video file 
        movieFullFileName = fullfile(folder, file);
        app.ChoosevidfileButton.UserData = file;
        app.ChoosevidfileButton.Tag = folder;
        
       videoObject = VideoReader(movieFullFileName);
       line0 = char(strcat("Video summary for ",file));
       line1 = sprintf('Video duration %f s', videoObject.Duration);
       line2 = sprintf('Video frame rate %f fps', videoObject.Framerate);
       line3 = sprintf('Total frames = %f', videoObject.Duration.*videoObject.Framerate);
       line4 = sprintf('Video width = %f', videoObject.Width);
       line5 = sprintf('Video width = %f', videoObject.Height);
       line6='...use this to help with your selections...';
       f = msgbox({line0;line1;line2;line3;line4;line5;line6});
        
        end

        % Value changed function: StartframeEditField
        function StartframeEditFieldValueChanged(app, event)

        end

        % Value changed function: EndframeEditField
        function EndframeEditFieldValueChanged(app, event)

        end

        % Value changed function: FrameintervalEditField
        function FrameintervalEditFieldValueChanged(app, event)
            
        end

        % Value changed function: DefineROIDropDown
        function DefineROIDropDownValueChanged(app, event)
           
        end

        % Value changed function: StackDropDown
        function StackDropDownValueChanged(app, event)
            
        end

        % Value changed function: RowcolumnEditField
        function RowcolumnEditFieldValueChanged(app, event)
            
        end

        % Value changed function: Binarythreshold01EditField
        function Binarythreshold01EditFieldValueChanged(app, event)
            
        end

        % Value changed function: Contourlevel01EditField
        function Contourlevel01EditFieldValueChanged(app, event)
            
        end

        % Value changed function: MakeprocessvideoDropDown
        function MakeprocessvideoDropDownValueChanged(app, event)
            
        end

        % Value changed function: ProcessvideoframerateEditField
        function ProcessvideoframerateEditFieldValueChanged(app, event)
            
        end

        % Value changed function: ProcessvideointervalEditField
        function ProcessvideointervalEditFieldValueChanged(app, event)
            
        end

        % Value changed function: SaveimagesdataDropDown
        function SaveimagesdataDropDownValueChanged(app, event)
            
        end

        % Button pushed function: DotimestackonlyButton
        function DotimestackonlyButtonPushed(app, event)
            file=app.ChoosevidfileButton.UserData;
            folder=app.ChoosevidfileButton.Tag;
            startframe = app.StartframeEditField.Value;   %what frame do you want to start at?
            endframe = app.EndframeEditField.Value; %end frame (use 9999 if want last frame)
            interval = app.FrameintervalEditField.Value; %desired interval between frames
            ROI = app.DefineROIDropDown.Value;   %do you want to define a ROI for the breaking analysis? 0 = no, 1 = yes - pick from image, 2 = yes - use file called mask.mat
            ROI=str2num(ROI);
            Type = app.StackDropDown.Value;    %do you want to stack a column a row or user defined? type 1 = column, type 2 = row, type 3 = select (do a zigzag for fun), type 4 - you already have a set of points called stackxy.mat
            Type = str2num(Type);
            column = app.RowcolumnEditField.Value;
            row = app.RowcolumnEditField.Value; %what row or column do you want to stack? 
            binarythresh = app.Binarythreshold01EditField.Value;%threshold for binary (0 - 1)
            contourlevel = app.Contourlevel01EditField.Value; % level of contour on binary image (0 - 1)
            makevid = app.MakeprocessvideoDropDown.Value;  %Do you want to make a video of the process?  1 = Y, 0 = N
            makevid=str2num(makevid);
            vFrameRate = app.ProcessvideoframerateEditField.Value;  %Video playback rate
            playbackinterval = app.ProcessvideointervalEditField.Value;  %video playback interval (every n frames)
            SaveYN = app.SaveimagesdataDropDown.Value;  %Do you want to save out images and data? 
            SaveYN=str2num(SaveYN);
            
            [SingleFrame,Stack,AvImage] = TimestackEngine(file,16,folder,Type,column,row,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN);
            %[SingleFrame,Stack,AvImage] = TimestackEngine(app.ChoosevidfileButton.UserData,16,app.ChoosevidfileButton.Tag,app.StackDropDown.Value,app.RowcolumnEditField.Value,app.RowcolumnEditField.Value,app.StartframeEditField.Value,app.EndframeEditField.Value,app.FrameintervalEditField.Value,app.MakeprocessvideoDropDown.Value,app.ProcessvideoframerateEditField.Value,app.ProcessvideointervalEditField.Value,app.SaveimagesdataDropDown.Value);
        end

        % Button pushed function: CumulativebreakingonlyButton
        function CumulativebreakingonlyButtonPushed(app, event)
            %Sort out the variables
            file=app.ChoosevidfileButton.UserData;
            folder=app.ChoosevidfileButton.Tag;
            startframe = app.StartframeEditField.Value;   %what frame do you want to start at?
            endframe = app.EndframeEditField.Value; %end frame (use 9999 if want last frame)
            interval = app.FrameintervalEditField.Value; %desired interval between frames
            ROI = app.DefineROIDropDown.Value;   %do you want to define a ROI for the breaking analysis? 0 = no, 1 = yes - pick from image, 2 = yes - use file called mask.mat
            ROI=str2num(ROI);
            Type = app.StackDropDown.Value;    %do you want to stack a column a row or user defined? type 1 = column, type 2 = row, type 3 = select (do a zigzag for fun), type 4 - you already have a set of points called stackxy.mat
            Type = str2num(Type);
            column = app.RowcolumnEditField.Value;
            row = app.RowcolumnEditField.Value; %what row or column do you want to stack? 
            binarythresh = app.Binarythreshold01EditField.Value;%threshold for binary (0 - 1)
            contourlevel = app.Contourlevel01EditField.Value; % level of contour on binary image (0 - 1)
            makevid = app.MakeprocessvideoDropDown.Value;  %Do you want to make a video of the process?  1 = Y, 0 = N
            makevid=str2num(makevid);
            vFrameRate = app.ProcessvideoframerateEditField.Value;  %Video playback rate
            playbackinterval = app.ProcessvideointervalEditField.Value;  %video playback interval (every n frames)
            SaveYN = app.SaveimagesdataDropDown.Value;  %Do you want to save out images and data? 
            SaveYN=str2num(SaveYN);
            
            %run the function
            [SingleFrame,AvImage,Binarybreakcount,Contour] = BinaryEngine(file,16,folder,ROI,binarythresh,contourlevel,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN);
        end

        % Button pushed function: CumulativebreakingtimestackButton
        function CumulativebreakingtimestackButtonPushed(app, event)
            %Sort out the variables
            file=app.ChoosevidfileButton.UserData;
            folder=app.ChoosevidfileButton.Tag;
            startframe = app.StartframeEditField.Value;   %what frame do you want to start at?
            endframe = app.EndframeEditField.Value; %end frame (use 9999 if want last frame)
            interval = app.FrameintervalEditField.Value; %desired interval between frames
            ROI = app.DefineROIDropDown.Value;   %do you want to define a ROI for the breaking analysis? 0 = no, 1 = yes - pick from image, 2 = yes - use file called mask.mat
            ROI=str2num(ROI);
            Type = app.StackDropDown.Value;    %do you want to stack a column a row or user defined? type 1 = column, type 2 = row, type 3 = select (do a zigzag for fun), type 4 - you already have a set of points called stackxy.mat
            Type = str2num(Type);
            column = app.RowcolumnEditField.Value;
            row = app.RowcolumnEditField.Value; %what row or column do you want to stack? 
            binarythresh = app.Binarythreshold01EditField.Value;%threshold for binary (0 - 1)
            contourlevel = app.Contourlevel01EditField.Value; % level of contour on binary image (0 - 1)
            makevid = app.MakeprocessvideoDropDown.Value;  %Do you want to make a video of the process?  1 = Y, 0 = N
            makevid=str2num(makevid);
            vFrameRate = app.ProcessvideoframerateEditField.Value;  %Video playback rate
            playbackinterval = app.ProcessvideointervalEditField.Value;  %video playback interval (every n frames)
            SaveYN = app.SaveimagesdataDropDown.Value;  %Do you want to save out images and data? 
            SaveYN=str2num(SaveYN);
            
            %run the function
            [SingleFrame,Stack,AvImage,Binarybreakcount,Contour] = TimestackBinaryEngine(file,16,folder,ROI,Type,column,row,binarythresh,contourlevel,startframe,endframe,interval,makevid,vFrameRate,playbackinterval,SaveYN);
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            msgbox('SurfzoneFun v1.0; Shand|Quilter Feb 2021;');
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Color = [0.902 0.902 0.902];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create ChoosevidfileButton
            app.ChoosevidfileButton = uibutton(app.UIFigure, 'push');
            app.ChoosevidfileButton.ButtonPushedFcn = createCallbackFcn(app, @ChoosevidfileButtonPushed, true);
            app.ChoosevidfileButton.BackgroundColor = [0.302 0.749 0.9294];
            app.ChoosevidfileButton.Position = [125 345 100 22];
            app.ChoosevidfileButton.Text = 'Choose vid file';

            % Create StartframeEditFieldLabel
            app.StartframeEditFieldLabel = uilabel(app.UIFigure);
            app.StartframeEditFieldLabel.HorizontalAlignment = 'right';
            app.StartframeEditFieldLabel.Position = [112 316 65 22];
            app.StartframeEditFieldLabel.Text = 'Start frame';

            % Create StartframeEditField
            app.StartframeEditField = uieditfield(app.UIFigure, 'numeric');
            app.StartframeEditField.Limits = [1 20000];
            app.StartframeEditField.RoundFractionalValues = 'on';
            app.StartframeEditField.ValueChangedFcn = createCallbackFcn(app, @StartframeEditFieldValueChanged, true);
            app.StartframeEditField.Position = [192 316 63 22];
            app.StartframeEditField.Value = 1;

            % Create EndframeEditFieldLabel
            app.EndframeEditFieldLabel = uilabel(app.UIFigure);
            app.EndframeEditFieldLabel.HorizontalAlignment = 'right';
            app.EndframeEditFieldLabel.Position = [112 280 61 22];
            app.EndframeEditFieldLabel.Text = 'End frame';

            % Create EndframeEditField
            app.EndframeEditField = uieditfield(app.UIFigure, 'numeric');
            app.EndframeEditField.Limits = [2 20000];
            app.EndframeEditField.RoundFractionalValues = 'on';
            app.EndframeEditField.ValueChangedFcn = createCallbackFcn(app, @EndframeEditFieldValueChanged, true);
            app.EndframeEditField.Position = [188 280 63 22];
            app.EndframeEditField.Value = 600;

            % Create FrameintervalEditFieldLabel
            app.FrameintervalEditFieldLabel = uilabel(app.UIFigure);
            app.FrameintervalEditFieldLabel.HorizontalAlignment = 'right';
            app.FrameintervalEditFieldLabel.Position = [110 242 82 22];
            app.FrameintervalEditFieldLabel.Text = 'Frame interval';

            % Create FrameintervalEditField
            app.FrameintervalEditField = uieditfield(app.UIFigure, 'numeric');
            app.FrameintervalEditField.Limits = [1 100];
            app.FrameintervalEditField.RoundFractionalValues = 'on';
            app.FrameintervalEditField.ValueChangedFcn = createCallbackFcn(app, @FrameintervalEditFieldValueChanged, true);
            app.FrameintervalEditField.Position = [207 242 63 22];
            app.FrameintervalEditField.Value = 10;

            % Create DefineROIDropDownLabel
            app.DefineROIDropDownLabel = uilabel(app.UIFigure);
            app.DefineROIDropDownLabel.HorizontalAlignment = 'right';
            app.DefineROIDropDownLabel.Position = [77 93 65 22];
            app.DefineROIDropDownLabel.Text = 'Define ROI';

            % Create DefineROIDropDown
            app.DefineROIDropDown = uidropdown(app.UIFigure);
            app.DefineROIDropDown.Items = {'No', 'Yes', 'Pre-defined (mask.mat)'};
            app.DefineROIDropDown.ItemsData = {'1', '2', '3'};
            app.DefineROIDropDown.ValueChangedFcn = createCallbackFcn(app, @DefineROIDropDownValueChanged, true);
            app.DefineROIDropDown.Position = [157 93 100 22];
            app.DefineROIDropDown.Value = '1';

            % Create StackDropDownLabel
            app.StackDropDownLabel = uilabel(app.UIFigure);
            app.StackDropDownLabel.HorizontalAlignment = 'right';
            app.StackDropDownLabel.Position = [79 164 36 22];
            app.StackDropDownLabel.Text = 'Stack';

            % Create StackDropDown
            app.StackDropDown = uidropdown(app.UIFigure);
            app.StackDropDown.Items = {'Column', 'Row', 'User defined', 'Pre-defined (stackxy.mat)'};
            app.StackDropDown.ItemsData = {'1', '2', '3', '4'};
            app.StackDropDown.ValueChangedFcn = createCallbackFcn(app, @StackDropDownValueChanged, true);
            app.StackDropDown.Position = [130 164 100 22];
            app.StackDropDown.Value = '1';

            % Create RowcolumnEditFieldLabel
            app.RowcolumnEditFieldLabel = uilabel(app.UIFigure);
            app.RowcolumnEditFieldLabel.HorizontalAlignment = 'right';
            app.RowcolumnEditFieldLabel.Position = [77 128 72 22];
            app.RowcolumnEditFieldLabel.Text = 'Row/column';

            % Create RowcolumnEditField
            app.RowcolumnEditField = uieditfield(app.UIFigure, 'numeric');
            app.RowcolumnEditField.Limits = [0 9999];
            app.RowcolumnEditField.RoundFractionalValues = 'on';
            app.RowcolumnEditField.ValueChangedFcn = createCallbackFcn(app, @RowcolumnEditFieldValueChanged, true);
            app.RowcolumnEditField.Position = [164 128 45 22];
            app.RowcolumnEditField.Value = 500;

            % Create Binarythreshold01EditFieldLabel
            app.Binarythreshold01EditFieldLabel = uilabel(app.UIFigure);
            app.Binarythreshold01EditFieldLabel.HorizontalAlignment = 'right';
            app.Binarythreshold01EditFieldLabel.Position = [77 60 121 22];
            app.Binarythreshold01EditFieldLabel.Text = 'Binary threshold (0-1)';

            % Create Binarythreshold01EditField
            app.Binarythreshold01EditField = uieditfield(app.UIFigure, 'numeric');
            app.Binarythreshold01EditField.Limits = [0 1];
            app.Binarythreshold01EditField.ValueChangedFcn = createCallbackFcn(app, @Binarythreshold01EditFieldValueChanged, true);
            app.Binarythreshold01EditField.Position = [213 60 37 22];
            app.Binarythreshold01EditField.Value = 0.8;

            % Create Contourlevel01EditFieldLabel
            app.Contourlevel01EditFieldLabel = uilabel(app.UIFigure);
            app.Contourlevel01EditFieldLabel.HorizontalAlignment = 'right';
            app.Contourlevel01EditFieldLabel.Position = [75 25 112 22];
            app.Contourlevel01EditFieldLabel.Text = 'Contour level (0 - 1)';

            % Create Contourlevel01EditField
            app.Contourlevel01EditField = uieditfield(app.UIFigure, 'numeric');
            app.Contourlevel01EditField.Limits = [0 1];
            app.Contourlevel01EditField.ValueChangedFcn = createCallbackFcn(app, @Contourlevel01EditFieldValueChanged, true);
            app.Contourlevel01EditField.Position = [211 25 37 22];
            app.Contourlevel01EditField.Value = 0.1;

            % Create MakeprocessvideoDropDownLabel
            app.MakeprocessvideoDropDownLabel = uilabel(app.UIFigure);
            app.MakeprocessvideoDropDownLabel.HorizontalAlignment = 'right';
            app.MakeprocessvideoDropDownLabel.Position = [362 335 112 22];
            app.MakeprocessvideoDropDownLabel.Text = 'Make process video';

            % Create MakeprocessvideoDropDown
            app.MakeprocessvideoDropDown = uidropdown(app.UIFigure);
            app.MakeprocessvideoDropDown.Items = {'Yes', 'No'};
            app.MakeprocessvideoDropDown.ItemsData = {'1', '2'};
            app.MakeprocessvideoDropDown.ValueChangedFcn = createCallbackFcn(app, @MakeprocessvideoDropDownValueChanged, true);
            app.MakeprocessvideoDropDown.Position = [489 335 100 22];
            app.MakeprocessvideoDropDown.Value = '1';

            % Create ProcessvideoframerateEditFieldLabel
            app.ProcessvideoframerateEditFieldLabel = uilabel(app.UIFigure);
            app.ProcessvideoframerateEditFieldLabel.HorizontalAlignment = 'right';
            app.ProcessvideoframerateEditFieldLabel.Position = [358 305 139 22];
            app.ProcessvideoframerateEditFieldLabel.Text = 'Process video frame rate';

            % Create ProcessvideoframerateEditField
            app.ProcessvideoframerateEditField = uieditfield(app.UIFigure, 'numeric');
            app.ProcessvideoframerateEditField.Limits = [1 30];
            app.ProcessvideoframerateEditField.RoundFractionalValues = 'on';
            app.ProcessvideoframerateEditField.ValueChangedFcn = createCallbackFcn(app, @ProcessvideoframerateEditFieldValueChanged, true);
            app.ProcessvideoframerateEditField.Position = [511 305 48 22];
            app.ProcessvideoframerateEditField.Value = 10;

            % Create ProcessvideointervalEditFieldLabel
            app.ProcessvideointervalEditFieldLabel = uilabel(app.UIFigure);
            app.ProcessvideointervalEditFieldLabel.HorizontalAlignment = 'right';
            app.ProcessvideointervalEditFieldLabel.Position = [359 273 123 22];
            app.ProcessvideointervalEditFieldLabel.Text = 'Process video interval';

            % Create ProcessvideointervalEditField
            app.ProcessvideointervalEditField = uieditfield(app.UIFigure, 'numeric');
            app.ProcessvideointervalEditField.Limits = [1 30];
            app.ProcessvideointervalEditField.RoundFractionalValues = 'on';
            app.ProcessvideointervalEditField.ValueChangedFcn = createCallbackFcn(app, @ProcessvideointervalEditFieldValueChanged, true);
            app.ProcessvideointervalEditField.Position = [499 273 48 22];
            app.ProcessvideointervalEditField.Value = 5;

            % Create SaveimagesdataDropDownLabel
            app.SaveimagesdataDropDownLabel = uilabel(app.UIFigure);
            app.SaveimagesdataDropDownLabel.HorizontalAlignment = 'right';
            app.SaveimagesdataDropDownLabel.Position = [357 241 102 22];
            app.SaveimagesdataDropDownLabel.Text = 'Save images/data';

            % Create SaveimagesdataDropDown
            app.SaveimagesdataDropDown = uidropdown(app.UIFigure);
            app.SaveimagesdataDropDown.Items = {'Yes', 'No'};
            app.SaveimagesdataDropDown.ItemsData = {'1', '2'};
            app.SaveimagesdataDropDown.ValueChangedFcn = createCallbackFcn(app, @SaveimagesdataDropDownValueChanged, true);
            app.SaveimagesdataDropDown.Position = [474 241 100 22];
            app.SaveimagesdataDropDown.Value = '1';

            % Create DotimestackonlyButton
            app.DotimestackonlyButton = uibutton(app.UIFigure, 'push');
            app.DotimestackonlyButton.ButtonPushedFcn = createCallbackFcn(app, @DotimestackonlyButtonPushed, true);
            app.DotimestackonlyButton.Icon = 'Icon2.jpg';
            app.DotimestackonlyButton.BackgroundColor = [0.302 0.749 0.9294];
            app.DotimestackonlyButton.Position = [384 155 173 39];
            app.DotimestackonlyButton.Text = 'Do timestack only';

            % Create CumulativebreakingonlyButton
            app.CumulativebreakingonlyButton = uibutton(app.UIFigure, 'push');
            app.CumulativebreakingonlyButton.ButtonPushedFcn = createCallbackFcn(app, @CumulativebreakingonlyButtonPushed, true);
            app.CumulativebreakingonlyButton.Icon = 'Icon3.jpg';
            app.CumulativebreakingonlyButton.BackgroundColor = [0.302 0.749 0.9294];
            app.CumulativebreakingonlyButton.Position = [368 92 207 53];
            app.CumulativebreakingonlyButton.Text = 'Cumulative breaking only';

            % Create CumulativebreakingtimestackButton
            app.CumulativebreakingtimestackButton = uibutton(app.UIFigure, 'push');
            app.CumulativebreakingtimestackButton.ButtonPushedFcn = createCallbackFcn(app, @CumulativebreakingtimestackButtonPushed, true);
            app.CumulativebreakingtimestackButton.Icon = 'Icon4.jpg';
            app.CumulativebreakingtimestackButton.BackgroundColor = [0.302 0.749 0.9294];
            app.CumulativebreakingtimestackButton.Position = [345 32 257 50];
            app.CumulativebreakingtimestackButton.Text = 'Cumulative breaking + timestack';

            % Create DosomestuffLabel
            app.DosomestuffLabel = uilabel(app.UIFigure);
            app.DosomestuffLabel.FontWeight = 'bold';
            app.DosomestuffLabel.Position = [424 200 86 22];
            app.DosomestuffLabel.Text = 'Do some stuff';

            % Create TimestackandbreakingoptionsLabel
            app.TimestackandbreakingoptionsLabel = uilabel(app.UIFigure);
            app.TimestackandbreakingoptionsLabel.FontWeight = 'bold';
            app.TimestackandbreakingoptionsLabel.Position = [83 200 190 22];
            app.TimestackandbreakingoptionsLabel.Text = 'Timestack and breaking options';

            % Create ChoosefileandframesLabel
            app.ChoosefileandframesLabel = uilabel(app.UIFigure);
            app.ChoosefileandframesLabel.FontWeight = 'bold';
            app.ChoosefileandframesLabel.Position = [115 375 138 22];
            app.ChoosefileandframesLabel.Text = 'Choose file and frames';

            % Create SelectsaveoptionsLabel
            app.SelectsaveoptionsLabel = uilabel(app.UIFigure);
            app.SelectsaveoptionsLabel.FontWeight = 'bold';
            app.SelectsaveoptionsLabel.Position = [413 375 118 22];
            app.SelectsaveoptionsLabel.Text = 'Select save options';

            % Create SurfzoneFunv10ShandQuilterFeb2021Label
            app.SurfzoneFunv10ShandQuilterFeb2021Label = uilabel(app.UIFigure);
            app.SurfzoneFunv10ShandQuilterFeb2021Label.FontSize = 9;
            app.SurfzoneFunv10ShandQuilterFeb2021Label.Position = [540 1 101 22];
            app.SurfzoneFunv10ShandQuilterFeb2021Label.Text = {'SurfzoneFun v1.0'; 'Shand|Quilter Feb 2021'; ''};

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Icon = 'Icon1.jpg';
            app.Button.BackgroundColor = [0.902 0.902 0.902];
            app.Button.FontColor = [0.902 0.902 0.902];
            app.Button.Position = [7 402 629 72];
            app.Button.Text = '';

            % Create SurfzoneFunv10Label
            app.SurfzoneFunv10Label = uilabel(app.UIFigure);
            app.SurfzoneFunv10Label.FontSize = 14;
            app.SurfzoneFunv10Label.FontWeight = 'bold';
            app.SurfzoneFunv10Label.Position = [259 449 126 22];
            app.SurfzoneFunv10Label.Text = 'Surfzone Fun v1.0';
        end
    end

    methods (Access = public)

        % Construct app
        function app = SurfZoneFunGUI

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end