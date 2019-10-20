% BACKGROUND ORIENTED SCHLIEREN
% Written by: JoshTheEngineer
% Website   : www.joshtheengineer.com
% YouTube   : www.youtube.com/joshtheengineer
% Started: 09/07/19
% Updated: 09/07/19 - Started code
%                   - Copied from BOS_Test_v3.m
%          09/12/19 - Refined the select-region auto caxis scaling
%                       using histogram
%          09/20/19 - Added sub-pixel resolution
%                   - Added video analysis code
%                   - Everything works nominally as expected
%                   - Note: Not everything is fully checked for all possible issues

function varargout = GUI_BOS_v2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_BOS_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_BOS_v2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before GUI_BOS_v2 is made visible.
function GUI_BOS_v2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_BOS_v2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% --------------------------- INITIALIZATION ---------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% EDIT ------------------------ Window Size -------------------------------
function editWSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT --------------------- Search Window Size ---------------------------
function editSSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------------- Threshold -------------------------------
function editThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------- Contour Image Transparency -----------------------
function editAlpha_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ----------------------- Colormap Selection --------------------------
function popColormap_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ---------------- Contour for Original Image Contour -----------------
function popOrigImgXYTot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ---------- Color Axis Start Value: Total Displacement --------------
function editCS_Tot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------- Color Axis End Value: Total Displacement ---------------
function editCE_Tot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------ Color Axis Start Value: Y Displacement ----------------
function editCS_Y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------- Color Axis End Value: Y Displacement -----------------
function editCE_Y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------ Color Axis Start Value: X Displacement ----------------
function editCS_X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------- Color Axis End Value: X Displacement -----------------
function editCE_X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------ Color Axis Start Value: Original Image ----------------
function editCS_OrigImg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------- Color Axis End Value: Original Image -----------------
function editCE_OrigImg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------------- VIDEO: Frame Rate --------------------------
function editFrameRate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------------- VIDEO: Movie Name --------------------------
function editMovieName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- VIDEO: Starting Frame --------------------------
function editStartingFrame_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- VIDEO: Ending Frame ---------------------------
function editNumFrames_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- VIDEO: CAxis Max Value -------------------------
function editCMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- VIDEO: CAxis Min Value -------------------------
function editCMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Interpolation Factor --------------------------
function editInterpolationFactor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------- CALLBACKS ------------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-
% -- PUSH -- PUSH -- PUSH -- PUSH -- PUSH -- PUSH -- PUSH -- PUSH -- PUSH -
% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-

% PUSH ----------------------- Load Image 1 -------------------------------
function pushLoadImage1_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - User selects the background image (template)
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');                   % Change colors of pushbutton
drawnow();

% User selects image 1 file
[flnm1,flpth1,c] = uigetfile(...                                            % User selects the file
    {'*.jpg;*.png;*.tif;*.tiff','Image Files (*.jpg;*.png;*.tif;*.tiff)'},...
    'Select Image 2',...
    'C:\Users\Josh\Documents\YouTube_Files\DIY_BOS\Section_9_Formula_1_Car\Frames');
%     'C:\Users\Josh\Documents\YouTube_Files\AAA_DIY_BOS');
if (c == 0)                                                                 % If user canceled
    set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],...
                'ForegroundColor','w');                                     % Set colors back to normal
    drawnow();
    return;                                                                 % Exit callback
end

% Set file name and path in text box
set(handles.textImage1File,'String',[flpth1 flnm1]);                        % Set file name and path

% Read the image file
I1 = imread([flpth1 flnm1]);                                                % Read the image file

% Convert to single [M x N] array
I1 = I1(:,:,1);                                                             % Convert to single array

% Save original image as well
I1Orig = I1;                                                                % Save original image as well

% Assign relevant variables to base workspace
assignin('base','I1',I1);                                                   % Loaded image
assignin('base','I1Orig',I1Orig);                                           % Original image (won't be cropped)

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');   % Set colors back to normal
drawnow();

% PUSH ----------------------- Load Image 2 -------------------------------
function pushLoadImage2_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - User selects second image
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');                   % Change colors of pushbutton
drawnow();

% User selects image 2 file
[flnm2,flpth2,c] = uigetfile(...                                            % User selects the file
    {'*.jpg;*.png;*.tif;*.tiff','Image Files (*.jpg;*.png;*.tif;*.tiff)'},...
    'Select Image 2',...
    'C:\Users\Josh\Documents\YouTube_Files\DIY_BOS\Section_9_Formula_1_Car\Frames');
%     'C:\Users\Josh\Documents\YouTube_Files\AAA_DIY_BOS');
if (c == 0)                                                                 % If user canceled
    set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],...
                'ForegroundColor','w');                                     % Set colors back to normal
    drawnow();
    return;                                                                 % Exit callback
end

% Set file name and path in text box
set(handles.textImage2File,'String',[flpth2 flnm2]);                        % Set file name and path

% Read the image file
I2 = imread([flpth2 flnm2]);                                                % Read the image file

% Convert to single [M x N] array
I2 = I2(:,:,1);                                                             % Convert to single array

% Save original image as well
I2Orig = I2;                                                                % Save original image as well

