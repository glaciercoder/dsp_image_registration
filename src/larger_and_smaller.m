function [image_A,image_B] = larger_and_smaller(temp1,temp2)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
if(sum(size(temp1)) < sum(size(temp2)))
    image_A = temp2;
    image_B = temp1;
else
    image_A = temp1;
    image_B = temp2;
end
end