function [wboard, bboard] = green_seg(filename)

% Get pieces
O4 = imread(filename);


y = imresize(O4, [400 640]);
z = imcomplement(y);



% Get board outline

yd = double(y)/255;
greenness = yd(:,:,2).*(yd(:,:,2)-yd(:,:,1)).*(yd(:,:,2)-yd(:,:,3));
thresh = 0.3*mean(greenness(greenness>0));
isgreen = greenness > thresh;


% More segmentation
inv_isgreen = imcomplement(isgreen);
cc = bwconncomp(inv_isgreen);
data = regionprops(cc);

stats = regionprops('table',cc, rgb2gray(y),'Centroid','Area','MajorAxisLength','MinorAxisLength', 'MeanIntensity');
% Initial filtering
stats = stats(stats.Area > 10,:);

% Only look at pieces
median_area = median(stats.Area);

% To pick out the pieces we want, look only at areas within 15% of the median
stats_f = stats(stats.Area > (median_area - 0.15*median_area) & stats.Area < (0.15*median_area + median_area),:);


b_pieces = stats_f(stats_f.MeanIntensity <= 175,:);

b_centers = b_pieces.Centroid;
b_diameters = mean([b_pieces.MajorAxisLength b_pieces.MinorAxisLength],2);
b_radii = b_diameters/2;

w_pieces = stats_f(stats_f.MeanIntensity > 175,:);

w_centers = w_pieces.Centroid;
w_diameters = mean([w_pieces.MajorAxisLength w_pieces.MinorAxisLength],2);
w_radii = w_diameters/2;

imshow(y);
w = viscircles(w_centers,w_radii,'Color','b');
b = viscircles(b_centers,b_radii,'Color','y');

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

% Draw grid
for i = 1:8
    for j = 1:8
        pos = [m_x(i) m_y(j) thisBB(3)/8 thisBB(4)/8];
        rectangle('Position', pos, 'EdgeColor','r','LineWidth', 1);
    end
end

% Map locations to bard states
wboard = zeros(8);
bboard = zeros(8);
board = ['-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-';
         '-' '-' '-' '-' '-' '-' '-' '-'];
white_count = 0;
black_count = 0;
[w_rows, c] = size(w_centers);
[b_rows, c] = size(b_centers);
for i = 1:8
    for j = 1:8
        pos = [m_x(i) m_y(j) thisBB(3)/8 thisBB(4)/8];
        
        
        
        for w_row = 1:w_rows
            if w_centers(w_row, 1) > m_x(i) && w_centers(w_row, 1) < m_x(i+1)
                if w_centers(w_row, 2) > m_y(j) && w_centers(w_row, 2) < m_y(j+1)
                    wboard(j, i) = 1;
                    board(j, i) = 'w';
                    white_count = white_count + 1;
                end
            end
        end
        
        for b_row = 1:b_rows
            if b_centers(b_row, 1) > m_x(i) && b_centers(b_row, 1) < m_x(i+1)
                if b_centers(b_row, 2) > m_y(j) && b_centers(b_row, 2) < m_y(j+1)
                    bboard(j, i) = 1;
                    board(j, i) = 'b';
                    black_count = black_count + 1;
                end
            end
        end
        
    end
       
end

board
disp(sprintf('White pieces  = %d', white_count));
disp(sprintf('Black pieces  = %d', black_count));
if white_count > black_count
    disp(sprintf('White is winning!'));
elseif white_count < black_count
    disp(sprintf('Black is winning!'));
else
    disp(sprintf('It is a tie game.'));
end 