% Assign relevant variables to base workspace
assignin('base','I2',I2);                                                   % Loaded image
assignin('base','I2Orig',I2Orig);                                           % Original image (won't be cropped)

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');   % Set colors back to normal
drawnow();

% PUSH ----------------------- C O M P U T E ------------------------------
function pushCompute_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Load both images in, along with originals
% - Run the normalized cross-correlation code
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');
drawnow();

% Evaluate in relevant variables
I1     = evalin('base','I1');                                               % Load image 1
I2     = evalin('base','I2');                                               % Load image 2
I1Orig = evalin('base','I1Orig');                                           % Load image 1 (original)
I2Orig = evalin('base','I2Orig');                                           % Load image 2 (original)

% Get relevant variables
wSize     = str2double(get(handles.editWSize,'String'));                    % Window size
sSize     = str2double(get(handles.editSSize,'String'));                    % Search size
thresh    = str2double(get(handles.editThreshold,'String'));                % Threshold
checkCrop = get(handles.checkSelectSubRegion,'Value');                      % Cropping option checkbox

% If user wants to select a sub-region of the image
if (checkCrop == 1)                                                         % If user wants to crop
    figure(1);                                                              % Select appropriate figure
    [~,rect] = imcrop(I2Orig);                                              % User selects cropping region
    I1       = imcrop(I1,rect);                                             % Crop image 1
    I2       = imcrop(I2,rect);                                             % Crop image 2
else
    rect = [1 1 size(I2,2) size(I2,1)];                                     % Set crop region to full image
end

% Get number of rows and columns of the image
numRows_I = size(I1,1);                                                     % Number of rows in initial image
numCols_I = size(I1,2);                                                     % Number of cols in initial image

% Window and search half-sizes
wSize2 = floor(wSize/2);                                                    % Half of window size
sSize2 = floor(sSize/2);                                                    % Half of search size

% Window centers
wIndR = (wSize:wSize:(numRows_I-wSize2))';                                  % Window center locations for each row
wIndC = (wSize:wSize:(numCols_I-wSize2))';                                  % Window center locations for each column
numR  = length(wIndR);                                                      % Number of rows
numC  = length(wIndC);                                                      % Number of columns

% Show image, crop region, window size, and search size
fig1 = figure(1);                                                           % Select appropriate figure
cla; hold on;                                                               % Get ready for plotting
set(gcf,'Color','White');                                                   % Set plot background to white
imshow(I2Orig);                                                             % Show original image 2
rectangle('Position',[rect(1), rect(2), rect(3), rect(4)],...               % Plot cropping rectangle (dashed black)
         'LineWidth',2,'LineStyle','--');
xHalf = rect(1) + 0.5*rect(3);                                              % Half the crop rectangle (X)
yHalf = rect(2) + 0.5*rect(4);                                              % Half the crop rectangle (Y)
cropW = [xHalf-wSize2, yHalf-wSize2, wSize, wSize];                         % Define window region for plotting
cropS = [xHalf-sSize2, yHalf-sSize2, sSize, sSize];                         % Define search region for plotting
rectangle('Position',cropW,'EdgeColor','g','LineStyle','-','LineWidth',2);  % Draw "window" rectangle
rectangle('Position',cropS,'EdgeColor','r','LineStyle','-','LineWidth',2);  % Draw "search" rectangle
drawnow();                                                                  % Draw now

% Ask if user wants to continue
answer = questdlg('Continue with analysis?', ...                            % Ask if user wants to continue
	'Go/No Go','Yes','No','No');

% Handle the response
close(fig1);                                                                % Close the figure
drawnow();                                                                  % Make window go away now
if (strcmp(answer,'No'))                                                    % If user doesn't want to continue
    set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],...                % Reset button colors
                'ForegroundColor','w');
    drawnow();                                                              % Draw it now
    return;                                                                 % Exit the callback
end

% Loop over all windows and perform cros correlation
colPeak   = zeros(numR,numC);                                               % Initialize colPeak
rowPeak   = zeros(numR,numC);                                               % Initialize rowPeak
colOffset = zeros(numR,numC);                                               % Initialize colOffset
rowOffset = zeros(numR,numC);                                               % Initialize rowOffset
for i = 1:1:numR                                                            % Loop over all image rows
    iterStr = ['Iteration: ' num2str(i) '/' num2str(numR)];                 % Row iteration string
    set(handles.textIteration,'String',iterStr);                            % Set row iteration in GUI
    drawnow();                                                              % Update now
    for j = 1:1:numC                                                        % Loop over all image columns
        % Get window centers
        rowCenter = wIndR(i);                                               % Window row center
        colCenter = wIndC(j);                                               % Window column center
        
        % Crop the image to WINDOW size
        % - [col start, row start, col nums, row nums]
        cropI1 = [colCenter-wSize2, rowCenter-wSize2, wSize, wSize];        % Define cropping rectangle for image 1
        I1_Sub = imcrop(I1,cropI1);                                         % Crop image 1 (template)
        
        % Crop the template to SEARCH size
        % - [col start, row start, col nums, row nums]
        cropI2 = [colCenter-sSize2, rowCenter-sSize2, sSize, sSize];        % Define cropping rectangle for image 2
        I2_Sub = imcrop(I2,cropI2);                                         % Crop image 2 (comparison)
        
        % Compute normalized cross correlation
        if (all(I1_Sub == I1_Sub(1,1)))                                     % If "window" array values are all the same
            rowP = 0;                                                       % No row offset
            colP = 0;                                                       % No column offset
            dx   = 0;
            dy   = 0;
        else
            % Compute normalized cross-correlation
            c = normxcorr2(I1_Sub,I2_Sub);                                  % Normalized cross correlation
            [cR,cC] = size(c);
            
            % Find the peak indices of the cross-correlation map
            [rowP,colP] = find(c == max(c(:)));                             % Maximum indices of cross-correlation map
        	rowP = rowP(1);
            colP = colP(1);
            
            if (get(handles.checkSubPixelResolution,'Value') == 1)
                if (rowP == 1)  rowP = rowP + 1; end
                if (rowP == cR) rowP = rowP - 1; end
                if (colP == 1)  colP = colP + 1; end
                if (colP == cC) colP = colP - 1; end
                
                 % Sub-pixel displacement using three-point Gaussian
                numX = log(c(rowP-1,colP)) - log(c(rowP+1,colP));
                denX = 2*log(c(rowP-1,colP)) - 4*log(c(rowP,colP)) + 2*log(c(rowP+1,colP));
                dx   = numX/denX;
                numY = log(c(rowP,colP-1)) - log(c(rowP,colP+1));
                denY = 2*log(c(rowP,colP-1)) - 4*log(c(rowP,colP)) + 2*log(c(rowP,colP+1));
                dy   = numY/denY;
            else
                dx = 0;
                dy = 0;
            end
        end
        
        % Set the col and row peak values from max of cross-correlation
        colPeak(i,j) = colP + dy;                                           % Column peak location (X)
        rowPeak(i,j) = rowP + dx;                                           % Row peak location (Y)
        
        % Find the pixel offsets for X and Y directions
        colOffset(i,j) = colPeak(i,j) - wSize2 - sSize2 - 1;                % Actual column pixel shift
        rowOffset(i,j) = rowPeak(i,j) - wSize2 - sSize2 - 1;                % Actual row pixel shift
    end
end

% Meshgrid
[RR,CC] = meshgrid(wIndR,wIndC);                                            % Row/column meshgrid
RR      = RR';                                                              % Make it more intuitive to read
CC      = CC';                                                              % Make it more intuitive to read

% Set quiver variable values for ease of viewing
quivX   = CC;                                                               % Quiver X-coordinate
quivY   = RR;                                                               % Quiver Y-coordinate
quivU   = colOffset;                                                        % Quiver U-displacement
quivV   = rowOffset;                                                        % Quiver V-displacement

% Adjust values at the edge
% - Not sure this is the best way to do this
% - If not, just ignore the first row and column of results
quivU(:,1) = quivU(:,1) + 1;
quivV(1,:) = quivV(1,:) + 1;

% Move the countour plot over the image
XX     = quivX - min(min(quivX));
scaleX = rect(3)/max(max(XX));
XX     = XX*scaleX + rect(1);
YY     = quivY - min(min(quivY));
scaleY = rect(4)/max(max(YY));
YY     = YY*scaleY + rect(2);

