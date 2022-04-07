% Function: recover the rotation and scale
% Input: A, B: string of the image path
% Output: string of the output image path
function [imageA_path, imageB_path] = r_s_recover(A, B)
% clear;clc;close all;
image_A = imread(A);
image_B=imread(B);

% import image capture from image_A
% image_B0=imcrop(image_A,[5,5,500,700]);
% image_B = imrotate(image_B0,-30);
% image_B=imresize(image_B0,1.1);
% image_B=imresize(image_B0,1.5);
% image_B=imrotate(image_B,40);
image_C=image_B;
[image_B,image_A]=larger_and_smaller(image_B,image_A);
[r_B,center_B_ind]=R_and_centerind(image_B(:,:,1));
[r_A,center_A_ind]=R_and_centerind(image_A(:,:,1));
%% compute scale roughly
[image_B,~,~,scale1]=recover_angle_or_scale(image_B,image_A,'scale_rough');
%% compute angle rotate
[image_B,c1,angle1,~]=recover_angle_or_scale(image_B,image_A,'angle');
%imshow(image_B)
% figure
%         surf(c1) 
%         shading flat % draw results
%% compute scaling accurately
[image_B,c2,~,scale2]=recover_angle_or_scale(image_B,image_A,'scale_acc');
%imshow(image_B)
%% final_result
a=0.42; % test_21 and test_22
% a=0;
final_result=[angle1,(scale1)*(scale2-a*scale2^2)];
final_image_Rotate_scale=imrotate(image_C,angle1);
final_image_Rotate_scale=imresize(final_image_Rotate_scale,1/final_result(2));
% imshowpair(image_A(:,:,1),final_image_Rotate_scale,"blend");
% if the final_image isn't parallel to the x-axis
% final_image=rotate_unparallel(final_image,angle);
figure
imageA_path = "./img_src/img_recover_r_s_1.png";
imageB_path = "./img_src/img_recover_r_s_2.png";
imwrite(final_image_Rotate_scale, imageB_path);
imwrite(image_A, imageA_path);
% imshow(final_image_Rotate_scale);
