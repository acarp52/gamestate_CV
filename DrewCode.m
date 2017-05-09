%% Differencer

%imshow(I); % Blank Board
%imshow(J); % Board with Pieces
I = rgb2gray(I);
J = rgb2gray(J);
%%
% This gets the black pieces
K = I - J;
imshow(K);

% This gets the white pieces
W = J - I;
imshow(W);

%% cleaning up the black pieces image
K2 = imadjust(K,[0.1 0.4],[]); 
imshow(K2);

% delete horizontal lines
seh = strel('line', 1,90);
k = imdilate(K2, seh);
% delete verticle lines
sev = strel('line', 1,0);
kk = imdilate(k, sev);
imshow(kk);
K3 =kk;
%% finding pieces

% disk for erosion
seW = strel('disk',15);
seK = strel('ball',30,30);


% % erosion
gw = imerode(W, seW);
gk = imerode(K3, seK);
imshow(gk);

% dilate
gwd = imdilate(gw, seW);
gkd = imdilate(gk, seK);
imshow(gkd);

pw = imbinarize(gwd);
pk = imbinarize(gkd);
imshow(pk);

%pw = imfill(pw, 8, 'holes');
%pk = imfill(pk, 8, 'holes');
%imshow(p);

% find all pieces in image 
cw = bwlabel(pw);
ck = bwlabel(pk);
imshow(ck);

[rw, colw] = find(cw==4);
rcw = [rw colw];

[rk, colk] = find(ck==4);
rck = [rk colk];

% colorful graph showing the different pieces
mw = label2rgb(cw);
imshow(mw);

mk = label2rgb(ck);
imshow(mk);

% this gets the count on objects in image!
[cw, whitePieces] = bwlabel(cw);
[ck, blackPieces] = bwlabel(ck);

% temporary fix
% blackPieces2 = (blackPieces / 4);
%% displaying total White and Black pieces 
disp(sprintf('White pieces is: %d', whitePieces));
disp(sprintf('Black pieces is: %d', blackPieces));
%%
% show the original image
imshow(J);

% loop to get circles on the image
for i = 1:whitePieces
    % White
    statsW = regionprops(cw, 'BoundingBox', 'Centroid', 'MajorAxisLength' ,'MinorAxisLength');
    rc1 = statsW(i).BoundingBox;
    centersW = statsW(i).Centroid;
    diametersW = mean([statsW.MajorAxisLength statsW.MinorAxisLength],2);
    radiiW = diametersW/2;
    viscircles(centersW,radiiW,'color', 'g');
end

  for i = 1:blackPieces  
    % Black
    statsK = regionprops(ck, 'BoundingBox', 'Centroid', 'MajorAxisLength' ,'MinorAxisLength');
    rc2 = statsK(i).BoundingBox;
    centersK = statsK(i).Centroid;
    diametersK = mean([statsK.MajorAxisLength statsK.MinorAxisLength],2);
    radiiK = diametersK/2;
    viscircles(centersK,radiiK,'color', 'w');
  end