% Assign relevant variables into base workspace
assignin('base','rect',rect);                                               % Cropping rectangle
assignin('base','quivX',quivX);                                             % X-position
assignin('base','quivY',quivY);                                             % Y-Position
assignin('base','quivU',quivU);                                             % X-displacement
assignin('base','quivV',quivV);                                             % Y-displacement
assignin('base','XX',XX);                                                   % Scaled X-position
assignin('base','YY',YY);                                                   % Scaled Y-position

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');
drawnow();

% PUSH -------------------------- P L O T ---------------------------------
function pushPlot_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Load computed results
% - Plot appropriate figures with different options
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');
drawnow();

% Evaluate in relevant variables
I2Orig  = evalin('base','I2Orig');
rect    = evalin('base','rect');
quivX   = evalin('base','quivX');
quivY   = evalin('base','quivY');
quivU   = evalin('base','quivU');
quivV   = evalin('base','quivV');
XX      = evalin('base','XX');
YY      = evalin('base','YY');

% Get relevant variables
thresh         = str2double(get(handles.editThreshold,'String'));
trans          = str2double(get(handles.editAlpha,'String'));
interpFac      = str2double(get(handles.editInterpolationFactor,'String')); % Interpolation factor
checkPlotVec   = get(handles.checkPlotVelocityVectors,'Value');
checkPlotOrig  = get(handles.checkPlotOrigImgContour,'Value');
checkPlotX     = get(handles.checkPlotXDisplacement,'Value');
checkPlotY     = get(handles.checkPlotYDisplacement,'Value');
checkPlotTotal = get(handles.checkPlotTotalDisplacement,'Value');
popXYTot       = get(handles.popOrigImgXYTot,'Value');                      % Contour to plot on original image
popVal         = get(handles.popColormap,'Value');                          % Selected colormap value
popStrList     = get(handles.popColormap,'String');                         % All colormap strings available
popStr         = popStrList{popVal};                                        % Selected colormap string

% Make sure values aren't complex
quivU   = real(quivU);
quivV   = real(quivV);

% Apply threshold to the quivU and quivV values
quivU(abs(quivU) > thresh) = nan;
quivV(abs(quivV) > thresh) = nan;
quivVel = sqrt(quivU.^2 + quivV.^2);

% Set mask regions (second "thresholding" step)
testVal = sqrt(thresh^2 + thresh^2);
quivU(quivVel   == testVal) = nan;
quivV(quivVel   == testVal) = nan;
quivVel(quivVel == testVal) = nan;

% Save data for CAXIS adjustments in callback: pushSelectRegion_OrigImg_Callback
assignin('base','caxisQuivU',quivU);
assignin('base','caxisQuivV',quivV);
assignin('base','caxisQuivTot',quivVel);

% Interpolate surface data using interpolation factor
if (interpFac ~= 1 && checkPlotVec ~= 1)
    numXXInterp = interpFac*size(XX,2);
    numYYInterp = interpFac*size(YY,1);
    
    XSmooth = linspace(min(XX(1,:)),max(XX(1,:)),numXXInterp);
    YSmooth = linspace(min(YY(:,1)),max(YY(:,1)),numYYInterp);
    [XXPlot,YYPlot] = meshgrid(XSmooth,YSmooth);
    
    if (checkPlotOrig == 1 && popXYTot == 1)
        ZZPlot = interp2(XX,YY,quivU,XXPlot,YYPlot);
    elseif (checkPlotOrig == 1 && popXYTot == 2)
        ZZPlot = interp2(XX,YY,quivV,XXPlot,YYPlot);
    elseif (checkPlotOrig == 1 && popXYTot == 3)
        ZZPlot = interp2(XX,YY,quivVel,XXPlot,YYPlot);
    elseif (checkPlotX == 1)
        ZZPlot = interp2(XX,YY,quivU,XXPlot,YYPlot);
    elseif (checkPlotY == 1)
        ZZPlot = interp2(XX,YY,quivV,XXPlot,YYPlot);
    elseif (checkPlotTotal == 1)
        ZZPlot = interp2(XX,YY,quivVel,XXPlot,YYPlot);
    end
else
    XXPlot = XX;
    YYPlot = YY;
    if (checkPlotOrig == 1 && popXYTot == 1)
        ZZPlot = quivU;
    elseif (checkPlotOrig == 1 && popXYTot == 2)
        ZZPlot = quivV;
    elseif (checkPlotOrig == 1 && popXYTot == 3)
        ZZPlot = quivVel;
    elseif (checkPlotX == 1)
        ZZPlot = quivU;
    elseif (checkPlotY == 1)
        ZZPlot = quivV;
    elseif (checkPlotTotal == 1)
        ZZPlot = quivVel;
    end
end

% FIGURE: Velocity vector quiver
if (checkPlotVec == 1)
    figVelVec = figure(2);
    set(gcf,'Color','White');
    cla; hold on; grid off;
    plot(quivX,quivY,'k.');
    quiver(quivX,quivY,quivU,quivV,'Color','r','LineWidth',2);
    view([0 -90]);
    axis('equal');
    xlabel('X Axis');
    ylabel('Y Axis');
end

% FIGURE: Contour over original image
if (checkPlotOrig == 1)
    figOrigImg = figure(3);
    cla; hold on;
    set(gcf,'Color','White');
    Irgb = cat(3,I2Orig,I2Orig,I2Orig);
    imshow(Irgb);
    rectangle('Position',[rect(1), rect(2), rect(3), rect(4)],...
             'LineWidth',2,'LineStyle','--');
    hold on;
    if (popXYTot == 1)
%         surf(XX,YY,quivU,'EdgeColor','none');
        surf(XXPlot,YYPlot,ZZPlot,'EdgeColor','none');
        caxis([min(min(quivU)) max(max(quivU))]);
    elseif (popXYTot == 2)
%         surf(XX,YY,quivV,'EdgeColor','none');
        surf(XXPlot,YYPlot,ZZPlot,'EdgeColor','none');
        caxis([min(min(quivV)) max(max(quivV))]);
    elseif (popXYTot == 3)
%         surf(XX,YY,quivVel,'EdgeColor','none');
        surf(XXPlot,YYPlot,ZZPlot,'EdgeColor','none');
        caxis([min(min(quivVel)) max(max(quivVel))]);
    end
    colormap(popStr);
    h2 = imshow(Irgb);
    set(h2,'AlphaData',trans);
    
	% Get colormap limits and set to edit textboxes
    cl = caxis;
    set(handles.editCS_OrigImg,'String',num2str(cl(1)));
    set(handles.editCE_OrigImg,'String',num2str(cl(2)));
    set(handles.editCS_OrigImg,'Enable','on');
    set(handles.editCE_OrigImg,'Enable','on');
    set(handles.pushSelectRegion_OrigImg,'Enable','on');                    % Enable pushbutton for region selection
