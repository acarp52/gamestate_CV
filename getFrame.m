%% snapshot
vid = videoinput('winvideo'); 
img = getsnapshot(vid);
I = img;
%%
imaqInfo = imaqhwinfo
imaqInfo.InstalledAdaptors
hwInfo = imaqhwinfo('winvideo')




%%
% Access an image acquisition device.
vidobj = videoinput('dt', 1, 'RS170')
% Access the device's video sources that can be used for acquisition.
sources = vidobj.Source

vidobj.SelectedSourceName = 'VID2')

% Notice that the corresponding video source has been selected.
sources

selectedsrc = getselectedsource(vidobj)

% List the video source object's properties and their current values.
get(selectedsrc)

