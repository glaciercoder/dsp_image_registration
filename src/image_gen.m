% function description: generate a pair of image to be registrated
% Input: origin image path
% ouput: generated image path
function [imageA_path, imageB_path] = image_gen(origin1, origin2)
% Use origin1 as A by deault
image_A = imread(origin1);
imageA_path = origin1;

image_B = imread(origin2);
image_B=imresize(image_B,2);
image_B=imrotate(image_B,45);
imageB_path = "./img_src/pair.png";
imwrite(image_B, imageB_path);

imshow(image_B)
imshow(image_A)


