
% Get pieces
O4 = imread('othello/random.jpg');
%Ob = imread('othello/board.jpg');

y = imresize(O4, [400 640]);
[white_centers, white_radii] = imfindcircles(y,[20 50], 'EdgeThreshold', 0.5, 'Sensitivity', 0.8)

z = imcomplement(y);
[black_centers, black_radii] = imfindcircles(im2bw(z),[20 50], 'EdgeThreshold', 0.5, 'Sensitivity', 0.81)


imshow(y);
h = viscircles(white_centers,white_radii,'Color','r');
g = viscircles(black_centers,black_radii,'Color','b');


% Get board outline

yd = double(y)/255;
greenness = yd(:,:,2).*(yd(:,:,2)-yd(:,:,1)).*(yd(:,:,2)-yd(:,:,3));
thresh = 0.3*mean(greenness(greenness>0));
isgreen = greenness > thresh;

props = regionprops(isgreen);

biggest = -1;
for k = 1 : length(props)
    curr_biggest = props(k).BoundingBox(3) * props(k).BoundingBox(4);
    if curr_biggest > biggest
        biggest = curr_biggest;
        biggest_k = k;
    end
end

thisBB = props(biggest_k).BoundingBox;

rectangle('Position', [thisBB], 'EdgeColor','r','LineWidth',2 )

m_x = zeros(1, 9);
m_y = zeros(1, 9);
for i = 1:9
    m_x(i) = thisBB(1) + (i-1) * thisBB(3)/8;
    m_y(i) = thisBB(2) + (i-1) * thisBB(4)/8;
end

for i = 1:8
    for j = 1:8
        pos = [m_x(i) m_y(j) thisBB(3)/8 thisBB(4)/8]
        rectangle('Position', pos, 'EdgeColor','r','LineWidth', 1);
    end
end

%sprintf('White pieces is: %d', whitePieces)