else
    set(handles.editCS_OrigImg,'Enable','off');
    set(handles.editCE_OrigImg,'Enable','off');
    set(handles.pushSelectRegion_OrigImg,'Enable','off');                   % Disable pushbutton for region selection
end

% FIGURE: X-displacement contour
if (checkPlotX == 1)
    figX = figure(4);
    set(gcf,'Color','White');
    cla; hold on; grid off;
%     surf(quivX,quivY,quivU,'EdgeColor','none');
    surf(XXPlot,YYPlot,ZZPlot,'EdgeColor','none');
    colormap(popStr);
    colorbar;
    caxis([min(min(quivU)) max(max(quivU))]);
    view([0 -90]);
    title('X-Displacement');
    axis('equal');

	% Get colormap limits and set to edit textboxes
    cl = caxis;
    set(handles.editCS_X,'String',num2str(cl(1)));
    set(handles.editCE_X,'String',num2str(cl(2)));
    set(handles.editCS_X,'Enable','on');
    set(handles.editCE_X,'Enable','on');
	set(handles.pushSelectRegion_X,'Enable','on');                          % Enable pushbutton for region selection
else
	set(handles.editCS_X,'Enable','off');
    set(handles.editCE_X,'Enable','off');
    set(handles.pushSelectRegion_X,'Enable','off');                         % Disable pushbutton for region selection
end

% FIGURE: Y-displacement contour
if (checkPlotY == 1)
    figY = figure(5);
    set(gcf,'Color','White');
    cla; hold on; grid off;
%     surf(quivX,quivY,quivV,'EdgeColor','none');
    surf(XXPlot,YYPlot,ZZPlot,'EdgeColor','none');
    colormap(popStr);
    colorbar;
    caxis([min(min(quivV)) max(max(quivV))]);
    view([0 -90]);
    title('Y-Displacement');
    axis('equal');

	% Get colormap limits and set to edit textboxes
    cl = caxis;
    set(handles.editCS_Y,'String',num2str(cl(1)));
    set(handles.editCE_Y,'String',num2str(cl(2)));
    set(handles.editCS_Y,'Enable','on');
    set(handles.editCE_Y,'Enable','on');
	set(handles.pushSelectRegion_Y,'Enable','on');                          % Enable pushbutton for region selection
else
    set(handles.editCS_Y,'Enable','off');
    set(handles.editCE_Y,'Enable','off');
    set(handles.pushSelectRegion_Y,'Enable','off');                         % Disable pushbutton for region selection
end

% FIGURE: Total displacement contour
if (checkPlotTotal == 1)
    figTot = figure(6);
    set(gcf,'Color','White');
    cla; hold on; grid off;
	surf(XXPlot,YYPlot,ZZPlot,'EdgeColor','none');
%     surf(quivX,quivY,quivVel,'EdgeColor','none');
    colormap(popStr);
    colorbar;
    caxis([min(min(quivVel)) max(max(quivVel))]);
    view([0 -90]);
    title('Total Displacement');
    axis('equal');
    
	% Get colormap limits and set to edit textboxes
    cl = caxis;
    set(handles.editCS_Tot,'String',num2str(cl(1)));
    set(handles.editCE_Tot,'String',num2str(cl(2)));
    set(handles.editCS_Tot,'Enable','on');
    set(handles.editCE_Tot,'Enable','on');
	set(handles.pushSelectRegion_Tot,'Enable','on');                        % Enable pushbutton for region selection
else
    set(handles.editCS_Tot,'Enable','off');
    set(handles.editCE_Tot,'Enable','off');
    set(handles.pushSelectRegion_Tot,'Enable','off');                       % Disable pushbutton for region selection
end

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');
drawnow();

% PUSH ------------ Select Color Axis Region: Original Image --------------
function pushSelectRegion_OrigImg_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Select appropriate plot
% - Select region on plot and scale the color axis
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');
drawnow();

% Select appropriate figure
figure(3);

% Get rectangle crop bounding points
rect = evalin('base','rect');

% Get the contour that is being plotted
thresh   = str2double(get(handles.editThreshold,'String'));
popXYTot = get(handles.popOrigImgXYTot,'Value');

% User selects a rectangle area (2 points)
[xSel,ySel] = ginput(2);
xSel        = xSel - rect(1);                                               % Account for ROI rectangle location
ySel        = ySel - rect(2);                                               % Account for ROI rectangle location

% Load appropriate data (saved from plotting callback)
quivX   = evalin('base','quivX');
quivY   = evalin('base','quivY');
if (popXYTot == 1)
    quiv = evalin('base','caxisQuivU');
elseif (popXYTot == 2)
    quiv = evalin('base','caxisQuivV');
elseif (popXYTot == 3)
    quiv = evalin('base','caxisQuivTot');
end

% Find row values of selected points in plot
if (xSel(1) < min(min(quivX)))
    rInd(1) = 1;
else
    rInd(1) = min(find((quivX(1,:)-xSel(1))>0));
end
if (xSel(2) > max(max(quivX)))
    rInd(2) = length(quivX(1,:));
else
    rInd(2) = min(find((quivX(1,:)-xSel(2))>0));
end

% Find column values of selected points in plot
if (ySel(1) < min(min(quivY)))
    cInd(1) = 1;
else
    cInd(1) = min(find((quivY(:,1)-ySel(1))>0));
end
if (ySel(2) > max(max(quivY)))
    cInd(2) = length(quivY(:,1));
else
    cInd(2) = min(find((quivY(:,1)-ySel(2))>0));
end

% Find min and max of the sub-region
smallQuiv        = quiv(cInd(1):cInd(2),rInd(1):rInd(2));                   % Create smaller matrix
[r,c]            = size(smallQuiv);                                         % Get size of smaller matrix
sizeRegion       = r*c;                                                     % Get total number of elements
[counts,centers] = hist(smallQuiv(:),50);                                   % Get 50 bin histogram
retain           = centers(counts >= 0.01*sizeRegion);                      % Only keep values above threshold
cMin             = min(retain);                                             % Get minimum pixel displacement
cMax             = max(retain);                                             % Get maximum pixel displacement

% Set the caxis limits of the plot
figure(3);
caxis([cMin cMax]);
set(handles.editCS_OrigImg,'String',num2str(cMin));
set(handles.editCE_OrigImg,'String',num2str(cMax));
drawnow();

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');
drawnow();

