close all; clear; clc

% info = imaqhwinfo('winvideo',1)
% wbc = webcamlist
sjcam = videoinput('winvideo',2,'MJPG_1280x720');
preview(sjcam)

a = arduino('COM5','Uno');
s = servo(a, 'D10');
% image(frame);
writePosition(s, 1/2);
meanX = 1000;
pause(2)
frame = getsnapshot(sjcam);
image(frame)
[yi, xi, but] = ginput(1);
xi = round(xi); yi = round(yi); 
redR = frame(xi,yi,1);
greenR = frame(xi,yi,2);
blueR = frame(xi,yi,3);
while true
    frame = getsnapshot(sjcam);
    red = frame(:,:,1);
    green = frame(:,:,2);
    blue = frame(:,:,3);
    [y, x] = find(abs(double(red)-double(redR))<10 & abs(double(green)-double(greenR))<10 & abs(double(blue)-double(blueR))<10);
    pixCount = length(x);
    current_pos = readPosition(s)*180;
    
    pause(0.1)
    meanX = mean(x);
    fprintf('%8.4f \n',meanX);
    if meanX>750 && current_pos>10
        inp = current_pos-5;
        writePosition(s, inp/180);
    elseif meanX<500 && current_pos<170
        inp = current_pos+5;
        writePosition(s, inp/180);
    end
end
% preview(info)
% laptopCam = webcam();
% img = snapshot(laptopCam);
% preview(laptopCam);
faceDetector = vision.CascadeObjectDetector();