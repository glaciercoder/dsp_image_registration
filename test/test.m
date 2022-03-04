
% Read image
temp1 = imread("test_1.png");
temp2 = imread("test_2.png");

% Set image_A to be the image of larger size
if(sum(size(temp1)) < sum(size(temp2)))
    image_A = temp2;
    image_B = temp1;
else
    image_A = temp1;
    image_B = temp2;
end

% Variables 
[row_B, col_B] = size(image_B(:,:,1));
[row_A,col_A] = size(image_A(:,:,1));
max_N_last = 0; % The index the sum exceeds T
rect_window = [0,0,0,0]; % rectange used to generate the window
temp_image = uint8(zeros(size(image_A)+size(image_B)));
recovered_image = temp_image(:,:,1:3);
% Crop the smaller image into 4 parts to generate the window

% This is executed if A and B have similar size
center_B_ind = [round(row_B / 2),round(col_B / 2)]; % index of the center of image B
if ((row_B * col_B) > (row_A * col_A / 2))
    for ii = 1:4
        switch ii
            case 1
                rect_B = [1 , 1, center_B_ind(2), center_B_ind(1)];
            case 2
                rect_B = [center_B_ind(2), 1, col_B, center_B_ind(1)];
            case 3
                rect_B = [1, center_B_ind(1), center_B_ind(2), row_B];
            case 4
                rect_B = [center_B_ind(2), center_B_ind(1), col_B, row_B];
        end
        window = imcrop(image_B, rect_B);
        % Using SSDA for each part, select the most similar
        N = max_threshold_ind(image_A,window,1);
        [max_N,imax] = max(abs(N(:)));
        
%         figure
%         surf(N) 
%         shading flat % draw results
        
        if(max_N > max_N_last) 
            max_N_last = max_N;
            rect_window = rect_B;
        end
    end
% If A and B have the similar size    
else
    N = max_threshold_ind(image_A,image_B,4);
    [max_N,imax] = max(abs(N(:)));
    rect_window = [1,1,col_B,row_B];
end


% Choose subregions of each image using SSDA
[ypeak_N,xpeak_N] = ind2sub(size(N),imax(1));
row_s = row_A; col_s = col_A; % Use whole as the searching area
rec_s_width = round(col_s) / (1.5); % Use a smaller area of image_A
rec_s_height = round(row_s) / (1.5);
rect_s = [xpeak_N,ypeak_N,xpeak_N+rec_s_width,ypeak_N+rec_s_height];
window = imcrop(image_B,rect_window);
searching_area = imcrop(image_A,rect_s);

% imshow(sub_onion)
% imshow(sub_peppers)

% calculate the correlation
c = normxcorr2(window(:,:,1),searching_area(:,:,1));
% figure
% surf(c) 
% shading flat 
% % Calculate the total offset
% % offset found by correlation
[max_c,imax] = max(abs(c(:)));
[ypeak,xpeak] = ind2sub(size(c),imax(1));
corr_offset = [(xpeak-size(window,2)) 
               (ypeak-size(window,1))];
% 
% % relative offset of position of subimages
rect_offset = [(rect_s(1)-rect_window(1)) 
               (rect_s(2)-rect_window(2))];
% 
% % total offset
offset = corr_offset + rect_offset;
xoffset = offset(1);
yoffset = offset(2);
% 
% 
% % See if Onion Image was Extracted from Peppers Image
xbegin = round(xoffset + 1);
xend   = round(xoffset + size(image_B,2));
ybegin = round(yoffset + 1);
yend   = round(yoffset + size(image_B,1));

 
% % Pad Onion Image to Size of Peppers Image

recovered_image(ybegin:yend,xbegin:xend,:) = image_B;
% imshow(recovered_onion)
% 
imshowpair(image_A(:,:,1),recovered_image,"blend")