% PUSH ------------ Select Color Axis Region: X Displacement --------------
function pushSelectRegion_X_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Select appropriate plot
% - Select region on plot and scale the color axis
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');
drawnow();

% Select appropriate figure
figure(4);

% Get rectangle crop bounding points
rect = evalin('base','rect');

% User selects a rectangle area (2 points)
[xSel,ySel] = ginput(2);
xSel = xSel - rect(1);
ySel = ySel - rect(2);

% Load appropriate data (saved from plotting callback)
quivX = evalin('base','quivX');
quivY = evalin('base','quivY');
quivU = evalin('base','caxisQuivU');

% Find row values of selected points in plot
if (xSel(1) < min(min(quivX)))
    rInd(1) = 1;
else
    rInd(1) = min(find((quivX(1,:)-xSel(1))>0));
end
if (xSel(2) > max(max(quivX)))
    rInd(2) = length(quivX(1,:));
else
    rInd(2) = min(find((quivX(1,:)-xSel(2))>0));
end

% Find column values of selected points in plot
if (ySel(1) < min(min(quivY)))
    cInd(1) = 1;
else
    cInd(1) = min(find((quivY(:,1)-ySel(1))>0));
end
if (ySel(2) > max(max(quivY)))
    cInd(2) = length(quivY(:,1));
else
    cInd(2) = min(find((quivY(:,1)-ySel(2))>0));
end

% Find min and max of the sub-region
smallQuiv        = quivU(cInd(1):cInd(2),rInd(1):rInd(2));                  % Create smaller matrix
[r,c]            = size(smallQuiv);                                         % Get size of smaller matrix
sizeRegion       = r*c;                                                     % Get total number of elements
[counts,centers] = hist(smallQuiv(:),50);                                   % Get 50 bin histogram
retain           = centers(counts >= 0.01*sizeRegion);                      % Only keep values above threshold
cMin             = min(retain);                                             % Get minimum pixel displacement
cMax             = max(retain);                                             % Get maximum pixel displacement

% Set the caxis limits of the plot
figure(4);
if (cMin ~= cMax)
    caxis([cMin cMax]);
end
set(handles.editCS_X,'String',num2str(cMin));
set(handles.editCE_X,'String',num2str(cMax));
drawnow();

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');
drawnow();

% PUSH ------------ Select Color Axis Region: Y Displacement --------------
function pushSelectRegion_Y_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Select appropriate plot
% - Select region on plot and scale the color axis
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');
drawnow();

% Select appropriate figure
figure(5);

% Get rectangle crop bounding points
rect = evalin('base','rect');

% User selects a rectangle area (2 points)
[xSel,ySel] = ginput(2);
xSel = xSel - rect(1);
ySel = ySel - rect(2);

% Load appropriate data (saved from plotting callback)
quivX = evalin('base','quivX');
quivY = evalin('base','quivY');
quivV = evalin('base','caxisQuivV');

% Find row values of selected points in plot
if (xSel(1) < min(min(quivX)))
    rInd(1) = 1;
else
    rInd(1) = min(find((quivX(1,:)-xSel(1))>0));
end
if (xSel(2) > max(max(quivX)))
    rInd(2) = length(quivX(1,:));
else
    rInd(2) = min(find((quivX(1,:)-xSel(2))>0));
end

% Find column values of selected points in plot
if (ySel(1) < min(min(quivY)))
    cInd(1) = 1;
else
    cInd(1) = min(find((quivY(:,1)-ySel(1))>0));
end
if (ySel(2) > max(max(quivY)))
    cInd(2) = length(quivY(:,1));
else
    cInd(2) = min(find((quivY(:,1)-ySel(2))>0));
end

% Find min and max of the sub-region
smallQuiv        = quivV(cInd(1):cInd(2),rInd(1):rInd(2));                  % Create smaller matrix
[r,c]            = size(smallQuiv);                                         % Get size of smaller matrix
sizeRegion       = r*c;                                                     % Get total number of elements
[counts,centers] = hist(smallQuiv(:),50);                                   % Get 50 bin histogram
retain           = centers(counts >= 0.01*sizeRegion);                      % Only keep values above threshold
cMin             = min(retain);                                             % Get minimum pixel displacement
cMax             = max(retain);                                             % Get maximum pixel displacement

% Set the caxis limits of the plot
figure(5);
if (cMin ~= cMax)
    caxis([cMin cMax]);
end
set(handles.editCS_Y,'String',num2str(cMin));
set(handles.editCE_Y,'String',num2str(cMax));
drawnow();

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');
drawnow();

% PUSH ---------- Select Color Axis Region: Total Displacement ------------
function pushSelectRegion_Tot_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Select appropriate plot
% - Select region on plot and scale the color axis
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');
drawnow();

% Select appropriate figure
figure(6);

% Get rectangle crop bounding points
rect = evalin('base','rect');

% User selects a rectangle area (2 points)
[xSel,ySel] = ginput(2);                                                    % User clicks twice on plot
xSel = xSel - rect(1);                                                      % Account for cropped region
ySel = ySel - rect(2);                                                      % Account for cropped region

% Load appropriate data (saved from plotting callback)
quivX   = evalin('base','quivX');
quivY   = evalin('base','quivY');
quivVel = evalin('base','caxisQuivTot');

% Find row values of selected points in plot
if (xSel(1) < min(min(quivX)))
    rInd(1) = 1;
else
    rInd(1) = min(find((quivX(1,:)-xSel(1))>0));
end
if (xSel(2) > max(max(quivX)))
    rInd(2) = length(quivX(1,:));
else
    rInd(2) = min(find((quivX(1,:)-xSel(2))>0));
end

% Find column values of selected points in plot
if (ySel(1) < min(min(quivY)))
    cInd(1) = 1;
else
    cInd(1) = min(find((quivY(:,1)-ySel(1))>0));
end
if (ySel(2) > max(max(quivY)))
    cInd(2) = length(quivY(:,1));
else
    cInd(2) = min(find((quivY(:,1)-ySel(2))>0));
end

% Find min and max of the sub-region
smallQuiv        = quivVel(cInd(1):cInd(2),rInd(1):rInd(2));                % Create smaller matrix
[r,c]            = size(smallQuiv);                                         % Get size of smaller matrix
sizeRegion       = r*c;                                                     % Get total number of elements
[counts,centers] = hist(smallQuiv(:),50);                                   % Get 50 bin histogram
retain           = centers(counts >= 0.01*sizeRegion);                      % Only keep values above threshold
cMin             = min(retain);                                             % Get minimum pixel displacement
cMax             = max(retain);                                             % Get maximum pixel displacement

% Set the caxis limits of the plot
figure(6);
if (cMin ~= cMax)
    caxis([cMin cMax]);
