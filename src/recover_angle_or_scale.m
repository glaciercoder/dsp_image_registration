function [image_Rec,c,angle,scale] = recover_angle_or_scale(image_large,image_small,AOS)
% ATTENTION: The meaning of the angle is that the smaller image is rotated
% 'angle' degree from the larger image.All angles are transformed into
% anticloskwise angles which are in the range of [0,360].
% ATTENTION: The meaning of the scale is Size(larger_image)/Size(smaller_image),so the value of scale is always
% greater than 1.
% ATTENTION: Some time the final image isn't parallel to the x-axis.The
% reson is that we choose the larger image as the standard image,rotate
% and scale the smaller one to match the larger one.Please use the
% founction 'ROTATE_UNPARALLEL'to solve this problem.
FA=image_small(:,:,1);
FB=image_large(:,:,1);
[r_FB,center_FB_ind]=R_and_centerind(FB);
[r_FA,center_FA_ind]=R_and_centerind(FA);
Rmax=r_FB;
angle=0;scale=0;
%% compute xcorr2
if strcmp(AOS,'angle')
    Rmin=50;
    Rmin=0.05*r_FB;
    FB_lp = logsample(FB, Rmin, Rmax, center_FB_ind(2), center_FB_ind(1),2*Rmax, 360);
    FA_lp = logsample(FA, Rmin, Rmax, center_FA_ind(2), center_FA_ind(1), 2*Rmax,360);
    
    c = normxcorr2(FA_lp,FB_lp);
    [max_c,imax] = max(abs(c(:)));
    [ypeak,~] = ind2sub(size(c),imax(1));
    
    % recover angle,make sure angle in the range of [0,360]
    angle=ypeak-size(FA_lp,1);
    if angle<0
        angle=angle+360;
    end
    image_Rec=imrotate(image_large,angle,'crop');
elseif strcmp(AOS,'scale_acc')
    Rmin=0.002*r_FB;Rmax=r_FB;
    r_FB
    FB_lp = logsample(FB, Rmin, Rmax, center_FB_ind(2), center_FB_ind(1),Rmax, 360);
    FA_lp = logsample(FA, Rmin, Rmax, center_FA_ind(2), center_FA_ind(1), Rmax,360);
   
    c = normxcorr2(FA_lp,FB_lp);
    [max_c,imax] = max(abs(c(:)));
    [~,xpeak] = ind2sub(size(c),imax(1));

    % recover scale
    NR=Rmax;
    xpeak
    scale=(Rmax-Rmin)^((xpeak-Rmax)/(NR-1));
    scale
    if scale<0.05 | scale>5
        scale=1;
    end
    image_Rec=imresize(image_large,1/scale);
elseif strcmp(AOS,'scale_rough')
    Rmin=70;Rmax=r_FB;
    FB_lp = logsample(FB, Rmin, Rmax, center_FB_ind(2), center_FB_ind(1),Rmax, 360);
    FA_lp = logsample(FA, Rmin, Rmax, center_FA_ind(2), center_FA_ind(1), Rmax,360);
   
    c = normxcorr2(FA_lp,FB_lp);
    [max_c,imax] = max(abs(c(:)));
    [~,xpeak] = ind2sub(size(c),imax(1));

    % recover scale
    NR=Rmax;
    scale=(Rmax-Rmin)^((xpeak-Rmax)/(NR-1));
%     if scale<0.05 | scale>5
%         scale=1;
%     end
    scale
    image_Rec=imresize(image_large,1/scale);
else
    error('please choose angle or scale to recover');
end
end