% Get pieces
O4 = imread('othello/DSC_2793.jpg');
Ob = imread('othello/board.jpg');


y = imresize(O4, [400 640]);
[white_centers, white_radii] = imfindcircles(y,[20 50], 'Sensitivity', 0.8)

z = imcomplement(y);
[black_centers, black_radii] = imfindcircles(im2bw(z),[20 50], 'EdgeThreshold', 0.35, 'Sensitivity', 0.81)


imshow(y);
h = viscircles(white_centers,white_radii,'Color','r');
g = viscircles(black_centers,black_radii,'Color','b');


% Get board outline

yd = double(y)/255;
greenness = yd(:,:,2).*(yd(:,:,2)-yd(:,:,1)).*(yd(:,:,2)-yd(:,:,3));
thresh = 0.3*mean(greenness(greenness>0));
isgreen = greenness > thresh;


% More segmentation
inv_isgreen = imcomplement(isgreen);
cc = bwconncomp(inv_isgreen);
data = regionprops(cc);

stats = regionprops('table',cc,'Centroid','Area','MajorAxisLength','MinorAxisLength')


stats_f = stats(stats.Area > 900 & stats.Area < 1100,:)

centers = stats_f.Centroid;
diameters = mean([stats_f.MajorAxisLength stats_f.MinorAxisLength],2);
radii = diameters/2;

imshow(y);
viscircles(centers,radii);