end
set(handles.editCS_Tot,'String',num2str(cMin));
set(handles.editCE_Tot,'String',num2str(cMax));
drawnow();

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');
drawnow();

% PUSH ----------------- VIDEO: Select Video Directory --------------------
function pushSelectVideoDirectory_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Use selects the directory from which to load all images
% - This is also the path where the video will be saved
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');                   % Change colors of pushbutton
drawnow();

v_flpth = uigetdir('C:\Users\Josh\Documents\DIY_BOS\',...
                   'Select Folder with Images');
               
% v_flpth = uigetdir('C:\Users\Josh\Documents\YouTube_Files\AAA_DIY_BOS\',...
%                    'Select Folder with Images');
v_flpth = [v_flpth '\'];
fprintf('Video directory: %s\n',v_flpth);

% Assign variables into base workspace
assignin('base','v_flpth',v_flpth);

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');   % Set colors back to normal
drawnow();

% PUSH ---------------------- VIDEO: Compute Video ------------------------
function pushComputeVideo_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - 
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');                   % Change colors of pushbutton
drawnow();

% Get relevant variables
v_sFrame      = str2double(get(handles.editStartingFrame,'String'));
v_numFrames   = str2double(get(handles.editNumFrames,'String'));
v_wSize       = str2double(get(handles.editWSize,'String'));
v_sSize       = str2double(get(handles.editSSize,'String'));
v_thresh      = str2double(get(handles.editThreshold,'String'));

v_chkUseRawBGAsBG         = get(handles.checkUseRawBGAsBG,'Value');
v_chkUsePreviousImageAsBG = get(handles.checkUsePreviousImageAsBG,'Value');

% Load relevant variables from base workspace
v_flpth = evalin('base','v_flpth');

% Get raw image file names ready
fileRaw = cell(v_numFrames,1);                                              % Initialize raw image cell array
for m = 1:1:v_numFrames                                                     % Loop over all images
    if (m+v_sFrame-1 < 10)                                                  % If image number is single digit (based on ImageJ output)
        fileRaw{m} = ['Raw_0' num2str(m+v_sFrame-1) '.tif'];                % Set appropriate filename
    else                                                                    % If image number is double digit (based on ImageJ output)
        fileRaw{m} = ['Raw_' num2str(m+v_sFrame-1) '.tif'];                 % Set appropriate filename
    end
end

% Load Raw_BG file is user wants to
if (v_chkUseRawBGAsBG == 1)
    fileBG = 'Raw_BG.tif';
    I_BG   = imread([v_flpth fileBG]);
    I_BG   = I_BG(:,:,1);
    IOrig_BG  = I_BG;                                                       % Save original background image
end

% Load RAW images
for i = 1:1:v_numFrames                                                     % Loop over all images
    I_RAW{i} = imread([v_flpth fileRaw{i}]);                                % Read the raw image
    I_RAW{i} = I_RAW{i}(:,:,1);                                             % Flatten image if necessary
end
IOrig_RAW = I_RAW;                                                          % Save all original raw images

% Crop the image
try
    figure(1);
    imgComp = imfuse(I_RAW{1},I_RAW{v_numFrames},'blend');
    [~,rect] = imcrop(imgComp);
    % [~,rect] = imcrop(I_RAW{2});                                          % Define crop region from first raw image
    close(1);
    pause(0.25);
catch
    fprintf('User canceled...try again\n');
    % Set button colors
    set(hObject,'BackgroundColor',[0.941 0.941 0.941],...                   % Set colors back to normal
                'ForegroundColor','k');
    drawnow();
    return;
end

% Crop RAW
for i = 1:1:v_numFrames                                                     % Loop through all raw images
    I_RAW{i} = imcrop(I_RAW{i},rect);                                       % Crop every raw image and overwrite image
end

% Crop BG
if (v_chkUseRawBGAsBG == 1)
    I_BG = imcrop(I_BG,rect);
end

numRows_I = size(I_RAW{1},1);                                               % Number of rows in cropped background image
numCols_I = size(I_RAW{1},2);                                               % Number of columns in cropped background image

% Window and search half-sizes
wSize2 = floor(v_wSize/2);                                                  % Half of window size
sSize2 = floor(v_sSize/2);                                                  % Half of search size

% Window centers
wIndR = (v_wSize:v_wSize:(numRows_I-wSize2))';                              % Window center locations for each row
wIndC = (v_wSize:v_wSize:(numCols_I-wSize2))';                              % Window center locations for each column

numR  = length(wIndR);                                                      % Number of rows
numC  = length(wIndC);                                                      % Number of columns

% Initialize variables
colPeak   = cell(v_numFrames,1);                                            % Initialize relative column peak
rowPeak   = cell(v_numFrames,1);                                            % Initialize relative row peak
colOffset = cell(v_numFrames,1);                                            % Initialize absolute column offset
rowOffset = cell(v_numFrames,1);                                            % Initialize absolute row offset

% Loop over all raw images and perform cross-correlation
for m = 1:1:v_numFrames                                                     % Loop over all raw images
    iterStr = ['Iteration: ' num2str(m) '/' num2str(v_numFrames)];
    set(handles.textVideoIteration,'String',iterStr);
    drawnow();
    for i = 1:1:numR                                                        % Loop over all window row centers
        for j = 1:1:numC                                                    % Loop over all window column centers
            % Get window centers
            rowCenter = wIndR(i);                                           % Window row center
            colCenter = wIndC(j);                                           % Window column center
            
            % Crop the image to WINDOW size
            % - [col start, row start, col nums, row nums]
            cropI1 = [colCenter-wSize2, rowCenter-wSize2, v_wSize, v_wSize]; % Define cropping rectangle for image 1
            if (v_chkUseRawBGAsBG == 1)
                I1_Sub  = imcrop(I_BG,cropI1);
            elseif (v_chkUsePreviousImageAsBG == 1)
                if (m == 1)
                    I1_Sub = imcrop(I_RAW{1},cropI1);
                else
                    I1_Sub = imcrop(I_RAW{m-1},cropI1);
                end
            end
            
            % Crop the template to SEARCH size
            % - [col start, row start, col nums, row nums]
            cropI2 = [colCenter-sSize2, rowCenter-sSize2, v_sSize, v_sSize]; % Define cropping rectangle for image 2
            I2_Sub = imcrop(I_RAW{m},cropI2);                               % Crop image 2 (comparison)
            
            % Compute normalized cross correlation
            if (all(I1_Sub == I1_Sub(1,1)))                                 % If "window" array values are all the same
                rowP = 0;                                                   % No row offset
                colP = 0;                                                   % No column offset
                dx   = 0;
                dy   = 0;
            else
                % Compute normalized cross-correlation
                c = normxcorr2(I1_Sub,I2_Sub);                              % Normalized cross correlation
                [cR,cC] = size(c);

                % Find the peak indices of the cross-correlation map
                [rowP,colP] = find(c == max(c(:)));                         % Maximum indices of cross-correlation map
                rowP = rowP(1);
                colP = colP(1);
                if (rowP == 1) rowP = rowP + 1; end
                if (rowP == cR) rowP = rowP - 1; end
                if (colP == 1) colP = colP + 1; end
                if (colP == cC) colP = colP - 1; end

                % Sub-pixel displacement using three-point Gaussian
                numX = log(c(rowP-1,colP)) - log(c(rowP+1,colP));
                denX = 2*log(c(rowP-1,colP)) - 4*log(c(rowP,colP)) + 2*log(c(rowP+1,colP));
                dx   = numX/denX;
                numY = log(c(rowP,colP-1)) - log(c(rowP,colP+1));
                denY = 2*log(c(rowP,colP-1)) - 4*log(c(rowP,colP)) + 2*log(c(rowP,colP+1));
                dy   = numY/denY;
            end

            % Set the col and row peak values from max of cross-correlation
            colPeak{m}(i,j) = colP + dy;
            rowPeak{m}(i,j) = rowP + dx;
            
            % Find the pixel offsets for X and Y directions
            colOffset{m}(i,j) = colPeak{m}(i,j) - wSize2 - sSize2 - 1;      % Actual column pixel shift
            rowOffset{m}(i,j) = rowPeak{m}(i,j) - wSize2 - sSize2 - 1;      % Actual row pixel shift
        end
    end
end

% Apply threshold to the row/col offset values
for m = 1:1:v_numFrames                                                     % Loop over all raw images
    cO                     = colOffset{m};                                  % Get this image's colOffset
    rO                     = rowOffset{m};                                  % Get this image's rowOffset
    cO(abs(cO) > v_thresh) = nan;                                           % Apply the min/max value threshold
    rO(abs(rO) > v_thresh) = nan;                                           % Apply the min/max value threshold
    colOffset{m}           = cO;                                            % Overwrite colOffset with thresholded values
    rowOffset{m}           = rO;                                            % Overwrite rowOffset with thresholded values
end

% Meshgrid
[RR,CC] = meshgrid(wIndR,wIndC);                                            % Row/column meshgrid
RR      = RR';                                                              % Make it more intuitive to read
CC      = CC';                                                              % Make it more intuitive to read

quivX = CC;                                                                 % Set quivX
quivY = RR;                                                                 % Set quivY
quivU   = cell(v_numFrames,1);
quivV   = cell(v_numFrames,1);
quivVel = cell(v_numFrames,1);                                              % Initialize quivVel
for m = 1:1:v_numFrames                                                     % Loop over all raw images
    quivU{m} = colOffset{m};
    quivV{m} = rowOffset{m};
    quivU{m}(:,1) = quivU{m}(:,1) + 1;                                      % Adjust first row
    quivV{m}(1,:) = quivV{m}(1,:) + 1;                                      % Adjust first column
    quivVel{m}    = sqrt(quivU{m}.^2 + quivV{m}.^2);                        % Set the image's quivVel
end

% Set mask regions
testVal = sqrt(v_thresh^2 + v_thresh^2);                                    % Get test value for final thresholding
for m = 1:1:v_numFrames                                                     % Loop over all raw images
    u                   = quivU{m};
    v                   = quivV{m};
    vel                 = quivVel{m};
    u(u == testVal)     = nan;
    v(v == testVal)     = nan;
    vel(vel == testVal) = nan;
    quivU{m}            = u;
    quivV{m}            = v;
    quivVel{m}          = vel;
end

% Move the countour plot over the image
XX     = quivX - min(min(quivX));
scaleX = rect(3)/max(max(XX));
XX     = XX*scaleX + rect(1);
YY     = quivY - min(min(quivY));
scaleY = rect(4)/max(max(YY));
YY     = YY*scaleY + rect(2);

% Assign variables into base workspace
assignin('base','v_numFrames',v_numFrames);
assignin('base','v_IOrig_RAW',IOrig_RAW);
assignin('base','v_XX',XX);
assignin('base','v_YY',YY);
assignin('base','v_quivVel',quivVel);
assignin('base','v_rect',rect);

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');   % Set colors back to normal
drawnow();

% PUSH -------------------- VIDEO: Assemble Frames ------------------------
function pushAssembleFrames_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Load final data for all frames
% - Plot all images and save frames
% - Output frames to a movie with desired frame rate
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');                   % Change colors of pushbutton
drawnow();

% Get relevant variables
v_CMin      = str2double(get(handles.editCMin,'String'));
v_CMax      = str2double(get(handles.editCMax,'String'));
v_trans     = str2double(get(handles.editAlpha,'String'));

% Load relevant variables from base workspace
v_IOrig_RAW = evalin('base','v_IOrig_RAW');
v_numFrames = evalin('base','v_numFrames');
v_rect      = evalin('base','v_rect');
v_XX        = evalin('base','v_XX');
v_YY        = evalin('base','v_YY');
v_quivVel   = evalin('base','v_quivVel');

% Plot and save image frames
for m = 2:1:v_numFrames                                                     % Loop over all raw images
    f(m) = figure(m+1);                                                     % Select appropriate figure
    cla; hold on;                                                           % Get ready for plotting
    set(gcf,'Color','White');                                               % Set figure background color to white
    Irgb = cat(3,v_IOrig_RAW{m},v_IOrig_RAW{m},v_IOrig_RAW{m});             % Get the original uncropped raw image
    imshow(Irgb);                                                           % Plot the original uncropped raw image
    rectangle('Position',[v_rect(1), v_rect(2), v_rect(3), v_rect(4)],...   % Plot the crop-region rectangle bounds
             'LineWidth',2,'LineStyle','--');
    hold on;                                                                % Hold on
    h1 = surf(v_XX,v_YY,real(v_quivVel{m}),'EdgeColor','none');             % Plot total displacement in crop-region
    h2 = imshow(Irgb);                                                      % Show the original image on top of surface plot
    set(h2, 'AlphaData', v_trans);                                          % Set the original image transparency (alpha)
    if (v_CMin == 0 && v_CMax == 0)                                         % If both limits are set to zero
        caxis('auto');                                                      % Auto-set the color axis limits
    else
        caxis([v_CMin v_CMax]);                                             % Set the color axis limits
    end
    pause(0.5);                                                             % Pause to allow image to be drawn correctly
    v_F(m-1) = getframe(gcf);                                               % Get the current frame
    close(f(m));
end

% Save relevant variables to base workspace
assignin('base','v_F',v_F);                                                     % Assembled frames for saving

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');   % Set colors back to normal
drawnow();

% PUSH --------------------- VIDEO: Save Movie File -----------------------
function pushVideoSaveMovie_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Load saved frames
% - Output video with appropriate file name and frame rate
% -------------------------------------------------------------------------

% Set button colors
set(hObject,'BackgroundColor','k','ForegroundColor','w');                   % Change colors of pushbutton
drawnow();

% Get relevant variables
v_frameRate = str2double(get(handles.editFrameRate,'String'));
v_movieName = get(handles.editMovieName,'String');

% Load relevant variables from base workspace
v_flpth = evalin('base','v_flpth');
v_F     = evalin('base','v_F');

% Write video
v = VideoWriter([v_flpth v_movieName]);                                     % Create VideoWriter object with movie name
v.FrameRate = v_frameRate;                                                  % Set the frame rate
open(v);                                                                    % Open the video
writeVideo(v,v_F);                                                            % Write the frames to the video
close(v);                                                                   % Close the video

% Set button colors
set(hObject,'BackgroundColor',[0.0431 0.5176 0.7804],'ForegroundColor','w');   % Set colors back to normal
drawnow();

% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-
% -- EDIT -- EDIT -- EDIT -- EDIT -- EDIT -- EDIT -- EDIT -- EDIT -- EDIT -
% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-

% EDIT ------------------------ Window Size -------------------------------
function editWSize_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT --------------------- Search Window Size ---------------------------
function editSSize_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT -------------------------- Threshold -------------------------------
function editThreshold_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT ----------------- Contour Image Transparency -----------------------
function editAlpha_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT -------------------- Interpolation Factor --------------------------
function editInterpolationFactor_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT ------------ Color Axis Start Value: Original Image ----------------
function editCS_OrigImg_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_OrigImg,'String'));                    % Get minimum value
cMax = str2double(get(handles.editCE_OrigImg,'String'));                    % Get maximum value

