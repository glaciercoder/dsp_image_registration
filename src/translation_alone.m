%% import data
clear;clc;close all;
% Read image
temp1 = imread("./img_src/test.png");
temp2 = imread("./img_src/test_2.png");
my_K=image(temp1(:,:,1));
% Set image_A to be the image of larger size
[image_A,image_B]=larger_and_smaller(temp2,temp1);
% if(sum(size(temp1)) < sum(size(temp2)))
%     image_A = temp2;
%     image_B = temp1;
% else
%     image_A = temp1;
%     image_B = temp2;
% end

% Variables 
[row_B, col_B] = size(image_B(:,:,1));
[row_A,col_A] = size(image_A(:,:,1));
max_N_last = 0; % The index the sum exceeds T
rect_window = [0,0,0,0]; % rectange used to generate the window
temp_image = uint8(zeros(size(image_A)+size(image_B))); % 转换数据类型，使得变为image所规定的类型
recovered_image = temp_image(:,:,1:3); % 最终还是三通道
% Crop the smaller image into 4 parts to generate the window
%% When B is very large , crop B
% This is executed if A and B have similar size
center_B_ind = [round(row_B / 2),round(col_B / 2)]; % index of the center of image B  四舍五入
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
        
        if(max_N > max_N_last) 
            max_N_last = max_N;
            rect_window = rect_B;
        end
    end
% If A and B have the similar size    
else
    N = max_threshold_ind(image_A,image_B,4); 
    [max_N,imax] = max(abs(N(:)));  % imax为最大的元素所对应的一维索引
    rect_window = [1,1,col_B,row_B];
end

%% 选定S（A)搜索图和T（B）模板图
% Choose subregions of each image using SSDA
[ypeak_N,xpeak_N] = ind2sub(size(N),imax(1));% 找出最大的元素的下标，行与列

row_s = row_A; col_s = col_A; % Use whole as the searching area
rec_s_width = round(col_s/1.5); % Use a smaller area of image_A
rec_s_height = round(row_s/1.5);% 可调参

rect_s = [xpeak_N,ypeak_N,xpeak_N+rec_s_width,ypeak_N+rec_s_height];
window = imcrop(image_B,rect_window); %rect_window是一个数组，它记录了所需要的裁剪的模板图的大小，有时就是B
% 有时需要裁剪一下当B很大时
searching_area = imcrop(image_A,rect_s); % 从"最大"的附近找出一块搜索区

% imshow(sub_onion)
% imshow(sub_peppers)
% 这样的判断形状相似程度合理吗？
%% 计算互相关
% calculate the correlation（互相关）
c = normxcorr2(window(:,:,1),searching_area(:,:,1));
% figure
% surf(c) %三维曲面图
% shading flat 
% % Calculate the total offset
% % offset found by correlation

[max_c,imax] = max(abs(c(:)));
[ypeak,xpeak] = ind2sub(size(c),imax(1));% 找到最大数max_c的索引下标位置
%% 刚体位移恢复
corr_offset = [(xpeak-size(window,2)) 
               (ypeak-size(window,1))];% x表示列，y表示行
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



