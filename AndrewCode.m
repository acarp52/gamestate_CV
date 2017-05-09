
O4 = imread('othello/random.jpg');
Ob = imread('othello/board.jpg');

y = imresize(O4, [400 640]);
[white_centers, white_radii] = imfindcircles(y,[20 50], 'Sensitivity', 0.8)

z = imcomplement(y);
[black_centers, black_radii] = imfindcircles(im2bw(z),[20 50], 'Sensitivity', 0.81)


imshow(y);
h = viscircles(white_centers,white_radii);
g = viscircles(black_centers,black_radii);