% Set the color axis limits
figure(3);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ------------- Color Axis End Value: Original Image -----------------
function editCE_OrigImg_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_OrigImg,'String'));                    % Get minimum value
cMax = str2double(get(handles.editCE_OrigImg,'String'));                    % Get maximum value

% Set the color axis limits
figure(3);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ------------ Color Axis Start Value: X Displacement ----------------
function editCS_X_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_X,'String'));                          % Get minimum value
cMax = str2double(get(handles.editCE_X,'String'));                          % Get maximum value

% Set the color axis limits
figure(4);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ------------- Color Axis End Value: X Displacement -----------------
function editCE_X_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_X,'String'));                          % Get minimum value
cMax = str2double(get(handles.editCE_X,'String'));                          % Get maximum value

% Set the color axis limits
figure(4);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ------------ Color Axis Start Value: Y Displacement ----------------
function editCS_Y_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_Y,'String'));                          % Get minimum value
cMax = str2double(get(handles.editCE_Y,'String'));                          % Get maximum value

% Set the color axis limits
figure(5);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ------------- Color Axis End Value: Y Displacement -----------------
function editCE_Y_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_Y,'String'));                          % Get minimum value
cMax = str2double(get(handles.editCE_Y,'String'));                          % Get maximum value

% Set the color axis limits
figure(5);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ---------- Color Axis Start Value: Total Displacement --------------
function editCS_Tot_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_Tot,'String'));                        % Get minimum value
cMax = str2double(get(handles.editCE_Tot,'String'));                        % Get maximum value

