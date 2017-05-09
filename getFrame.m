%%
addpath('webcam/');

files = dir('webcam/**');
warning('off','all');
warning('query','all');
%disp(files);

%%
for file = files'
     disp(file.name);
     %imshow(strcat(file.folder,'/',file.name));
     %O4 = imread(strcat(file.folder,'/',file.name));
     O4 = imread(file.name);
     a = rgb2gray(O4);
     %imshow(a);
     %AndrewCode;
     pause(.5);
end









%%
cam = webcam;
%% snapshot
vid = videoinput('macVideo'); 
img = getsnapshot(vid);
imshow(img);
%%
clear('cam');
%%
vid = videoinput('macvideo', 1, 'YCbCr422_1280x720');
src = getselectedsource(vid);
start(vid);



