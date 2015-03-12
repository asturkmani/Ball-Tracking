function realVideo()
ballLog = [];
% Define frame rate
NumberFrameDisplayPerSecond=10;
 
% Open figure
hFigure=figure(1);
 
% Set-up webcam video input
try
   % For windows
   vid = videoinput('winvideo', 1);
catch
   try
      % For macs.
      vid = videoinput('macvideo', 1);
   catch
      errordlg('No webcam available');
   end
end
 
% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',1);
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
% Get a grayscale image
set(vid,'ReturnedColorSpace','rgb');
triggerconfig(vid, 'Manual');
 
% set up timer object
TimerData=timer('TimerFcn', {@FrameRateDisplay,vid},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
 
% Start video and timer object
start(vid);
start(TimerData);
 
% We go on until the figure is closed
uiwait(hFigure);
 
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
clear functions;
 
% This function is called by the timer to display one frame of the figure
 
function FrameRateDisplay(obj, event,vid)
persistent IM;
persistent handlesRaw;
persistent handlesPlot;
trigger(vid);

IM=getdata(vid,1,'uint8');
IM = imresize(IM,0.25);
rgbImage = repmat(IM,[1 1 3]);
rgbImage = cat(3,IM,IM,IM);
IM = rgbImage;
load('ball.mat');

minRed = min(min(ball(:,:,1)));
maxRed = max(max(ball(:,:,1)));
    data = zeros(10000,2);
    count = 1;
    current = IM;
    currentSize = size(IM);
    for i = 10 : currentSize(1) - 10
        for j = 10 : currentSize(2) - 10
            if current(i,j,1) > minRed + 20 && current(i,j,1) < maxRed + 20
                data(count,:) = [i j];
                count = count + 1;
            end
        end
    end
        
    data = data(1:count - 1,:);
    M =  10000000 * ones(currentSize(1:2));
    
    for i = 1:size(data,1)
        M(data(i,1),data(i,2)) = sum(sum(sum(current(data(i,1)-5:data(i,1)+5,data(i,2)-5:data(i,2)+5,:) - ball(:,:,:)).^2));
    end

    [maxR,indexR] = min(M);             % a = minimum in each row, b = index of minimum (row)
    [maxC,indexC] = min(maxR);          % c = minimum in picture, d = index of minimum (column) 
    load('BallLog.mat');
    jj = size(ballLog,1);
    ballLog(jj+1,:) = [indexC, indexR(indexC)]  % x and y coordinate of ball
    save('BallLog.mat','ballLog');
 
if isempty(handlesRaw)
   % if first execution, we create the figure objects
   subplot(2,1,1);
   handlesRaw=imagesc(IM);
   title('CurrentImage');
 
   % Plot first value
   Values=mean(IM(:));
   subplot(2,1,2);
   handlesPlot=plot(Values);
   title('Average of Frame');
   xlabel('Frame number');
   ylabel('Average value (au)');
else
   % We only update what is needed
   set(handlesRaw,'CData',IM);
   Value=mean(IM(:));
   OldValues=get(handlesPlot,'YData');
   set(handlesPlot,'YData',[OldValues Value]);
end