% Set the color axis limits
figure(6);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ----------- Color Axis End Value: Total Displacement ---------------
function editCE_Tot_Callback(hObject, eventdata, handles)

% Adjust the color axis limits based on edit text boxes
cMin = str2double(get(handles.editCS_Tot,'String'));                        % Get minimum value
cMax = str2double(get(handles.editCE_Tot,'String'));                        % Get maximum value

% Set the color axis limits
figure(6);                                                                  % Select appropriate plot
try
    caxis([cMin cMax]);                                                     % Set caxis limits
catch
    fprintf('Enter a valid number\n');                                      % If number wasn't valid
end
drawnow();

% EDIT ----------------------- VIDEO: Frame Rate --------------------------
function editFrameRate_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT ----------------------- VIDEO: Movie Name --------------------------
function editMovieName_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT ------------------- VIDEO: Starting Frame --------------------------
function editStartingFrame_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT -------------------- VIDEO: Ending Frame ---------------------------
function editNumFrames_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT ------------------- VIDEO: CAxis Max Value -------------------------
function editCMax_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% EDIT ------------------- VIDEO: CAxis Min Value -------------------------
function editCMin_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-
% -- CHECK -- CHECK -- CHECK -- CHECK -- CHECK -- CHECK -- CHECK -- CHECK -
% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-

% CHECK ---------------------- Select Sub-Region --------------------------
function checkSelectSubRegion_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK ------------------- Use Sub-Pixel Resolution ----------------------
function checkSubPixelResolution_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK ----------------- Plot: Displacement Vectors ----------------------
function checkPlotVelocityVectors_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK -------------- Plot: Original Image with Contour ------------------
function checkPlotOrigImgContour_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK -------------------- Plot: X-Displacement -------------------------
function checkPlotXDisplacement_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK -------------------- Plot: Y-Displacement -------------------------
function checkPlotYDisplacement_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK ------------------ Plot: Total Displacement -----------------------
function checkPlotTotalDisplacement_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% CHECK -------------------- Use Raw_BG File as BG ------------------------
function checkUseRawBGAsBG_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Get value of this checkbox
% - Set the other checkbox to the opposite setting
% -------------------------------------------------------------------------

% Get value of this checkbox
checkVal = get(hObject,'Value');

if (checkVal == 1)
    set(handles.checkUsePreviousImageAsBG,'Value',0);
else
    set(handles.checkUsePreviousImageAsBG,'Value',1);
end

% CHECK ---------------- VIDEO: Use Previous Image as BG ------------------
function checkUsePreviousImageAsBG_Callback(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% - Get value of this checkbox
% - Set the other checkbox to the opposite setting
% -------------------------------------------------------------------------

% Get value of this checkbox
checkVal = get(hObject,'Value');

if (checkVal == 1)
    set(handles.checkUseRawBGAsBG,'Value',0);
else
    set(handles.checkUseRawBGAsBG,'Value',1);
end


% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-
% -- POP -- POP -- POP -- POP -- POP -- POP -- POP -- POP -- POP -- POP -- 
% --//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-

% POP ----------------------- Colormap Selection --------------------------
function popColormap_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks

% POP ---------------- Contour for Original Image Contour -----------------
function popOrigImgXYTot_Callback(hObject, eventdata, handles)
% Do nothing, gets used in other callbacks
