function image_r= rotate_unparallel(image,angle)
% When the final image isn't parallel to the x-axis,use this founction.
image_r=imrotate(image,-angle);
end