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
%% finding pieces

% disk for erosion
se = strel('disk',2);

% erosion
gw = imerode(W, se);
gk = imerode(K, se);
%imshow(g);

pw = imbinarize(gw);
pk = imbinarize(gk);
%imshow(p);

% find all pieces in image 
cw = bwlabel(pw,4);
ck = bwlabel(pk,4);
%imshow(c);

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

%% displaying total White and Black pieces 
disp(fprintf('White pieces is: %s', whitePieces));
disp(fprintf('Black pieces is: %s', blackPieces));
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
%%
% 
% for i = 1:pieces
%     stats = regionprops(L, 'BoundingBox', 'Centroid', 'MajorAxisLength' ,'MinorAxisLength');
%     rcmax = size(rc);
%     % sets BB to rc1
%     rc1 = stats(i).BoundingBox;
% 
%     % circle my dice!
%     centers = stats(i).Centroid;
%     diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
%     radii = diameters/2;
% 
%     hold on;
%     viscircles(centers,radii);
%     %pause(2);
%     hold off;
% 
%     %%
% 
%     % crop image to dice i
%     test = imcrop(a, rc1); 
%     imshow(test);
% 
%     %disp('Now, select one of the dots, then double click inside of the crop box.');
%     aa = rgb2gray(A);
% 
% 
% %     cropDots = imcrop(test);
% %     imshow(cropDots);
% 
%    % nc2 = normxcorr2(cropDots, test);
%     %gh = imbinarize(nc2);
%     %imshow(nc2);
%        % invert image
%    f = imcomplement(test);
%     imshow(f)
% %%
%     %gets rid of dots on dice
%     e2 = imfill(f, 'holes');
%     imshow(e2);
% 
%     g2 = imerode(e2, se);
%     imshow(g2);
% 
%     h2 = imbinarize(g2);
%     imshow(h2);
%     %%
%     hah = g - a;
%     %hah = imerode(hah, se);
%     imshow(hah);
%     haha = imbinarize(hah);
%     imshow(haha);
%     %%
%     % find all pixels where image is white
%     L2 = bwlabel(h2,4);
% 
%     %find dice number 1
%     [r2, c2] = find(L2==4);
%     rc2 = [r2 c2];
% 
%     % colorful graph showing the different dice
%     m2 = label2rgb(L2);
%     imshow(m2);
% 
%     % this gets the count on objects in image!
%     [L2, dots] = bwlabel(L2);
%     
%     if dots >= 6 
%         dots = 7;
%     end
%     
%     dna(dots) = dna(dots) + 1;
%     
%     % displaying total dots count
%    % disp(sprintf('The total number of dots on this dice is: %d',dots));
%    imshow(A);
%    pause(1);
% end
% %%

